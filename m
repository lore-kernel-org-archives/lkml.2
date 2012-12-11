Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab2LKR0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:26:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:22758 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab2LKR0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:26:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,260,1355126400"; 
   d="scan'208";a="262487732"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: RE: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
Thread-Topic: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
Thread-Index: AQHNz16n1Bxf/tNNEky0MTioxs293pgHyUPggAuvpICAABE/gIAABAUAgAAsPoCAAAldAIAAgzcAgAAemACAAABbAIAAA5mAgAABcwCAAAKgAP//endQ
Date: Tue, 11 Dec 2012 17:26:40 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C71220470F5ECD@ORSMSX105.amr.corp.intel.com>
References: <3E5A0FA7E9CA944F9D5414FEC6C71220470F154E@ORSMSX105.amr.corp.intel.com>
	<CAE9FiQXGZYZiH3eUup2UXGWkeqKjsiHk7aMTFJO7xxFkqTpBZA@mail.gmail.com>
	<50C6AB63.9070008@zytor.com>
	<CAE9FiQX7sPLXOacoLakaJ1qC5UuSUbrX_g7N-oWmLYg5W-91UA@mail.gmail.com>
	<50C6D3DF.3030209@zytor.com>
	<CAE9FiQUiEx=p6wTC5wu_E=ih1CSBaTmw90zsc2=+xu6rMO5usg@mail.gmail.com>
	<20121211145716.GB8873@liondog.tnic>
	<CAE9FiQVByBTHwPrtYvVxv4u9QrtN1iN6GH9YaDn3dvmwv5Sg7g@mail.gmail.com>
	<50C763C2.5020603@zytor.com>
	<CAE9FiQUzHBb5SiEhfrOg7hFbuD1H1-7aXa0aTjhZ9tNqdrwGqw@mail.gmail.com>
	<20121211170605.GD28827@liondog.tnic>
 <CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com>
In-Reply-To: <CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
> Yinghai Lu
> Sent: Tuesday, December 11, 2012 9:16 AM
> To: Borislav Petkov; Yinghai Lu; H. Peter Anvin; Yu, Fenghua;
> mingo@kernel.org; linux-kernel@vger.kernel.org; tglx@linutronix.de;
> hpa@linux.intel.com; linux-tip-commits@vger.kernel.org
> Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early
> update ucode on Intel's CPU
> 
> On Tue, Dec 11, 2012 at 9:06 AM, Borislav Petkov <bp@alien8.de> wrote:
> > On Tue, Dec 11, 2012 at 09:00:55AM -0800, Yinghai Lu wrote:
> >> ok, then next question is how early it should be.
> >>
> >> before early_cpu_init/early_identify_cpu
> >>
> >> or just before check_bugs/identify_cpu
> >
> > Read the code. It's in x86_64_start_kernel on 64-bit.
> >
> 
> No, that is not right place. initrd could be loaded anywhere like way
> high by bootloader.
> 
> to make code simple, we should have following sequence in setup_arch
> 
> early_ioremap_init()
> early_update_microcode()...
> early_cpu_init()
> 
> early_update_microcode could use early_ioremap to access initrd ramdisk
> area.

The problem is mainly from 32-bit. We need to load microcode before paging is enabled (I'm changing load_ucode_intel_ap to be called before paging as well). That makes the coding not simple. It's better to load ucode as early as possible in 64-bit as well. I don't want to have two totally different sets of early loading ucode for 64-bit and 32-bit. 

Thanks.

-Fenghua
