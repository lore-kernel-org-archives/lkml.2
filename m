Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1EaK1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 06:27:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34737 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab1EaK1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 06:27:11 -0400
Date: Tue, 31 May 2011 12:26:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [PATCH] kvm: Fix build warnings
Message-ID: <20110531102655.GC24172@elte.hu>
References: <20110530124600.GB494@eferding.osrc.amd.com>
 <1306786278-12219-1-git-send-email-bp@alien8.de>
 <20110531073824.GA17999@elte.hu>
 <4DE4A4E7.80503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE4A4E7.80503@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 05/31/2011 10:38 AM, Ingo Molnar wrote:
> >* Borislav Petkov<bp@alien8.de>  wrote:
> >
> >>  +++ b/arch/x86/kvm/paging_tmpl.h
> >>  @@ -121,7 +121,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
> >>   				gva_t addr, u32 access)
> >>   {
> >>   	pt_element_t pte;
> >>  -	pt_element_t __user *ptep_user;
> >>  +	pt_element_t __user *uninitialized_var(ptep_user);
> >
> >Note that doing this is actually actively dangerous for two reasons.
> >
> >
> 
> <snip lots of good advice>
> 
> > Please fix it instead.
> 
> s/instead/in addition/; while all those changes are good, they are 
> much too large for 3.0.  Let's push the simple fix for 3.0 and 
> queue the bigger refactoring to 3.1.

Yeah, that's probably wise, this is a tricky function.

Thanks,

	Ingo
