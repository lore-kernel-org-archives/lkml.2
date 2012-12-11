Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab2LKTSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 14:18:38 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60920 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab2LKTSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 14:18:37 -0500
MIME-Version: 1.0
In-Reply-To: <50C77F86.5010207@zytor.com>
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
	<50C7752C.2000709@zytor.com>
	<50C7795D.3000404@zytor.com>
	<CAE9FiQV03xToOaR3NcMtWDv=2MCMYwtY7p97BY3sAC1suYAhNA@mail.gmail.com>
	<50C77F86.5010207@zytor.com>
Date: Tue, 11 Dec 2012 11:18:35 -0800
X-Google-Sender-Auth: 1YfHdQmgqQqm4hucZxTpQRcZHwk
Message-ID: <CAE9FiQV8Qu551rHDx49Na2sQeqCyXtuhC7Ea=stunNzjfUR34A@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, "Yu, Fenghua" <fenghua.yu@intel.com>,
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

On Tue, Dec 11, 2012 at 10:46 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/11/2012 10:42 AM, Yinghai Lu wrote:
>>
>> now in for-x86-boot:
>> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commit;h=8e4e093e6d140f1316953437fdde4e826f5cfd98
>>
>> it adds extra mapping from the whole kernel when kernel is loaded above 1G.
>> from round_down(_text, 2M) to round_up(_end -1, 2M).
>>
>> Do you mean we need to add extra mapping for realmode_data, cmdline,
>> ramdisk too? (not include setup_data, and it is accessed via
>> early_ioremap later).
>
> Yes, but...

that will be bunch of asm code again, and need to parse the setup_header in that
asm to get range value for those regions...

>
>> but if the user memmap to exclude some page, we will still need to
>> relocate the ramdisk.
>
> -ENOPARSE

.. I mean pointer for saved ucode will be updated then again.
and relocated_initrd wil still need to use ioremap because init_memory_mapping
will clean mapping the range range that is excluded by memmap=XX$YY

>
> I really need to look at this in more detail.  I'm starting to think
> this is done completely backwards.

really should not put asm code if it could be done in C in not complicated way.
