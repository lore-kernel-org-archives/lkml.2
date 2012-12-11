Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab2LKRPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 12:15:33 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35989 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab2LKRPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 12:15:31 -0500
MIME-Version: 1.0
In-Reply-To: <20121211170605.GD28827@liondog.tnic>
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
Date: Tue, 11 Dec 2012 09:15:30 -0800
X-Google-Sender-Auth: Gg8ax7TowUBEwI778gpwEDCG7VY
Message-ID: <CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 9:06 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Dec 11, 2012 at 09:00:55AM -0800, Yinghai Lu wrote:
>> ok, then next question is how early it should be.
>>
>> before early_cpu_init/early_identify_cpu
>>
>> or just before check_bugs/identify_cpu
>
> Read the code. It's in x86_64_start_kernel on 64-bit.
>

No, that is not right place. initrd could be loaded anywhere like way
high by bootloader.

to make code simple, we should have following sequence in setup_arch

early_ioremap_init()
early_update_microcode()...
early_cpu_init()

early_update_microcode could use early_ioremap to access initrd ramdisk area.

Yinghai
