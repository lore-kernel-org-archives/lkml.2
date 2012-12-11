Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab2LKCjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 21:39:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43108 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2LKCjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 21:39:40 -0500
MIME-Version: 1.0
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C71220470F154E@ORSMSX105.amr.corp.intel.com>
References: <1354240068-9821-6-git-send-email-fenghua.yu@intel.com>
	<tip-474355fe313391de2429ae225e0fb02f67ec6c31@git.kernel.org>
	<CAE9FiQW13Ji1wGSvFKrhY5UEArHyY5bfL5Ma37SRU9uROdPYDw@mail.gmail.com>
	<3E5A0FA7E9CA944F9D5414FEC6C71220470F154E@ORSMSX105.amr.corp.intel.com>
Date: Mon, 10 Dec 2012 18:39:39 -0800
X-Google-Sender-Auth: YTKXl2GWhcv0zsCg8GwrVrsESpY
Message-ID: <CAE9FiQXGZYZiH3eUup2UXGWkeqKjsiHk7aMTFJO7xxFkqTpBZA@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 4:18 PM, Yu, Fenghua <fenghua.yu@intel.com> wrote:
>> From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
>> Yinghai Lu
>>
>> may need to copy the ucode.bin to BRK at first. that will make code
>> much simple, and later does not need to
>> copy them back in free_bootmem_initrd.
>>
>> aka, this patchset is not ready for 3.8 even.
>>
>
> I will relocate saved microcode blob (mc_saved_in_initrd) after initrd is
> relocated in updated patches. Thus, mc_saved_in_initrd always point to
> right initrd during boot time.

No, you should not copy that several times.

just pre-allocate some kbytes in BRK, and copy to there one time.

Yinghai
