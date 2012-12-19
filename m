Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab2LSXp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:45:28 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:59706 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab2LSXpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:45:22 -0500
MIME-Version: 1.0
In-Reply-To: <20121219234054.GA6130@jshin-Toonie>
References: <50CCF6F6.4020107@zytor.com>
	<CAE9FiQULAJhPUw62UVjyBakn-YcK8x0pzDgRi+FdJXS-_ekABg@mail.gmail.com>
	<50CD04F1.8020902@zytor.com>
	<0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com>
	<20121219220504.GA32212@jshin-Toonie>
	<50D23EE8.7030904@zytor.com>
	<20121219225155.GK24895@liondog.tnic>
	<20121219225941.GB2968@jshin-Toonie>
	<20121219230329.GM24895@liondog.tnic>
	<50D24C25.5050604@zytor.com>
	<20121219234054.GA6130@jshin-Toonie>
Date: Wed, 19 Dec 2012 15:45:20 -0800
X-Google-Sender-Auth: 4J0C_Q5c-b9vPiYZG4-w3IrV5NE
Message-ID: <CAE9FiQWDhPtTu_K_9rq1B2i2GByh7EMfbtpt+ZQBpRmo-fQo3A@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 3:40 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> On Wed, Dec 19, 2012 at 03:22:13PM -0800, H. Peter Anvin wrote:
>> The other bit is that building the real kernel page tables iteratively
>> (ignoring the early page tables here) is safer, since the real page
>> table builder is fully aware of the memory map.  This means any
>> "spillover" from the early page tables gets minimized to regions where
>> there are data objects that have to be accessed early.  Since Yinghai
>> already had iterative page table building working, I don't see any
>> reason to not use that capability.
>
> Yes, I'll test again with latest, but Yinghai's patchset mapping only
> RAM from top down solved our problem.

that is for-x86-mm or tip:x86/mm2

we are taking about for-x86-boot, and it will allow kernel to be loaded above 4G
to solve the kdump problem.

so early map will have two way
1. extend head_64.S to cover kernel instead of just [0, 1G)
2. or peter's #PF handler version patch to set pg table dynamically.
    it could cover 1G when PF happens.

Yinghai
