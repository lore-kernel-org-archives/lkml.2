Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab1EaIQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:16:00 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:48042 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab1EaIP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:15:58 -0400
Date: Tue, 31 May 2011 17:19:27 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@alien8.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, takuya.yoshikawa@gmail.com
Subject: Re: [PATCH] kvm: Fix build warnings
Message-Id: <20110531171927.38d4b0f7.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20110531073824.GA17999@elte.hu>
References: <20110530124600.GB494@eferding.osrc.amd.com>
	<1306786278-12219-1-git-send-email-bp@alien8.de>
	<20110531073824.GA17999@elte.hu>
X-Mailer: Sylpheed 3.1.0beta2 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 31 May 2011 09:38:24 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Borislav Petkov <bp@alien8.de> wrote:
> 
> > +++ b/arch/x86/kvm/paging_tmpl.h
> > @@ -121,7 +121,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
> >  				    gva_t addr, u32 access)
> >  {
> >  	pt_element_t pte;
> > -	pt_element_t __user *ptep_user;
> > +	pt_element_t __user *uninitialized_var(ptep_user);
> 
> Note that doing this is actually actively dangerous for two reasons.
> 
> Firstly, it also shuts down the warning when it turns into a *real* 
> warning. For example this function will not produce a warning:
> 
>  int test(int a)
>  {
>         int uninitialized_var(b);
> 
>         return b;
>  }
> 
> Secondly, if the *compiler* cannot understand the flow then the code 
> is obviously rather complex for humans to review. So if there's an 
> initialization bug in the future, the risk of a human not seeing it 
> and the risk of uninitialized_var() hiding it is larger.
> 
> So the recommended thing is to simplify the flow there to make it 
> easier for the compiler to see through it.


Thank you for your advice.

Borislav, would you like to do the fix suggested here?

As the person who introduced this warning, if these are too many
for you, I will try some of these.

  Takuya
