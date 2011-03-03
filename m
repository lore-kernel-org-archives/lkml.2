Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab1CCHiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:38:25 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57034 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab1CCHiX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:38:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hPJwzG3/ZhDcm2Ea+uK8I23RAmXNZJoBq9Rhu4buop5BOv3CBCPTOt/hXh96L0Mu46
         4pepSKTV1M6cE4g55TIMZcZRWZ8oXFYQdPvbsK6qt24X5fuPzKR8nBB/b5v8WIenc21s
         b11WHKs6sV9lzaaz1wcN8wSp1yUCvR4TnTA5M=
MIME-Version: 1.0
In-Reply-To: <20110301.151622.200374696.davem@davemloft.net>
References: <1299021191-17961-1-git-send-email-arnd@arndb.de>
	<1299021191-17961-6-git-send-email-arnd@arndb.de>
	<20110301.151622.200374696.davem@davemloft.net>
Date: Thu, 3 Mar 2011 18:38:22 +1100
Message-ID: <AANLkTinfM=OyMwHEuMejNtcXTUSWP=j_9oYXSU0gx=8Q@mail.gmail.com>
Subject: Re: [PATCH 5/7] x25: remove the BKL
From: Andrew Hendry <andrew.hendry@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good, put 8gig through it over the past few days and system stable.

Tested-by: Andrew Hendry <andrew.hendry@gmail.com>

On Wed, Mar 2, 2011 at 10:16 AM, David Miller <davem@davemloft.net> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Wed,  2 Mar 2011 00:13:09 +0100
>
>> This replaces all instances of lock_kernel in x25
>> with lock_sock, taking care to release the socket
>> lock around sleeping functions (sock_alloc_send_skb
>> and skb_recv_datagram). It is not clear whether
>> this is a correct solution, but it seem to be what
>> other protocols do in the same situation.
>>
>> Includes a fix suggested by Eric Dumazet.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Acked-by: David S. Miller <davem@davemloft.net>
>
