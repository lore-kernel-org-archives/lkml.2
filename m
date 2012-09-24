Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab2IXKrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:47:12 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53282 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab2IXKrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:47:07 -0400
Message-ID: <506039F1.2040108@windriver.com>
Date: Mon, 24 Sep 2012 05:46:09 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linaro-kernel@lists.linaro.org>, <patches@linaro.org>,
        <kernel-team@android.com>, <kgdb-bugreport@lists.sourceforge.net>,
        <linux-serial@vger.kernel.org>
Subject: Re: [PATCH v8 0/11] KGDB/KDB FIQ (NMI) debugger
References: <20120919234003.GA24143@lizard> <505B1CC7.9000005@windriver.com>
In-Reply-To: <505B1CC7.9000005@windriver.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 08:40 AM, Jason Wessel wrote:
> On 09/19/2012 06:40 PM, Anton Vorontsov wrote:
>> Hi all,
>>
>> In v8, addressed Jason's comments:
>>
>> - Changed kgdb_enable_nmi() weak function to kgdb_arch callbck;
>> - We no longer register disable_nmi command if arch does not register
>>   KGDB NMI handling (i.e. not filling kgdb_arch.enable_nmi callback);
>> - The same is for ttyNMI: if architecure does not provide us with
>>   enable_nmi call, we don't need the tty device. Of course, there is no
>>   way to tell wether a specific serial device can be used for NMI
>>   debugging, as it is not serial-device specific, but specific to
>>   whether IRQ can be rerouted to an NMI (for most our cases, pretty
>>   much every IRQ can be rerouted, e.g. a hot-pluggable serial device on
>>   a PCI bus).
>> - Rebased on the latest and greatest tty-next, just in case.
>
> I have the kgdb regression builder running right now (it will be done in about 1 hour), and so far it picked up one new warning.
>
> drivers/tty/serial/kgdb_nmi.c: In function 'kgdb_nmi_poll_one_knock':
> drivers/tty/serial/kgdb_nmi.c:161: warning: field width should have type 'int', but argument 4 has type 'size_t'
>

Hi Anton,

You can add my ack to the series, for what you have in: "git://git.infradead.org/users/cbou/linux-nmi-kdb.git master", and then drop a pull request to Greg for the next merge window.  Thank you for your hard work through all the revisions of this code and this slick new feature.

Acked-by: Jason Wessel <jason.wessel@windriver.com>

Cheers,
Jason.
