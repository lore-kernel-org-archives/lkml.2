Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab2CMFjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:39:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49439 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951Ab2CMFjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:39:01 -0400
MIME-Version: 1.0
In-Reply-To: <1331555916.3539.88.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org>
	<tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org>
	<CAE9FiQWFpsZotawqPD4738jTayB=KOGo0W9+AT2go3GYk1v_sQ@mail.gmail.com>
	<4F45B35D.1010702@zytor.com>
	<CAE9FiQUbyYYN5orG_RyVm=P-8wNh=YsET1VzGojpFTfJPueHqA@mail.gmail.com>
	<4F471651.3080609@zytor.com>
	<4F4C3BA2.1070708@kernel.org>
	<1331116250.3539.35.camel@mfleming-mobl1.ger.corp.intel.com>
	<CAE9FiQUoRMA_PYnOEt0ZUYXLq=hNZtDuLifT=+R72HtrwfF6AA@mail.gmail.com>
	<1331206127.3539.69.camel@mfleming-mobl1.ger.corp.intel.com>
	<CAE9FiQVZVNARgs0rzgRpRdbSPydCXoeDat=4DLMNFcyBQuqwng@mail.gmail.com>
	<1331555916.3539.88.camel@mfleming-mobl1.ger.corp.intel.com>
Date: Mon, 12 Mar 2012 22:39:00 -0700
X-Google-Sender-Auth: L7FtWDoMzd8ys5D4YR7-uAMYZBQ
Message-ID: <CAE9FiQXA4+Ubh-6QZv5bouZchR6XZjBSGwR1ox-vug01xiGveA@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86, efi: Delete efi_ioremap() and fix
 CONFIG_X86_32 oops
From: Yinghai Lu <yinghai@kernel.org>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@kernel.org>, mingo@redhat.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, keithp@keithp.com, rui.zhang@intel.com,
        huang.ying.caritas@gmail.com, stable@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 5:38 AM, Matt Fleming <matt.fleming@intel.com> wrote:

> Have you tested my patch? Have you hit this bug or is it just from code
> inspection. I'm starting to feel a bit silly now because I can't see the
> problem you're describing.

from code inspection.

your new init_memory_mapping() will only map mem under max_low_pfn ?

and before that calling for x86_64, max_low_pfn is not updated to max_pfn yet.

+       max_pfn_mapped = init_memory_mapping();

 #ifdef CONFIG_X86_64
       if (max_pfn > max_low_pfn) {
-               max_pfn_mapped = init_memory_mapping(1UL<<32,
-                                                    max_pfn<<PAGE_SHIFT);
               /* can we preseve max_low_pfn ?*/
               max_low_pfn = max_pfn;
       }

Please do find one system with more than 4G to test the code.

Thanks

Yinghai
