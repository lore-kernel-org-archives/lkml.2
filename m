Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750851Ab2LUFFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:05:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60519 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab2LUFFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:05:44 -0500
Message-ID: <50D3EE1A.7020703@zytor.com>
Date: Thu, 20 Dec 2012 21:05:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        Vineet.Gupta1@synopsys.com, linux-kernel@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>
Subject: Re: new architectures, time_t __kernel_long_t
References: <201211141218.02105.arnd@arndb.de> <20121221045731.GO4939@ZenIV.linux.org.uk> <50D3ECEB.1070401@zytor.com> <20121221050202.GP4939@ZenIV.linux.org.uk>
In-Reply-To: <20121221050202.GP4939@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 09:02 PM, Al Viro wrote:
> On Thu, Dec 20, 2012 at 09:00:27PM -0800, H. Peter Anvin wrote:
>> On 12/20/2012 08:57 PM, Al Viro wrote:
>>> On Wed, Nov 14, 2012 at 12:18:01PM +0000, Arnd Bergmann wrote:
>>>
>>>> The other types that are used as 64 bit on x32 are ino_t, nlink_t,
>>>> size_t, ssize_t, ptrdiff_t, and off_t.
>>>
>>> *Kernel-side* we should not give a damn about the userland nlink_t, period.
>>> Making it architecture-dependent had been a bad mistake that essentially
>>> made nlink_t useless for the kernel.  That mistake had been fixed; please,
>>> do not bring it back.  If some userland structure needs to include a field
>>> encoding nlink_t values, please use an explicitly-sized type when refering
>>> to it kernel-side.
>>>
>>
>> We should never use userland types per se.  We can use __kernel_*_t
>> typedefs to make the kernel headers neater if it makes sense, but that
>> is often not even necessary.
>
> ... as long as we do not have typedef __kernel_foo_t foo_t in linux/types.h.
>

In the case of things like nlink_t and dev_t I would suggest we 
explicitly call out the types as kernel and user.  I would suggest 
knlink_t and unlink_t but the latter made me want to stab my eyes out 
due to its confusion potential, so I wonder if we should establish a new 
convention with _kt (kernel type) and _ut (user type) suffixes, so 
nlink_kt and nlink_ut, alternatively one could consider k_nlink_t and 
u_nlink_t.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

