Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab2CIKtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 05:49:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:8742 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab2CIKti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 05:49:38 -0500
Subject: Re: [tip:x86/urgent] x86, efi: Delete efi_ioremap() and fix
 CONFIG_X86_32 oops
From: Matt Fleming <matt.fleming@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>, mingo@redhat.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, keithp@keithp.com, rui.zhang@intel.com,
        huang.ying.caritas@gmail.com, stable@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <CAE9FiQWrh5fOzAj_f03iqF+pQjGExvzppVoeJjwnp0p030jDPA@mail.gmail.com>
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org>
	 <tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org>
	 <CAE9FiQWFpsZotawqPD4738jTayB=KOGo0W9+AT2go3GYk1v_sQ@mail.gmail.com>
	 <4F45B35D.1010702@zytor.com>
	 <CAE9FiQUbyYYN5orG_RyVm=P-8wNh=YsET1VzGojpFTfJPueHqA@mail.gmail.com>
	 <4F471651.3080609@zytor.com> <4F4C3BA2.1070708@kernel.org>
	 <1331116250.3539.35.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAE9FiQWrh5fOzAj_f03iqF+pQjGExvzppVoeJjwnp0p030jDPA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Thu, 08 Mar 2012 12:09:38 +0000
Message-ID: <1331208578.3539.79.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 10:14 -0800, Yinghai Lu wrote:
> > +
> > +               if (end <= max_low_pfn << PAGE_SHIFT)
> > +                       max_low_pfn_mapped = last_pfn_mapped;
> 
> those two line could be dropped if you have
>             last_pfn_mapped = 1<<(20 - 12);
> before the loop

When you say "dropped" do you mean "not executed" or "deleted because
they are unnecessary"?

> Also you can not use  max_low_pfn here...

Why not? Please explain.

> you need to update e820_end_pfn to search max pfn for several types like
> > +               case E820_RAM:
> > +               case E820_RESERVED_EFI:
> > +               case E820_ACPI:
> > +               case E820_NVS:

Yeah, that's a good point. I'll make that change.

> but my question is:
> is there any system that will put EFI runtime, or ACPI or NVS above
> 4G? is that legal?

Matthew already answered this. I think it's entirely possible that EFI
runtime regions can reside above 4G.

