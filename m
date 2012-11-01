Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256Ab2KALFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 07:05:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36670 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014Ab2KALFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 07:05:16 -0400
Date: Thu, 1 Nov 2012 12:05:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC EDAC/GHES] edac: lock module owner to avoid error report
 conflicts
Message-ID: <20121101110512.GA31271@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Tony Luck <tony.luck@intel.com>,
	Linux Edac Mailing List <linux-edac@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <048a00fa4a888b349be5954ce9fd063a7bcf2564.1351691230.git.mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <048a00fa4a888b349be5954ce9fd063a7bcf2564.1351691230.git.mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Tony.

On Wed, Oct 31, 2012 at 11:58:15AM -0200, Mauro Carvalho Chehab wrote:
> There's a know bug that happens when apei/ghes is loaded together
> with an EDAC module: the same error is reported several times,
> as ghes calls mcelog, with, in tune, calls edac.

This is exactly why I think APEI is crap. So it is a completely useless
additional layer between the MCA code and the rest.

The #MC handler runs, logs the error, and then a split happens which
runs in parallel:

* we do mce_log which carries the error to EDAC
* we enter APEI, do some mumbo jumbo and then do mce_log AGAIN! Wtf?

So, in order to sort this out properly, let's take a step back first:
what do we actually want to do?

* the error coming from APEI still needs to get decoded by EDAC? If yes,
then WTF we need APEI for anyway?

* the error coming from APEI is already decoded, so no need for EDAC? I
highly doubt that.

* add a filter to the MCE code so that certain types of errors are not
reported by it but by APEI so that the double reporting doesn't happen?

Right about now, I'm open for hints as to why we need that APEI crap at
all. And I don't want to hear that "clear interface so that OS coders
don't need to know the hardware" bullshit argument from the sick world
of windoze.

Thanks.

-- 
Regards/Gruss,
    Boris.
