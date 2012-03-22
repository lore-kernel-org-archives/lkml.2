Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab2CVCHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 22:07:48 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:54054 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab2CVCHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 22:07:46 -0400
Message-ID: <4F6A892D.1030601@ce.jp.nec.com>
Date: Thu, 22 Mar 2012 11:06:37 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] Fix I/O counts in vmstat
References: <Pine.LNX.4.64.1203202336370.15617@file.rdu.redhat.com> <4F69A798.4000200@ce.jp.nec.com> <Pine.LNX.4.64.1203211148220.23047@file.rdu.redhat.com>
In-Reply-To: <Pine.LNX.4.64.1203211148220.23047@file.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikulas,

On 03/22/12 00:50, Mikulas Patocka wrote:
> On Wed, 21 Mar 2012, Jun'ichi Nomura wrote:
>>> The decision whether bio is counted or not is made by the code that
>>> submits the bio. This leads to some problems:
>>
>> How about convering dm targets to use generic_make_request?
> 
> The problem would be raid1 resynchronization. There are no incoming bios 
> when resynchronizing, but the administrator still needs to see the 
> resynchronization workload in vmstat. The code path that submits bios for 
> resynchronization is the same as the path that handles write requests.

Admins could see the workload with iostat or sar.
If pgpgout does not increase but iostat shows disk activity,
admins can tell resynchronization is going on.

> Also dm-over-loop would still result in double-counting, even if we use 
> generic_make_request in dm.

It reflects the fact that writeback actually happens twice.

>> Since submit_bio counts vm events, it seems natural for
>> caller to decide which function to use.
>> Device driver does not know whether the requested I/O is
>> for vm-to-device or device-to-device.
>> We could still use iostat to measure throughput of individual
>> block devices. 

-- 
Jun'ichi Nomura, NEC Corporation
