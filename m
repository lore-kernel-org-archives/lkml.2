Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761218Ab0GTUHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:07:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59886 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760565Ab0GTUHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:07:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c/9uW4P/xzR5p8kwtxcCFZOrKJlr5dxEj2an5PYQxqJGL4IACgH+8rVWpt/cdLykYi
         lg1f35VMBfZtGGyeuZON65OjQFsszloRcd16MvS3yO+MSGy/qzRYb+Tx9xViSyVyIzzA
         OI8bciarzwSvOmHlQmE4kz/SDZYgTPawdwb9s=
Date: Wed, 21 Jul 2010 00:07:29 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] x86, xsave: some code cleanups and reworks
Message-ID: <20100720200729.GD6227@lenovo>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com> <20100720192717.GC6227@lenovo> <20100720194606.GO26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100720194606.GO26154@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 09:46:06PM +0200, Robert Richter wrote:
> On 20.07.10 15:27:17, Cyrill Gorcunov wrote:
> > On Tue, Jul 20, 2010 at 08:50:47PM +0200, Robert Richter wrote:
> > >
> > > This patch series contains some cleanups and reworks I made during
> > > code review and feature implementation for upcoming cpus.
> > > 
> > > Most patches refactor the xsave initialization that is very dependent
> > > on fpu initialization. This series starts to decouple this a little
> > > bit as xsave not only supports fpu features. Also this is an attempt
> > > to ease the xsave interface by making some of the functions and
> > > variables static.
> > > 
> > > There is also one patch that removes boot_cpu_id variable, which is
> > > not really related to xsave. Maybe this should be applied to another
> > > branch.
> > > 
> > > The patches are relative to today's tip/x86/xsave branch.
> > > 
> > > (The patches are small for better review and rebasing.)
> > > 
> > > -Robert
> > > 
> > 
> > Hi Robert, I recall there was a thread related to boot_cpu_id and
> > cpu = 0. Unfortunately I can't find it neither in my mbox nor somewhere
> > in net at moment.
> 
> I found this patch:
> 
>  b3572e3 x86/voyager: fix compile breakage caused by dc1e35c6e95e8923cf1d3510438b63c600fee1e2
> 
> indicating that boot cpu id could be different than 0.
> 

yeah, I forgot about voyager indeed but seems this is quite specific
to voyager trick

> But either this is broken again, or the issue is gone in a different
> way.
> 
> > Ie technically speaking -- yes boot_cpu_id will be 0
> > but perhaps instead of magic !cpu and friends explicit boot_cpu_id might
> > be better for code reading. It might be is_boot_cpu() macro helper or
> > so as well.
> > 
> > Though I don't have strong opinion but for ones who will be
> > reading the code first time it might be confusing :) Agreed?
> 
> That's true, but once you know...
> 

yes, but before you know ;)

> I could make a follow on patch with an is_boot_cpu() macro. Ingo, what
> do you think?
> 
> But first question is, is it always !smp_processor_id()? At least
> current implementation indicates this:
> 

I guess so, since it's assigned from boot_cpu_id iirc

>  void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
>  {
>  	BUG_ON(c == &boot_cpu_data);
>  	...
> 
> with:
> 
>  #define boot_cpu_data cpu_data[0]
> 
> ... which is valid for 32 and 64 bit.
> 

I suppose this is just self-protection for "what if something will go
wrong and this will be called on non-BP cpu".

> -Robert
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center
> 
	-- Cyrill
