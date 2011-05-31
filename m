Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab1EaIVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:21:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758078Ab1EaIVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:21:24 -0400
Message-ID: <4DE4A4E7.80503@redhat.com>
Date: Tue, 31 May 2011 11:20:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Borislav Petkov <bp@alien8.de>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [PATCH] kvm: Fix build warnings
References: <20110530124600.GB494@eferding.osrc.amd.com> <1306786278-12219-1-git-send-email-bp@alien8.de> <20110531073824.GA17999@elte.hu>
In-Reply-To: <20110531073824.GA17999@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2011 10:38 AM, Ingo Molnar wrote:
> * Borislav Petkov<bp@alien8.de>  wrote:
>
> >  +++ b/arch/x86/kvm/paging_tmpl.h
> >  @@ -121,7 +121,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
> >   				gva_t addr, u32 access)
> >   {
> >   	pt_element_t pte;
> >  -	pt_element_t __user *ptep_user;
> >  +	pt_element_t __user *uninitialized_var(ptep_user);
>
> Note that doing this is actually actively dangerous for two reasons.
>
>

<snip lots of good advice>

> Please fix it instead.

s/instead/in addition/; while all those changes are good, they are much 
too large for 3.0.  Let's push the simple fix for 3.0 and queue the 
bigger refactoring to 3.1.

-- 
error compiling committee.c: too many arguments to function

