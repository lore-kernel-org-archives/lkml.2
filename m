Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab1GLSrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:47:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34010 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab1GLSrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:47:21 -0400
Message-ID: <4E1C952D.6010902@zytor.com>
Date: Tue, 12 Jul 2011 11:40:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [slubllv7 06/17] slub: Add cmpxchg_double_slab()
References: <20110601172543.437240675@linux.com>  <20110601172615.286693377@linux.com>  <1310414100.2860.6.camel@edumazet-laptop>  <alpine.DEB.2.00.1107121057550.2931@router.home> <1310486781.2871.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.DEB.2.00.1107121146080.3937@router.home>
In-Reply-To: <alpine.DEB.2.00.1107121146080.3937@router.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 09:47 AM, Christoph Lameter wrote:
> On Tue, 12 Jul 2011, Eric Dumazet wrote:
> 
>> Le mardi 12 juillet 2011 à 10:59 -0500, Christoph Lameter a écrit :
>>
>>> We do not need to have _count included. This is just there because the
>>> field is in the way on 64 bit and we can only do 2x 64 bit cmpxchges.  On
>>> 32 bi we can drop _count from "counters".
>>
>> OK, thanks for clarification.
> 
> Still I'd like to get some ideas on how to make the whole thing much
> cleaner. Isnt there some way to convert a struct to an unsigned long
> without going through a union? And a way to convert a struct + 32 bit
> atomic_t into a 64 bit unsigned long? Would simplify things significantly.

If you know it is in memory you can cast ("pun") the pointer.

If it's not in memory that can be inefficient, though.

	-hpa
