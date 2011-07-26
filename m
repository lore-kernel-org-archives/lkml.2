Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1GZXe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 19:34:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45864 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab1GZXe4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 19:34:56 -0400
MIME-Version: 1.0
In-Reply-To: <20110726161714.9b1b5084.akpm@linux-foundation.org>
References: <1311721597-2606-1-git-send-email-akinobu.mita@gmail.com>
	<20110726161714.9b1b5084.akpm@linux-foundation.org>
Date: Wed, 27 Jul 2011 08:34:55 +0900
Message-ID: <CAC5umyid7cwwPwnQsSWZhv8LUu3+yGhZ3xbctN-_118-21DKPA@mail.gmail.com>
Subject: Re: [PATCH -mmotm] fault-injection: add ability to export fault_attr
 in arbitrary directory
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Per Forlin <per.forlin@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/27 Andrew Morton <akpm@linux-foundation.org>:
> On Wed, 27 Jul 2011 08:06:37 +0900
> Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
>> init_fault_attr_dentries() is used to export fault_attr via debugfs.  But
>> it can only export it in debugfs root directory.
>>
>> Per Forlin is working on mmc_fail_request which adds support to inject
>> data errors after a completed host transfer in MMC subsystem.
>>
>> The fault_attr for mmc_fail_request should be defined per mmc host and
>> export it in debugfs directory per mmc host like
>> /sys/kernel/debug/mmc0/mmc_fail_request.
>>
>> init_fault_attr_dentries() doesn't help for mmc_fail_request.  So this
>> introduces debugfs_create_fault_attr() which is able to create a directory
>> in the arbitrary directory and replace init_fault_attr_dentries().
>
> The name is wrong.  "debugfs_create_fault_attr" refers to some function
> exported by the debugfs code.  But this function is exported by the
> fault injection code.
>
> I edited the patch and renamed it to fault_create_debugfs_attr, which
> may not make a ton of sense - please let me know if there's something
> more appropriate.

Thanks for spotting the problem and the new function name sounds good.

> I suggest that all symbols exported by this system should start with
> "fault_".  ("fault_injection_" would be more appropriate, but it's
> rather lengthy).  Please take a look through the code, see if there's
> anything else we should clean up.

OK, I'll check that.
