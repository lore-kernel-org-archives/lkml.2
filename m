Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab2AXI6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 03:58:33 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43346 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754667Ab2AXI6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 03:58:32 -0500
MIME-Version: 1.0
Date: Tue, 24 Jan 2012 16:58:31 +0800
Message-ID: <CAC=NXX3jdCAjmwTjQ-d43DWb-617a33nMcWb_UvBUyB_q7VZTQ@mail.gmail.com>
Subject: How to accelerate tcp retransmition
From: leno soff <lnxuff@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, eric.dumazet@gmail.com, davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,
   I have a lot of client, say C1, C2, .. Cn, which route packets to
my servers through router R. But R will drop 70% - 90% _ non-SYN _
packets from clients to Server.

  The clients and server work like http client and server, sending a
request, wating for the response.

  When router R drop the request-like packets(without SYN flag, of
cause), the clients retransmit with icsk_backoff++;  They usually
should wait 15 seconds+ (1+2+4+8), and sometimes more or just timeout.

   So, my question is:

        Is there any way in _server_ side, to accelerate the
retransmition like accelerating slow-start. I tried SO_KEEPALIVE in
server, interval == 1 second or less,  I assume the keepalive ack will
 accelerate the retransmition, ,  but it does not work:

       Flags [P.], seq 1:314, ack 1.  ----------------client request,
which is lost
       Flags [.], ack 1, win 905, length 0  --- server keepalive ack
       Flags [.], ack 1, win 115, length 0  --- client responds ack
       .... A lot keepalive and response.

    The client timeout because of RTO, why doesn't retransmit the
request packet but just an ack without data when it sees keepalive ack
?


Thanks.
