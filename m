Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab2E3JIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 05:08:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41374 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272Ab2E3JIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 05:08:48 -0400
Date: Wed, 30 May 2012 11:08:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: ShuoX Liu <shuox.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org,
        Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] x86 mce: use new printk recursion disabling interface
Message-ID: <20120530090844.GA23663@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	ShuoX Liu <shuox.liu@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Yanmin Zhang <yanmin_zhang@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org,
	Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>
References: <4FBC444A.6060500@intel.com>
 <20120523100138.GA13506@x1.osrc.amd.com>
 <4FBDCE4A.7050900@intel.com>
 <20120524061145.GA18284@liondog.tnic>
 <20120524155611.b7aeff4d.akpm@linux-foundation.org>
 <1337905811.14538.206.camel@ymzhang.sh.intel.com>
 <4FBF3295.7090608@intel.com>
 <4FBF32E8.90101@intel.com>
 <20120525074114.GA5417@liondog.tnic>
 <4FC2DDFF.3020600@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FC2DDFF.3020600@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 10:07:59AM +0800, ShuoX Liu wrote:
> Boris,
> I checked code and found some other functions in do_machine_check() also
> would printk something. Such as add_taint(). So i think we'd better
> place the recursion check at the beginning and the end of
> do_machine_check(). Also more printks later(maybe) added will benefit
> from this. Do you agree?

I'm not sure we want to disable printk recursion for add_taint() - it
doesn't spit out any useful information wrt MCE so we could ignore it.

Btw, I forgot to ask: this printk recursion disabling, do you have a
real usecase where you don't get the MCE info in dmesg and with your
patch it works or is this purely hypothetical?

Thanks.

-- 
Regards/Gruss,
    Boris.
