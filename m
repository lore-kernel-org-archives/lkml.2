Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab0KHSkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 13:40:49 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:45185 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab0KHSks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 13:40:48 -0500
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Nov 2010 13:40:48 EST
Message-ID: <4CD8420B.8050000@hp.com>
Date: Mon, 08 Nov 2010 10:31:39 -0800
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: ranjith kumar <ranjithproxy@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: how to read one udp packet with more than one recvfrom() calls?
References: <AANLkTi=40758wF4Z6GDfm809miA-hnCnSQdwA9bALX0+@mail.gmail.com>
In-Reply-To: <AANLkTi=40758wF4Z6GDfm809miA-hnCnSQdwA9bALX0+@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ranjith kumar wrote:
> Hi,
> 
> I  have implemented client and server programs using udp
> protocol(files are attached). UDP packet size is 500bytes.
> 
> I want to read these 500bytes in two calls to recvfrom(). First time
> reading 100bytes and second time 400bytes.
> How to do this?

You can't. Certainly not in antyhing remotely portable.  Receipt of a UDP 
datagram is a one-shot proposition - the bytes from the UDP datagram that do not 
fit in the buffer(s) provided in the receive call are discarded.  You might look 
into readv() or recvmsg() if you want to get bytes placed into different buffers.

> When I tried to change the third argument of recvfrom(size_t len),
> from 500 to 100, first 100bytes are read correctly.
> But when I call recvfrom() second time with len=400, it is reading the
> first 400bytes of "next udp packet".
> Why? Isn't it possible to read one udp packet in two calls to
> recvfrom()/read()????

SOCK_DGRAM+UDP provides datagram semantics, not byte-stream semantics.

rick jones
