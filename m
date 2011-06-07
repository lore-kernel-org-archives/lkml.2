Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab1FGH2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 03:28:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40897 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055Ab1FGH2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 03:28:17 -0400
Date: Tue, 7 Jun 2011 09:28:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [PATCH] kvm: Fix build warnings
Message-ID: <20110607072813.GC21263@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, kvm@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
References: <20110530124600.GB494@eferding.osrc.amd.com>
 <1306786278-12219-1-git-send-email-bp@alien8.de>
 <20110531073824.GA17999@elte.hu>
 <4DE4A4E7.80503@redhat.com>
 <20110531102655.GC24172@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110531102655.GC24172@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 12:26:55PM +0200, Ingo Molnar wrote:
> 
> * Avi Kivity <avi@redhat.com> wrote:
> 
> > On 05/31/2011 10:38 AM, Ingo Molnar wrote:
> > >* Borislav Petkov<bp@alien8.de>  wrote:
> > >
> > >>  +++ b/arch/x86/kvm/paging_tmpl.h
> > >>  @@ -121,7 +121,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
> > >>   				gva_t addr, u32 access)
> > >>   {
> > >>   	pt_element_t pte;
> > >>  -	pt_element_t __user *ptep_user;
> > >>  +	pt_element_t __user *uninitialized_var(ptep_user);
> > >
> > >Note that doing this is actually actively dangerous for two reasons.
> > >
> > >
> > 
> > <snip lots of good advice>
> > 
> > > Please fix it instead.
> > 
> > s/instead/in addition/; while all those changes are good, they are 
> > much too large for 3.0.  Let's push the simple fix for 3.0 and 
> > queue the bigger refactoring to 3.1.
> 
> Yeah, that's probably wise, this is a tricky function.

So, any progress on this front? Warning is still there in -rc2.

Thanks.

-- 
Regards/Gruss,
    Boris.
