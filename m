Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab0CVHFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 03:05:46 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38754 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab0CVHFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 03:05:44 -0400
To: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c to fw_memmap.c
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
	<1269155601-18247-7-git-send-email-yinghai@kernel.org>
	<1269225435.8599.70.camel@pasglop> <4BA6EA62.1030603@kernel.org>
	<1269234723.8599.76.camel@pasglop> <4BA709AC.6070902@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 22 Mar 2010 00:05:25 -0700
In-Reply-To: <4BA709AC.6070902@kernel.org> (Yinghai Lu's message of "Sun\, 21 Mar 2010 23\:09\:48 -0700")
Message-ID: <m1vdcox2dm.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: yinghai@kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org, davem@davemloft.net, akpm@linux-foundation.org, hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu, benh@kernel.crashing.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> On 03/21/2010 10:12 PM, Benjamin Herrenschmidt wrote:
>> It -may- well be that adapting x86 to lmb isn't a practical approach,
>> but if that was the case, then please justify why with precise technical
>> reasons, which we can discuss then in details and make a decision based
>> on that.
>
> 1. lmb is merging region when you add one new reserved region. 
> early_res doesn't do that merge. so later it could figure wrong freeing.
> <recently add free_early_partial, for per cpu setup only>

> 2. mem type in e820 map has more than RAM, it include RAM, reserved, ACPI, acpi nvs, and type 9?, and KERN_RESERVED...
lmb has a reserved type as well.

Beyond that does anything except /proc/iomem and acpi care?

> 3. early res, every range has one name tag.
> 4. early_res is array based, and it could auto double the array size and copy the old one to new one. and first entry in new array is for array itself.
>
> if want x86 to use lmb, the e820 map and the lmb.memory are duplicated.
> also need to have lmb.memory to support more type, otherwise still need to go back to check e820 about e820 reserved etc.

lmb clearly supports reserved regions, as well as ram regions.

Eric
