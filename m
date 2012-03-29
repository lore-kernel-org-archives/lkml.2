Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744Ab2C2UuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:50:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40006 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab2C2UuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:50:11 -0400
Message-ID: <4F74CAEA.1010606@zytor.com>
Date: Thu, 29 Mar 2012 13:49:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Matt Fleming <matt.fleming@intel.com>,
        Trevor Turner <turn3r.tr3v0r@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: K7/Athlon Optimization Causes Build Fail on Kernel 3.3 i686
References: <CANYHJ6jjuO7yV_kbPsnJ6X+KXrsz2PRPPXHN4Rkr-vgoSG-E4A@mail.gmail.com> <20120328111957.GA6765@x1.osrc.amd.com> <CANYHJ6j6cxz47TGk8kdU58eau17Fi1K=fH2icmd=v19VjNggKw@mail.gmail.com> <20120328171059.GA7919@x1.osrc.amd.com> <4F7346BB.9020907@xenotime.net> <20120328172759.GC6765@x1.osrc.amd.com> <20120329074802.GA31955@liondog.tnic> <1333008855.4289.3.camel@mfleming-mobl1.ger.corp.intel.com> <20120329104822.GA17233@x1.osrc.amd.com> <4F74A9D8.1040808@zytor.com> <20120329204622.GA8655@liondog.tnic>
In-Reply-To: <20120329204622.GA8655@liondog.tnic>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 01:46 PM, Borislav Petkov wrote:
> On Thu, Mar 29, 2012 at 11:28:40AM -0700, H. Peter Anvin wrote:
>> I like this one for urgent as a quick fix, but it doesn't solve the real
>> problem which is that boot/compressed shouldn't pick up these macros at all.
> 
> But it does through:
> 
> <arch/x86/include/asm/string_32.h>:
> 

That's the problem... it shouldn't use that.

> 
>> It should be possible to build with MK7 (which is an optimization
>> option) and EFI (a functionality option) since they don't inherently
>> conflict.  It just doesn't necessarily have to happen *right now*.
> 
> I know, technically it is doable, but do you see a K7 box with an EFI
> firmware? I, at least, don't think so... :-)
> 
> Now, if you think that those optimizations could be used on other boxes
> which could sport EFI, then that's a whole another question...
> 

What I'm saying, mostly, is that this is indicative of a bigger bug.

	-hpa
