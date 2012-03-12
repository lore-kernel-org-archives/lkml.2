Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab2CLMiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 08:38:52 -0400
Received: from mga10.intel.com ([192.55.52.92]:29931 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754152Ab2CLMit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 08:38:49 -0400
Subject: Re: [tip:x86/urgent] x86, efi: Delete efi_ioremap() and fix
 CONFIG_X86_32 oops
From: Matt Fleming <matt.fleming@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>, mingo@redhat.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, keithp@keithp.com, rui.zhang@intel.com,
        huang.ying.caritas@gmail.com, stable@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <CAE9FiQVZVNARgs0rzgRpRdbSPydCXoeDat=4DLMNFcyBQuqwng@mail.gmail.com>
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org>
	 <tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org>
	 <CAE9FiQWFpsZotawqPD4738jTayB=KOGo0W9+AT2go3GYk1v_sQ@mail.gmail.com>
	 <4F45B35D.1010702@zytor.com>
	 <CAE9FiQUbyYYN5orG_RyVm=P-8wNh=YsET1VzGojpFTfJPueHqA@mail.gmail.com>
	 <4F471651.3080609@zytor.com> <4F4C3BA2.1070708@kernel.org>
	 <1331116250.3539.35.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAE9FiQUoRMA_PYnOEt0ZUYXLq=hNZtDuLifT=+R72HtrwfF6AA@mail.gmail.com>
	 <1331206127.3539.69.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAE9FiQVZVNARgs0rzgRpRdbSPydCXoeDat=4DLMNFcyBQuqwng@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Mon, 12 Mar 2012 12:38:36 +0000
Message-ID: <1331555916.3539.88.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 10:59 -0800, Yinghai Lu wrote:
> On Thu, Mar 8, 2012 at 3:28 AM, Matt Fleming <matt.fleming@intel.com> wrote:
> > On Wed, 2012-03-07 at 10:05 -0800, Yinghai Lu wrote:
> >> > -
> >> > -       max_low_pfn_mapped = init_memory_mapping(0, end_pfn << PAGE_SHIFT);
> >> > -       max_pfn_mapped = max_low_pfn_mapped;
> >> > +       /* max_low_pfn_mapped is updated here */
> >> > +       max_pfn_mapped = init_memory_mapping();
> >> >
> >> >  #ifdef CONFIG_X86_64
> >> >        if (max_pfn > max_low_pfn) {
> >> > -               max_pfn_mapped = init_memory_mapping(1UL<<32,
> >> > -                                                    max_pfn<<PAGE_SHIFT);
> >> >                /* can we preseve max_low_pfn ?*/
> >> >                max_low_pfn = max_pfn;
> >> >        }
> >>
> >> you may need to move those three lines before
> >> max_pfn_mapped = init_memory_mapping()
> >>
> >> otherwise for x86_64, memory from [4G, TOMH) will not be directly mapped.
> >
> > I'm afraid I don't understand what you mean. The changes in my patch
> > mean that init_memory_mapping() doesn't work the way it previously did.
> > It will map all the regions in the e820 table and presumably the top of
> > memory is contained within one of those regions.
> >
> > Could you clarify what you think the problem is? Unfortunately I don't
> > have a test machine with large amounts of RAM so it's entirely possible
> > I've made a mistake somewhere.
> 
> in your new init_memory_mapping will only map memory below max_low_pfn.

That's true on CONFIG_X86_32. But on CONFIG_X86_64 we map anything in
the e820 map.

> but the max_low_pfn is under 4g.
> 
> So it will be ended up with 4G above memory is not mapped.

Have you tested my patch? Have you hit this bug or is it just from code
inspection. I'm starting to feel a bit silly now because I can't see the
problem you're describing.

