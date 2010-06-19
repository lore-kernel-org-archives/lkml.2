Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab0FSOnQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 10:43:16 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36385 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab0FSOnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 10:43:15 -0400
Message-ID: <4C1CD791.101@colorfullife.com>
Date: Sat, 19 Jun 2010 16:43:29 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.35-rc3 deadlocks on semaphore operations
References: <alpine.DEB.2.00.1006180940140.11575@router.home> <alpine.DEB.2.00.1006180955141.11575@router.home>
In-Reply-To: <alpine.DEB.2.00.1006180955141.11575@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Christoph,

On 06/18/2010 04:56 PM, Christoph Lameter wrote:
> One important fact that I forgot to mention: This is on a dual quad core
> dell box (8 hardware threads) with CONCURRENCY_LEVEL set to 9.
>    

- Which version of make do you use? That would be one suspect that might 
use semop().

- If I run make -j5 bzImage, then no semaphore arrays are used.
Could you try to figure out which executable is doing the 'semop()' call?
Or: what's the output of ps xawwwww_

- You are able to attach to the sleeping process with strace - and the 
process continues to wait.
I think this means that the semaphore counter is really 0: Somehow, we 
leak semaphore values.

But I did not change this code, what was changed was the wake-up code.

--
     Manfred
