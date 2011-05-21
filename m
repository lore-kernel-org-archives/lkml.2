Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab1EUS4F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 14:56:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53462 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab1EUS4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 14:56:01 -0400
Message-ID: <4DD80A91.5070302@intel.com>
Date: Sat, 21 May 2011 11:55:13 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
Organization: Intel Corporation
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: x32-abi@googlegroups.com
CC: "H.J. Lu" <hjl.tools@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: X32 project status update
References: <BANLkTinM_=bAjD59=GiKtTvjLtoOs7KCFA@mail.gmail.com>	<201105211727.35985.arnd@arndb.de>	<BANLkTi=tdfG3jpCJQpozpxjBmR7ZicgV9g@mail.gmail.com> <BANLkTikyg-SDtU9Z8KdCAeOkGR67ihVUkQ@mail.gmail.com>
In-Reply-To: <BANLkTikyg-SDtU9Z8KdCAeOkGR67ihVUkQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2011 09:27 AM, H.J. Lu wrote:
> On Sat, May 21, 2011 at 8:34 AM, H.J. Lu <hjl.tools@gmail.com> wrote:
>> On Sat, May 21, 2011 at 8:27 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Saturday 21 May 2011 17:01:33 H.J. Lu wrote:
>>>> This is the x32 project status update:
>>>>
>>>> https://sites.google.com/site/x32abi/
>>>>
>>>
>>> I've had another look at the kernel patch. It basically
>>> looks all good, but the system call table appears to
>>> diverge from the x86_64 list for no (documented) reason,
>>> in the calls above 302. Is that intentional?
>>>
>>> I can see why you might want to keep the numbers identical,
>>> but if they are already different, why not use the generic
>>> system call table from asm-generic/unistd.h for the new
>>> ABI?
>>
>> We can sort it out when we start merging x32 kernel changes.
>>
> 
> Peter, is that possible to use the single syscall table for
> both x86-64 and x32 system calls? Out of 300+ system
> calls, only 84 are different for x86-64 and x32.  That
> is additional 8*84 == 672 bytes in syscall table.
> 

Sort of... remember we talked about merging system calls at the tail
end?  The problem with that is that some system calls (like read()!)
actually are different system calls in very subtle situations, due to
abuse in some subsystems of the is_compat() construct.  I think that may
mean we have to have an unambiguous flag after all...

Now, perhaps we can use a high bit for that and mask it before dispatch,
then we don't need the additional table.  A bit of a hack, but it should
work.

	-hpa
