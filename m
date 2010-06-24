Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab0FXN6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 09:58:34 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:16406 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab0FXN6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 09:58:32 -0400
Message-ID: <4C236486.5070708@hp.com>
Date: Thu, 24 Jun 2010 09:58:30 -0400
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: =?UTF-8?B?RGllZ28gRWxpbyDigJxGbGFtZWV5ZXPigJ0gUGV0dGVuw7I=?= 
	<flameeyes@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org
Subject: Re: [PATCH] sctp: implement SIOCINQ ioctl()
References: <1277329060-21543-1-git-send-email-flameeyes@gmail.com>	 <4C235B75.2000807@hp.com> <1277385636.13544.67.camel@yamato.local>	 <4C236063.9050302@hp.com> <1277387081.13544.75.camel@yamato.local>
In-Reply-To: <1277387081.13544.75.camel@yamato.local>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Diego Elio “Flameeyes” Pettenò wrote:
> Il giorno gio, 24/06/2010 alle 09.40 -0400, Vlad Yasevich ha scritto:
>> You don't call accept() on an SCTP SEQPACKET socket.  You can just
>> read from it.
> 
> Okay I guess I'll send a patch to the man page to fix that then.

I don't think the man page needs an update.  This is just an SCTP-ism.
There are other protocols using SOCK_SEQPACKET that implement and support
accept() call.

The SCTP api spec decided that it wouldn't support accept() and we have to
follow it.


> 
>> This way, you'll ignore listening SOCK_STREAM sockets which will not
>> have any
>> data anyway, but you'll check out listening SOCK_SEQPACKET sockets
>> that may have
>> data waiting on them. 
> 
> Ah I think I see what you mean here: SIOCINQ would work for TCP-style
> ESTABLISHED sockets _and_ SEQPACKET LISTENING sockets, right?

Right.

-vlad

> 
> Will send the updated patch in a moment.
> 
