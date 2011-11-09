Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab1KIF2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 00:28:25 -0500
Received: from nm15.bullet.mail.bf1.yahoo.com ([98.139.212.174]:38795 "HELO
	nm15.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750795Ab1KIF2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 00:28:24 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 646582.45172.bm@omp1041.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=K1aqwH4k5X34pVPB5P/JBildwRcyN81tcovGpOSb4nCuMsOXpYLqAaAHn18lv3WK0B7FmDr07DnRVSs3aB1kFQT+0FgQfKOoaqkMn/D2uob+LAn0vMWywq4lxhU2itp+F/YlzzauFm2XBmE3crXQ1sNl1SN+IOkiVh19BVHfzcM=;
X-YMail-OSG: GAlorSsVM1mBKsjvRNkj1D5EPfQ2_w5pt4OmCSouGwPWLQ9
 ZPd_bm0Ouvt9FQNrojf6imGN7puXlctANGKfOon1u2p3EuBrS4bRW9EumWIg
 zu5uqMor9fz6fr7j_.vs8a5uJMUn2TTrquBm55tuZhnSNJhvtARVw7GPr4BQ
 7PmVeQiEjsgK2xj0i54WYpcXgZ2.5JVknDSfeSqxeU_3BDPl1K5Jkk0avHdm
 V2ILOJWlgO1ez_oX5uC7TTnZtmLkiqNUhhx5ATFlR3Fvr_n5rv0RnLXSLWM5
 6XCEQs02ykjAvZr_KdywwV9iGRCrxcpjhU0_L5PdHaj1kyM9d.MFD3c9Bgmd
 rvf5B_n_8HFkydacyj_56ZnhsKuYTiFnS5I9LOYMMVJysXlNrAwV6K4jZ7Tk
 7AcUfovvS8jPwNnJU9ijuphXL4KJHVgW1_IipsyPih4U6
X-Mailer: YahooMailWebService/0.8.115.325013
Message-ID: <1320816503.73813.YahooMailNeo@web160718.mail.bf1.yahoo.com>
Date: Tue, 8 Nov 2011 21:28:23 -0800 (PST)
From: Manavalan Krishnan <manavalan_k@yahoo.com>
Reply-To: Manavalan Krishnan <manavalan_k@yahoo.com>
Subject: Large file copy to NFS mounted directory causes delay in other application packets
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All

I have two systems with two network interfaces each(eth0 and eth1). I am running linux-HA (heartbeat deamon) on both the systems and they use eth0 for exchanging heartbeats. I have NFS mounted directory in one system and the NFS client uses the interface eth1. 

I try to copy a large file to NFS mounted directory. But the heartbeat daemons misses the heartbeat packets from peers while copy is under progress. I did tcpdump and found that the heartbeat packets are delayed for few seconds before sent out on eth0. When I stop the file copy, the heartbeats are delivered properly. It seems linux kernel somehow giving priority for NFS packets(generated from the file copy) over other application packets.

Any thoughts on this behavior? Is there any way we can avoid this so that application packets get equal chance while large file copy to NFS mounted directory under progress?

Thanks Much
Mana

