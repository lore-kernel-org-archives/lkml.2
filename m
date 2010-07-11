Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287Ab0GKFTc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 01:19:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab0GKFTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 01:19:31 -0400
Message-ID: <4C395459.6080407@redhat.com>
Date: Sun, 11 Jul 2010 08:19:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Felipe W Damasio <felipewd@gmail.com>, David Miller <davem@davemloft.net>,
       Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
       netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] tproxy: nf_tproxy_assign_sock() can handle tw sockets
References: <AANLkTimn8A0cYZmwNZYitRkBHKKFe4HQ5GU626DLugkk@mail.gmail.com>	 <AANLkTil49m6Ul2bauiH4Pwn-6ykrYTFmSO6_SxqQgD_e@mail.gmail.com>	 <1278626921.2435.73.camel@edumazet-laptop>	 <AANLkTiliBClahTfb41M5BDi1etg5pgkqEz_VfGrn_mK4@mail.gmail.com>	 <1278695580.2696.55.camel@edumazet-laptop>	 <AANLkTil39xHOhcdAo4h_jWtx_UuYdFHGdQVAdwPMd7QJ@mail.gmail.com> <1278742649.2538.17.camel@edumazet-laptop>
In-Reply-To: <1278742649.2538.17.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2010 09:17 AM, Eric Dumazet wrote:
>
> Strange thing with your crash report is CR2 value, with unexpected value
> of 000000000b388000 while RAX value is dce8dce85d415d41
>
> Faulting instruction is :
>
> 48 83 b8 b0 00 00 00 00   cmpq   $0x0,0xb0(%rax)
>
> So I would have expected CR2 being RAX+0xb0, but its not.
>    

Nothing strange about it.  You only get page faults and valid cr2 for 
canonical addresses (17 high order bits all equal).  In this case 
rax+0xb0 is not a canonical address, so you got a general protection 
fault instead, with cr2 unchanged.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

