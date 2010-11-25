Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab0KYQow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:44:52 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61971 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab0KYQov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:44:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UpgnHodHxvLHIZbUapvkf1is8nPq5EKKcSJhXxa+x5JSGJdSm+nxevTtkHFWkJKAaQ
         ZF8MxogRB32IrbOlqmzyrcBMF7vF8/zctImW4eQAdSwsLMHpwmh/aZitQXTeTOpxcQyG
         zP9Wa/GeIRq8KJ22sYj6xuYpM1K9vBeYmM26U=
Subject: Re: TCP_MAXSEG vs TCP/generic segmentation offload (tso/gso)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Niels =?ISO-8859-1?Q?M=F6ller?= <nisse@lysator.liu.se>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <nn1v69qsjd.fsf@stalhein.lysator.liu.se>
References: <nny68hqzzn.fsf@stalhein.lysator.liu.se>
	 <1290695253.2858.336.camel@edumazet-laptop>
	 <nnaakxqw1u.fsf@stalhein.lysator.liu.se>
	 <1290698312.2858.341.camel@edumazet-laptop>
	 <nn1v69qsjd.fsf@stalhein.lysator.liu.se>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 17:44:45 +0100
Message-ID: <1290703485.2858.360.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 25 novembre 2010 à 17:25 +0100, Niels Möller a écrit :


> 
> I was under the impression that TSO (and maybe GSO) implied more
> cleverness in the network card; that the network card more or less gets
> to decide by itself how to divide a tcp stream into segments. And for
> example in the atl1c driver which I looked a bit into, this was what the
> REG_MTU register was for. Seems I have gotten this totally wrong.
> 

You were not totally wrong, but device does not use its own MTU to
perform the split : We give it the MSS of the flow.

You can have multiple flows in parallel, each with its own MSS, while
device has a single MTU.

> Maybe Documentation/networking/netdevices.txt could clarify how it
> works. Currently, it says
> 
> : Segmentation Offload (GSO, TSO) is an exception to this rule.  The
> : upper layer protocol may pass a large socket buffer to the device
> : transmit routine, and the device will break that up into separate
> : packets based on the current MTU.


MTU means : maximum transmission unit. But each layer has its own :)

In this context, TCP protocol, so MSS should be taken into account.

By default, MSS derives from device MTU  (ipv4 without options case :
MSS = MTU - 40), but user can change it with TCP_MAXSEG.



