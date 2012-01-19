Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab2ASQKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:10:30 -0500
Received: from mga10.intel.com ([192.55.52.92]:51425 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932171Ab2ASQK3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:10:29 -0500
MIME-Version: 1.0
In-Reply-To: <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com>
References: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com>
	<CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com>
Date: Thu, 19 Jan 2012 18:10:28 +0200
Message-ID: <CALLzPKYuKufGoUkXb9kPSn6buzVY0awzCL2F9onr1=NxysP3_w@mail.gmail.com>
Subject: Re: dmsetup fails on latest kernel
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 5:56 PM, Kasatkin, Dmitry
<dmitry.kasatkin@intel.com> wrote:
> On Thu, Jan 19, 2012 at 3:02 PM, Kasatkin, Dmitry
> <dmitry.kasatkin@intel.com> wrote:
>> Hi,
>>
>> (subject added)
>>
>> I rebased on the stop of latest mainline tree and now dmsetup fails...
>> It says: "Failed to create notification semaphore: Function not implemented".
>> I run strace and saw that dmsetup uses "semget" which returns -ENOSYS...
>>
>> It works on
>> 122804ecb59493fbb4d31b3ba9ac59faaf45276f
>>
>> but does not work on
>> ccb19d263fd1c9e34948e2158c53eacbff369344
>>
>> Any ideas?
>>
>> - Dmitry
>
> Hi,
>
> I have bisected the problem...
>
> It is introduced by this commit:
>
> 303395ac3bf3e2cb488435537d416bc840438fcb is the first bad commit
> commit 303395ac3bf3e2cb488435537d416bc840438fcb
> Author: H. Peter Anvin <hpa@linux.intel.com>
> Date:   Fri Nov 11 16:07:41 2011 -0800
>
>    x86: Generate system call tables and unistd_*.h from tables
>
>
> It came from:  Merge branch 'x86-syscall-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> Was on 17.01.2012...
>
> I have 32 bit VM and I have SYSVIPC enabled in the configuration...
>
> - Dmitry

It seems "semget" is missing from: arch/x86/syscalls/syscall_32.tbl
But it presents in: arch/x86/syscalls/syscall_64.tbl

Is it a bug then?

- Dmitry
