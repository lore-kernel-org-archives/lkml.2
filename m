Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab2HDOpz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 10:45:55 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44053 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab2HDOpy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 10:45:54 -0400
MIME-Version: 1.0
From: =?UTF-8?Q?S=C5=82awek_Janecki?= <janecki@gmail.com>
Date: Sat, 4 Aug 2012 16:45:33 +0200
Message-ID: <CACS4u_zUF9T0rSsndhyVzgaauOBFJ4LTUeb432B1zg_oLHvTsg@mail.gmail.com>
Subject: TCP Delayed ACK in FIN/ACK
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a node.js client (10.177.62.7) requesting some data from http
rest service from server (10.177.0.1).
Client is simply using nodejs http.request() method (agent=false).
Client is on Ubuntu 11.10 box.
Why client sends FIN ACK after 475ms? Why so slow? He should send FIN
ACK immediately.
I have many situations like this. About 1% of whole traffic is request
with delayed FIN ACK.
Cpu idle on the client is about 99%, so nothing is draining CPU.
How to debug this? What could it be? Is there any sysctl option I need to tune?
I think this behaviour is the Delayed ACK feature of RFC1122 TCP stack.

Link to tcpdump picture (done on a client machine) :
http://i48.tinypic.com/35cpogx.png

Can you tell why kernel delayed that FIN/ACK.
In tcpflow data there is exacly one ACK per packet comming from server.
Why kernel delayed client FIN/ACK.
It could avoid sending ACK every 'data' packet.
But it choose to delay FIN/ACK?
Is this possible? Is this a bug?

I've also posted question on stackexchange:
http://stackoverflow.com/questions/11711218/client-sends-delayed-fin-ack-500ms-to-server

Please help.

-- 
pozdrawiam
Sławomir Janecki
