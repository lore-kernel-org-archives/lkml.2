Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab0FUQwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 12:52:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44149 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288Ab0FUQwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:52:00 -0400
Message-ID: <4C1F98C3.6090003@colorfullife.com>
Date: Mon, 21 Jun 2010 18:52:19 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.35-rc3 deadlocks on semaphore operations
References: <alpine.DEB.2.00.1006180940140.11575@router.home> <alpine.DEB.2.00.1006180955141.11575@router.home> <4C1CD791.101@colorfullife.com> <alpine.DEB.2.00.1006210927310.4513@router.home>
In-Reply-To: <alpine.DEB.2.00.1006210927310.4513@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2010 04:31 PM, Christoph Lameter wrote:
>> - If I run make -j5 bzImage, then no semaphore arrays are used.
>> Could you try to figure out which executable is doing the 'semop()' call?
>>      
> Looks like this was ld
>
>    
Ok, that doesn't help:
$ grep semop -r binutils-2.20.51.0.2/
<nothing>

My guess: On your system, something is preloaded with LD_PRELOAD, and 
that library hangs.
I have no idea which library, and I don't know if it's a library bug or 
a kernel bug.


--
     Manfred
