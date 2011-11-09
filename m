Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab1KIISq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:18:46 -0500
Received: from nm12.bullet.mail.bf1.yahoo.com ([98.139.212.171]:31157 "HELO
	nm12.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751353Ab1KIISp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:18:45 -0500
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Nov 2011 03:18:45 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 82447.30679.bm@omp1004.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=cmmuC4wm0hqqTCkbjOI/YsMb31lC5+fJX0rsUUt0HbL/T57IssNjSlZDd4bmSlK4pzuPDcAvE/DUJstY87S/pmWnx6BYm3cYfNG/6/4K7uFhhkkKyqLzQR0nvZTDfu5aDRfprvzuw2Mv/zl7QwRtWvesVxy8fGbwSZvOqBRz2kU=;
X-YMail-OSG: zMYbKekVM1mD7QnSo8PL62LVlq0Di4z7aQFzKUhVy9GBlV6
 Y6Jys5LESObt8XveKodaBgHVx.kES3Oi6hp61KuljSqYW7lZS_SvlmyEfGsk
 di7H.XWWVmF_kr7bu98XZfbwdj.cjL63kMZBHP9Hb7ywi56Rq2T4kIxgUIcm
 .hJFHr_jkaffw8UMeStUSeNh0mTkmSQ4WLVIZ59cQu4dszDh4R194.1C8J_d
 9K57nfq0B_WjBIBGrnZ_yp5H52TGqQZ7SybiIvW.Juqo.oTBCBoX3.GOLNay
 N8l0_l4F6fPzk3ZqA1lMu159RxKrZ0IT7I0lZMKajBl9nIy19AtNGvnouYOT
 ZnLOTB0tuhuHSnxrWNGzLIavyI25JpI0oBJubZQ_PE2TC64DcxFLADaqEc1V
 k6nQB.hldKdPNz07WCg4aE3Nj8sOuRxaSruiCzGIGhDR8bf56FAilYO.wKvr
 Hz17nBqgOQN0vR8umNDkWASTyHepDoCHS_7rICP3i0i1KBEfu2n5p4ZbkcJg
 9Yl4-
X-Mailer: YahooMailWebService/0.8.115.325013
References: <1320816503.73813.YahooMailNeo@web160718.mail.bf1.yahoo.com> <1320819875.26025.48.camel@edumazet-laptop>
Message-ID: <1320826389.47194.YahooMailNeo@web160716.mail.bf1.yahoo.com>
Date: Wed, 9 Nov 2011 00:13:09 -0800 (PST)
From: Manavalan Krishnan <manavalan_k@yahoo.com>
Reply-To: Manavalan Krishnan <manavalan_k@yahoo.com>
Subject: Re: Large file copy to NFS mounted directory causes delay in other application packets
To: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <1320819875.26025.48.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(1) NFS is using TCP
(2) yes eth0 is dedicated to heartbeat and eth1 is dedicated to NFS
(3) I notice the following at the system where file copy is occuring

The kernel Recv-Q of the heartbeat application socket grows but not delivered to the socket recv call. 
Here is the netstat output.

Proto  Recv-Q  Send-Q   Local Address         Foreign Address

udp    11522                0  *:23435                     *:*

As soon as I stop the file transfer, the socket recv call receives the packets and Recv-Q goes 0.
(4) The server has 4 cpu cores and 25G RAM

________________________________
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Manavalan Krishnan <manavalan_k@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; netdev <netdev@vger.kernel.org>
Sent: Tuesday, November 8, 2011 10:24 PM
Subject: Re: Large file copy to NFS mounted directory causes delay in other application packets

Le mardi 08 novembre 2011 à 21:28 -0800, Manavalan Krishnan a écrit :
> Hi All
> 
> I have two systems with two network interfaces each(eth0 and eth1). I
> am running linux-HA (heartbeat deamon) on both the systems and they
> use eth0 for exchanging heartbeats. I have NFS mounted directory in
> one system and the NFS client uses the interface eth1. 
> 
> I try to copy a large file to NFS mounted directory. But the heartbeat
> daemons misses the heartbeat packets from peers while copy is under
> progress. I did tcpdump and found that the heartbeat packets are
> delayed for few seconds before sent out on eth0. When I stop the file
> copy, the heartbeats are delivered properly. It seems linux kernel
> somehow giving priority for NFS packets(generated from the file copy)
> over other application packets.
> 
> Any thoughts on this behavior? Is there any way we can avoid this so
> that application packets get equal chance while large file copy to NFS
> mounted directory under progress?
> 
CC netdev

1) Is your NFS using UDP or TCP ?
2) Is your eth0 dedicated to heartbeats and eth1 to NFS traffic ?
3) How do you know heartbeats are delayed ?
4) Is your server CPU bounded ?

Thanks


--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
