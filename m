Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab1LURED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 12:04:03 -0500
Received: from yuna.grokhost.net ([87.117.228.63]:35397 "EHLO
	yuna.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1LUREC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 12:04:02 -0500
Message-ID: <4EF2117F.6000803@bootc.net>
Date: Wed, 21 Dec 2011 17:03:59 +0000
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in ipv6_select_ident
References: <4EF200BB.7000209@bootc.net> <1324484956.2301.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1324484956.2301.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/12/2011 16:29, Eric Dumazet wrote:
> Le mercredi 21 décembre 2011 à 15:52 +0000, Chris Boot a écrit :
>> Hi folks,
>>
>> I'm working on getting a 2-node VM cluster up and running, with DRBD and
>> Corosync/Pacemaker, running KVM VMs.
>>
>> I can trigger a kernel panic in either _host_ system when running an
>> rsync on a _guest_ VM. The rsync is simply SSH over IPv6 from a remote
>> mail store (containing maildirs) to a local filesystem. I'm basically
>> working on migrating a physical IMAP server to one inside a VM.
>>
>> After a few seconds of fairly heavy IPv6 traffic, I get the panic below.
>> You'll notice the panic refers to vhost_net, but I tried without that
>> and the kernel panics at exactly the same call point.
>>
>> Panic:
>>
>> [snip]
>>
>> Any insight will be gratefully received.
>>
>> Thanks,
>> Chris
>>
> Is it a debian kernel ?
>
> You need : https://lkml.org/lkml/2011/10/11/291

Eric,

Aha, that sounds like exactly the culprit, thanks. However I can't find 
any reference to it in the 3.1 to 3.1.5 changelogs. Is it fixed in any 
of those kernels or would I have to attempt to forward-port the fix myself?

Cheers,
Chris

-- 
Chris Boot
bootc@bootc.net

