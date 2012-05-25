Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032Ab2EYMPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 08:15:17 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:48247 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932934Ab2EYMPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 08:15:14 -0400
X-AuditID: b753bd60-94000ba000003d24-a5-4fbf77cf4a38
X-AuditID: b753bd60-94000ba000003d24-a5-4fbf77cf4a38
Message-ID: <4FBF77BF.1040304@hitachi.com>
Date: Fri, 25 May 2012 21:14:55 +0900
From: YOSHIDA Masanori <masanori.yoshida.tv@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Kevin Hilman <khilman@ti.com>,
        Prarit Bhargava <prarit@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 1/4 V2] livedump: Add notifier-call-chain into do_page_fault
References: <20120525091207.10256.18614.stgit@t3500.sdl.hitachi.co.jp>  <20120525091207.10256.15550.stgit@t3500.sdl.hitachi.co.jp> <1337937596.9783.165.camel@laptop>
In-Reply-To: <1337937596.9783.165.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter,

I agree that notifier isn't suitable for this purpose.

In the next version, I plan to replace this with a simple
callback as follows.

   if (very_unlikely(under_live_dump))
       ...

In addition to this, since PF handler is a very hot path,
I will cover the condition with "#ifdef CONFIG_WRPROTECT".

Thank you.


On 2012/05/25 18:19, Peter Zijlstra wrote:
> On Fri, 2012-05-25 at 18:12 +0900, YOSHIDA Masanori wrote:
>>
>> This patch adds notifier-call-chain that is called in do_page_fault.
>> Livedump uses this to check if page fault is caused by livedump, and if so,
>> the fault is handled by livedump's handler function. Otherwise, it is
>> handled by the original page fault handler.
>
> No, please no notifiers..
>
>
>

