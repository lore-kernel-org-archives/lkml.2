Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab2LKSq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 13:46:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60625 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769Ab2LKSqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 13:46:54 -0500
Message-ID: <50C77F86.5010207@zytor.com>
Date: Tue, 11 Dec 2012 10:46:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
References: <3E5A0FA7E9CA944F9D5414FEC6C71220470F154E@ORSMSX105.amr.corp.intel.com> <CAE9FiQXGZYZiH3eUup2UXGWkeqKjsiHk7aMTFJO7xxFkqTpBZA@mail.gmail.com> <50C6AB63.9070008@zytor.com> <CAE9FiQX7sPLXOacoLakaJ1qC5UuSUbrX_g7N-oWmLYg5W-91UA@mail.gmail.com> <50C6D3DF.3030209@zytor.com> <CAE9FiQUiEx=p6wTC5wu_E=ih1CSBaTmw90zsc2=+xu6rMO5usg@mail.gmail.com> <20121211145716.GB8873@liondog.tnic> <CAE9FiQVByBTHwPrtYvVxv4u9QrtN1iN6GH9YaDn3dvmwv5Sg7g@mail.gmail.com> <50C763C2.5020603@zytor.com> <CAE9FiQUzHBb5SiEhfrOg7hFbuD1H1-7aXa0aTjhZ9tNqdrwGqw@mail.gmail.com> <20121211170605.GD28827@liondog.tnic> <CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com> <50C7752C.2000709@zytor.com> <50C7795D.3000404@zytor.com> <CAE9FiQV03xToOaR3NcMtWDv=2MCMYwtY7p97BY3sAC1suYAhNA@mail.gmail.com>
In-Reply-To: <CAE9FiQV03xToOaR3NcMtWDv=2MCMYwtY7p97BY3sAC1suYAhNA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 10:42 AM, Yinghai Lu wrote:
> 
> now in for-x86-boot:
> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commit;h=8e4e093e6d140f1316953437fdde4e826f5cfd98
> 
> it adds extra mapping from the whole kernel when kernel is loaded above 1G.
> from round_down(_text, 2M) to round_up(_end -1, 2M).
> 
> Do you mean we need to add extra mapping for realmode_data, cmdline,
> ramdisk too? (not include setup_data, and it is accessed via
> early_ioremap later).

Yes, but...

> but if the user memmap to exclude some page, we will still need to
> relocate the ramdisk.

-ENOPARSE

I really need to look at this in more detail.  I'm starting to think
this is done completely backwards.

	-hpa


