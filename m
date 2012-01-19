Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab2ASUOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 15:14:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37916 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690Ab2ASUOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 15:14:02 -0500
Message-ID: <4F187980.2000306@zytor.com>
Date: Thu, 19 Jan 2012 12:13:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
CC: device-mapper development <dm-devel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: dmsetup fails on latest kernel
References: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com> <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com>
In-Reply-To: <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you please send me:

a) your full strace;
b) arch/x86/kernel/syscall_32.o from your build?

	-hpa

On 01/19/2012 07:56 AM, Kasatkin, Dmitry wrote:
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
> Date:   Fri Nov 11 16:07:41 2011 -0800
> 
>     x86: Generate system call tables and unistd_*.h from tables
> 
> 
> It came from:  Merge branch 'x86-syscall-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> Was on 17.01.2012...
> 
> I have 32 bit VM and I have SYSVIPC enabled in the configuration...
> 
> - Dmitry


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

