Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422943Ab2LGQwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 11:52:22 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:57937 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422904Ab2LGQwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 11:52:20 -0500
Date: Fri, 7 Dec 2012 17:52:18 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
        Li Shaohua <shaohua.li@intel.com>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Look Ma, da kernel is b0rken
Message-ID: <20121207165218.GA13421@rhlx01.hs-esslingen.de>
References: <20121205070901.GA12123@rhlx01.hs-esslingen.de>
 <20121205142935.GA12119@liondog.tnic>
 <20121205152756.5afec12c@pyramind.ukuu.org.uk>
 <20121205153121.GA28556@liondog.tnic>
 <20121205133853.770451ca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121205133853.770451ca.akpm@linux-foundation.org>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Dec 05, 2012 at 01:38:53PM -0800, Andrew Morton wrote:
> Bjorn had a review comment which appears to remain unaddressed:
> 
> : The original is definitely broken.
> : 
> : I think the corrected test allows PNP IDs containing '@', which
> : doesn't appear legal per sec 6.1.5 of the ACPI 5.0 spec.  Should this
> : be
> : 
> : +       if (!('A' <= (c) && (c) <= 'Z')) \
> : 
> : instead?

I hate having to rain on the parade again ;)
I just developed some doubts, by accident again,
by getting dangerously near sound/isa/als100.c snd_als100_pnpids:
there are many IDs with '@' embedded (at least in this ISA-based PnP code),
thus I guess that code may have had its justification (unless ACPI 5.0
is clearly fully authoritative for this space and thus '@' does not have any
business there any more).

Dito e.g. isa/cmi8330.c.

Hmm, anyone deeply familiar with ISA PnP ID magic? :)

Andreas Mohr
