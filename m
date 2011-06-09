Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab1FIJxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:53:46 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39324 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab1FIJxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:53:44 -0400
Message-ID: <4DF09827.7070809@cs.helsinki.fi>
Date: Thu, 09 Jun 2011 12:53:43 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: David Rientjes <rientjes@google.com>, tj@kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu
Subject: Re: [slubllv7 04/17] x86: Add support for cmpxchg_double
References: <20110601172543.437240675@linux.com> <20110601172614.173427964@linux.com>
In-Reply-To: <20110601172614.173427964@linux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/1/11 8:25 PM, Christoph Lameter wrote:
> A simple implementation that only supports the word size and does not
> have a fallback mode (would require a spinlock).
>
> Add 32 and 64 bit support for cmpxchg_double. cmpxchg double uses
> the cmpxchg8b or cmpxchg16b instruction on x86 processors to compare
> and swap 2 machine words. This allows lockless algorithms to move more
> context information through critical sections.
>
> Set a flag CONFIG_CMPXCHG_DOUBLE to signal that support for double word
> cmpxchg detection has been build into the kernel. Note that each subsystem
> using cmpxchg_double has to implement a fall back mechanism as long as
> we offer support for processors that do not implement cmpxchg_double.
>
> Reviewed-by: H. Peter Anvin<hpa@zytor.com>
> Cc: tj@kernel.org
> Signed-off-by: Christoph Lameter<cl@linux.com>

Tejun, I'm going to queue this series for linux-next in the next few 
days. Could you either pick up this patch so I can pull from your tree 
or alternatively, is it OK to queue this through slab.git?

			Pekka
