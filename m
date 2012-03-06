Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030884Ab2CFPCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 10:02:05 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56654 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030778Ab2CFPCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 10:02:03 -0500
X-Sasl-enc: StPf9RxNL3qj0A0gVX0quVJCaUh6fsPaLU1uLyOPg7e3 1331046122
Message-ID: <4F562775.2010501@ladisch.de>
Date: Tue, 06 Mar 2012 16:04:21 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: akpm@linux-foundation.org, maglyx@gmail.com, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 4/4] hpet: factor timer allocate from open
References: <20120305230755.35019A02EB@akpm.mtv.corp.google.com> <alpine.LFD.2.02.1203061345150.2742@ionos>
In-Reply-To: <alpine.LFD.2.02.1203061345150.2742@ionos>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 5 Mar 2012, akpm@linux-foundation.org wrote:
>> From: Magnus Lynch <maglyx@gmail.com>
>> Subject: hpet: factor timer allocate from open
>>
>> The current implementation of the /dev/hpet driver couples opening the
>> device with allocating one of the (scarce) timers (aka comparators).  This
>> is a limitation in that the main counter may be valuable to applications
>> seeking a high-resolution timer who have no use for the interrupt
>> generating functionality of the comparators.
>>
>> This patch alters the open semantics so that when the device is opened, no
>> timer is allocated.  Operations that depend on a timer being in context
>> implicitly attempt allocating a timer, to maintain backward compatibility.
>
> AFAICT, there is only fasync which calls hpet_alloc_timer(). All other
> functions are broken by this chage.

Indeed.  There was another call in hpet_ioctl_common(), but it appears
that one somehow got dropped.

Magnus, is this the patch that you submitted and have tested?


Regards,
Clemens
