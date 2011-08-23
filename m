Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab1HWPFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:05:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47589 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab1HWPFH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:05:07 -0400
MIME-Version: 1.0
In-Reply-To: <20110823003814.GB5982@kroah.com>
References: <1310187626-2371-1-git-send-email-akinobu.mita@gmail.com>
	<20110823003814.GB5982@kroah.com>
Date: Wed, 24 Aug 2011 00:05:06 +0900
Message-ID: <CAC5umyhjDnCDZrnR6P9DGhXV80bm_mRB6nNo=86ctz1aNhVfmg@mail.gmail.com>
Subject: Re: [PATCH] libfs: fix simple_attr_write on 32bit machine
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Andi Kleen <ak@linux.intel.com>,
        Huang Ying <ying.huang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/23 Greg KH <greg@kroah.com>:
> On Sat, Jul 09, 2011 at 02:00:26PM +0900, Akinobu Mita wrote:
>> Assume that /sys/kernel/debug/dummy64 is debugfs file created by
>> debugfs_create_x64().
>>
>>       # cd /sys/kernel/debug
>>       # echo 0x1234567812345678 > dummy64
>>       # cat dummy64
>>       0x0000000012345678
>>
>>       # echo 0x80000000 > dummy64
>>       # cat dummy64
>>       0xffffffff80000000
>>
>> The value more than INT_MAX cannot be written to the debugfs file
>> created by debugfs_create_u64 or debugfs_create_x64 on 32bit machine.
>> Because simple_attr_write() uses simple_strtol() for the conversion.
>>
>> To fix this, use simple_strtoll() instead.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Cc: Greg Kroah-Hartman <gregkh@suse.de>
>
> Do we have any debugfs files that need this change in the tree now for
> 3.1 or newer?

This patch has already been merged into 3.0.  Some files are created
debugfs_create_[ux]64 with write permission and affected by this bug.

hwpoison/corrupt-filter-flags-mask
hwpoison/corrupt-filter-flags-value
hwpoison/corrupt-filter-memcg
apei/einj/param1
apei/einj/param2
