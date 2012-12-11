Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab2LKDzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 22:55:49 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45603 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab2LKDzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 22:55:48 -0500
MIME-Version: 1.0
In-Reply-To: <50C6AB63.9070008@zytor.com>
References: <1354240068-9821-6-git-send-email-fenghua.yu@intel.com>
	<tip-474355fe313391de2429ae225e0fb02f67ec6c31@git.kernel.org>
	<CAE9FiQW13Ji1wGSvFKrhY5UEArHyY5bfL5Ma37SRU9uROdPYDw@mail.gmail.com>
	<3E5A0FA7E9CA944F9D5414FEC6C71220470F154E@ORSMSX105.amr.corp.intel.com>
	<CAE9FiQXGZYZiH3eUup2UXGWkeqKjsiHk7aMTFJO7xxFkqTpBZA@mail.gmail.com>
	<50C6AB63.9070008@zytor.com>
Date: Mon, 10 Dec 2012 19:55:46 -0800
X-Google-Sender-Auth: hVwVHMCOq0abqzbiNtmMIqor2gU
Message-ID: <CAE9FiQX7sPLXOacoLakaJ1qC5UuSUbrX_g7N-oWmLYg5W-91UA@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
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

On Mon, Dec 10, 2012 at 7:41 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/10/2012 06:39 PM, Yinghai Lu wrote:
>>
>> No, you should not copy that several times.
>>
>> just pre-allocate some kbytes in BRK, and copy to there one time.
>>
>
> He doesn't copy it several times.  He just saves an offset into the
> initrd blob.

ucode is together with initrd blob, and code scan that blob, and save
the pointer about ucode,
then BSP use it, and APs use it
after that when initrd get freed,  that ucode is copied to somewhere...

and his patch missed initrd could be get relocated for 64bit and 32bit.
So AP would not find that saved ucode.

After i pointed that, he said he will update the pointer when relocate
the initrd for AP.

And my suggestion is: after scan and find the ucode, save it to BRK,
so don't need to adjust
pointer again, and don't need to copy the blob and update the pointer again.

Yinghai
