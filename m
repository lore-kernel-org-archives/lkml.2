Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab2CHL3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:29:10 -0500
Received: from mga07.intel.com ([143.182.124.22]:24644 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752541Ab2CHL3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:29:05 -0500
Subject: Re: [tip:x86/urgent] x86, efi: Delete efi_ioremap() and fix
 CONFIG_X86_32 oops
From: Matt Fleming <matt.fleming@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>, mingo@redhat.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, keithp@keithp.com, rui.zhang@intel.com,
        huang.ying.caritas@gmail.com, stable@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <CAE9FiQUoRMA_PYnOEt0ZUYXLq=hNZtDuLifT=+R72HtrwfF6AA@mail.gmail.com>
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org>
	 <tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org>
	 <CAE9FiQWFpsZotawqPD4738jTayB=KOGo0W9+AT2go3GYk1v_sQ@mail.gmail.com>
	 <4F45B35D.1010702@zytor.com>
	 <CAE9FiQUbyYYN5orG_RyVm=P-8wNh=YsET1VzGojpFTfJPueHqA@mail.gmail.com>
	 <4F471651.3080609@zytor.com> <4F4C3BA2.1070708@kernel.org>
	 <1331116250.3539.35.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAE9FiQUoRMA_PYnOEt0ZUYXLq=hNZtDuLifT=+R72HtrwfF6AA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Thu, 08 Mar 2012 11:28:47 +0000
Message-ID: <1331206127.3539.69.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 10:05 -0800, Yinghai Lu wrote:
> > -
> > -       max_low_pfn_mapped = init_memory_mapping(0, end_pfn << PAGE_SHIFT);
> > -       max_pfn_mapped = max_low_pfn_mapped;
> > +       /* max_low_pfn_mapped is updated here */
> > +       max_pfn_mapped = init_memory_mapping();
> >
> >  #ifdef CONFIG_X86_64
> >        if (max_pfn > max_low_pfn) {
> > -               max_pfn_mapped = init_memory_mapping(1UL<<32,
> > -                                                    max_pfn<<PAGE_SHIFT);
> >                /* can we preseve max_low_pfn ?*/
> >                max_low_pfn = max_pfn;
> >        }
> 
> you may need to move those three lines before
> max_pfn_mapped = init_memory_mapping()
> 
> otherwise for x86_64, memory from [4G, TOMH) will not be directly mapped.

I'm afraid I don't understand what you mean. The changes in my patch
mean that init_memory_mapping() doesn't work the way it previously did.
It will map all the regions in the e820 table and presumably the top of
memory is contained within one of those regions.

Could you clarify what you think the problem is? Unfortunately I don't
have a test machine with large amounts of RAM so it's entirely possible
I've made a mistake somewhere.

