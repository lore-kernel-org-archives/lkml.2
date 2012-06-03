Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290Ab2FCDKR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 23:10:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57530 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758207Ab2FCDKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 23:10:16 -0400
Message-ID: <4FCAD590.8000506@zytor.com>
Date: Sat, 02 Jun 2012 20:10:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: hacklu <embedway.linux@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: why the decompressed procedure move kernel from address 0x100000(1M)
 to 0x1000000(16M) +x
References: <4FB492F7.8050401@gmail.com> <87ipf9gtsb.fsf@xmission.com>
In-Reply-To: <87ipf9gtsb.fsf@xmission.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2012 04:48 PM, Eric W. Biederman wrote:
On 06/02/2012 04:48 PM, Eric W. Biederman wrote:
> hacklu <embedway.linux@gmail.com> writes:
> 
>> hi all,
>> recently, I got some puzzle when I read source code of the system boot. I need
>> some help.
>>
>> at the end of src/arch/x86/boot/header.S,  kernel jump to 0x100000(where is the
>> src/arch/x86/boot/compressed/head_32.S).
>> in __this__ head_32.S, I found the kernel is move to 0x1000000(mostly is to
>> here) +x. the x distance is used for decompressed buf.  must leave some distance
>> for decompressing without overlap.
>>
>> after the move, kernel is decompressed at 0x1000000(16m). and jump to it.
>>
>> so why not decompressed kernel at 0x100000(1M) to 0x1000000(16m) directly
>> without moving?
>>
>> is the move necessary?
> 
> The move is nececcessary if we are doing the decompression in place.
> Without a move it is hard to tell if there are going to be overlapping
> address problems.  The move is cheap so there is no apparent reason
> to optimize it away.
> 

Well, right now we do two copies (one before decompression, and one
after while parsing the ELF payload.)  It would be nice to get rid of at
least one but preferably both (when possible.)

Boot time does matter, although this isn't a huge amount of time, it is
something that can be shaved off relatively cheaply.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

