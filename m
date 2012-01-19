Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab2AST6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 14:58:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:18810 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932487Ab2AST6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 14:58:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108812067"
Message-ID: <4F1875CC.4010006@linux.intel.com>
Date: Thu, 19 Jan 2012 11:58:04 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        device-mapper development <dm-devel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: dmsetup fails on latest kernel
References: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com> <CALLzPKbeXN5gdngo8uYYU8mAow=XhrwBFBhKfG811f37BubQOg@mail.gmail.com> <CA+55aFwwkjFsVuSZWgasN4e_d9suRV4Afr94NMvNt4R7Ej0gbw@mail.gmail.com>
In-Reply-To: <CA+55aFwwkjFsVuSZWgasN4e_d9suRV4Afr94NMvNt4R7Ej0gbw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 11:05 AM, Linus Torvalds wrote:
>>
>> Hi,
>>
>> I have bisected the problem...
>>
>> It is introduced by this commit:
>>
>> 303395ac3bf3e2cb488435537d416bc840438fcb is the first bad commit
>> commit 303395ac3bf3e2cb488435537d416bc840438fcb
>> Author: H. Peter Anvin<hpa@linux.intel.com>
>> Date:   Fri Nov 11 16:07:41 2011 -0800
>>
>>     x86: Generate system call tables and unistd_*.h from tables
>
> Interesting. I just munged the old pre-merge
>
>    arch/x86/kernel/syscall_table_32.S
>
> and the new
>
>    arch/x86/syscalls/syscall_32.tbl
>
> with some trivial shell scripting, and they are definitely identical.
>
> So the tables look like they match 1:1.
>
> The compat tables match too, except the new list contains the entry
> for bdflush (134), but that's a legacy thing that doesn't matter.
>
> I wonder what else could be going on. Wrong number of system calls
> check? Peter, any ideas?
>

Not off the top of my head.  I will try to reproduce this and see what 
the problem is.  Dmitry, what version of binutils and gcc are you using? 
  It could be that there is a toolchain problem.

	-hpa


