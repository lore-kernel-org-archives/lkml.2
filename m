Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0IBFqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 01:46:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54506 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab0IBFqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 01:46:46 -0400
Message-ID: <4C7F3A26.6020607@cn.fujitsu.com>
Date: Thu, 02 Sep 2010 13:46:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Chris Mason <chris.mason@oracle.com>, Yan Zheng <zheng.yan@oracle.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>
Subject: [PATCH V2 0/3] improve the performance of some memory copy functions
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from V1 to V2:
- change the version of GPL from version 2.1 to version 2

When I looked into the performance problem of the btrfs, I found some memory
copy functions of the kernel(such as: x86_64's memmove)is very inefficient,
but the glibc version is quite fast, in some cases it is 10 times faster than
the kernel version.

This patchset introduced some macros and functions of the glibc, and improved
memmove and memcpy of the generic version and memmove of x86_64 in the kernel.

I have tested this patchset by doing 500 bytes memory copy for 50000 times
on x86_64:
			memmove
2.6.36-rc1		2s 610445us	
2.6.36-rc1 + patch	0s 257358us

After appling this patchset, the performance of the file creation and deletion
on some filesystems also become better. I have tested the file creation and
deletion performance with the following benchmark tool on my x86_64 box.
  http://marc.info/?l=linux-btrfs&m=128212635122920&q=p3

Test steps:
# ./creat_unlink 50000

The result is following(Total time):
Ext4:
		2.6.36-rc1	2.6.36-rc1 + patchset
file creation	0.771240	0.698983		9.4%UP
file deletion	0.459065	0.425530		7.3%UP


Btrfs:
		2.6.36-rc1	2.6.36-rc1 + patchset
file creation	0.966807	0.947592		1.9%UP
file deletion	1.355671	1.217787		10.2%UP

BTW: I don't know the performance of the other architectures because I don't
have the machine of those architectures, so I just improved the generic vesion
and x86_64 version. 

Who can help me to test the performance on the other architectures and compare
it with the new generic version?
