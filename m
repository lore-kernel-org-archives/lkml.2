Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab1KIImd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:42:33 -0500
Received: from nm3.bullet.mail.bf1.yahoo.com ([98.139.212.162]:38685 "HELO
	nm3.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753054Ab1KIImc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:42:32 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 283567.60954.bm@omp1046.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=NIasRVmY3sdqDInZC8qSxqdN46PcrAOUksOEPFvKDHxVrRxCx4n0ba6GXzW/AHP1rP7CUWJYRoU/gDqiIa7jRuAMWSxEdFzPgYb5zV6sQ7bZadN7UgbszKOOnqRrc8wLAAksJnEetXekp+vbZGTAtuBtExgds12gP5Za5QEgboA=;
X-YMail-OSG: KrsQVloVM1n5pjQEKff0c0y526d.CajrXzo3YuCQIlp4AdO
 zEB8Duxy7pcXcc04gbRtClRuurKbp8uH8X17DOtZVaaNDCa_NjaRxs8bGSCt
 lCB6CdV.yYQhm0sZxQTZ17Y0Dbx2bYOgzCSrC9upyPzEaYcxlgdHyjLG7kLR
 CGUvSlYrn5wBiLzM0mhb8MxJKOjPkurOx8DXwdWrlCBb6wChvjvvCgjXrNNl
 fM3mE1swxPAzR30PmmH10LFt8AzQfiseDVv9KfHPy_gU6svYedqVz0MshZhM
 r0odPtQvp1QVfKEyZbFEFUUlvbZZ3oZGsULilv1DWW0Q4JYEnBj5oY964Wbj
 OmhVeQ4FG_NqKRiwhBaRL54ioJEv8d7PcPRWrwjr7vqhLBrhFzfKo088KlDm
 Bl6t79SJgyPUHJWHZpqUHMN4YlzdX0whro0q4vaxcKf76VT8tle9aD10XUFM
 60Z7omA--
X-Mailer: YahooMailWebService/0.8.115.325013
References: <1320816503.73813.YahooMailNeo@web160718.mail.bf1.yahoo.com> <1320819875.26025.48.camel@edumazet-laptop> <CAA93jw4gDuHyG508zxRzyn+MJ4gL5m958OaCWJxoDsaLgjdnqg@mail.gmail.com>
Message-ID: <1320828151.17101.YahooMailNeo@web160705.mail.bf1.yahoo.com>
Date: Wed, 9 Nov 2011 00:42:31 -0800 (PST)
From: Manavalan Krishnan <manavalan_k@yahoo.com>
Reply-To: Manavalan Krishnan <manavalan_k@yahoo.com>
Subject: Re: Large file copy to NFS mounted directory causes delay in other application packets
To: Dave Taht <dave.taht@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: netdev <netdev@vger.kernel.org>
In-Reply-To: <CAA93jw4gDuHyG508zxRzyn+MJ4gL5m958OaCWJxoDsaLgjdnqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>When I see behavior like this I keep thinking interactions between overlarge large txqueuelens, somewhat busted TCP offloads on NICs, and that pfifo_fast must die in favor of fair queuing and/or diffserv classification. But seeing >it on two different nics implies that your switch (which I assume is shared) is possibly to blame...
>(I see bufferbloat everywhere, but mostly because it's what I work on)

>Is this NFS over TCP? Does the HA daemons prioritize packets at all? Does your switch? Does your qdiscs? How deep are your buffers on the network cards and txqueuelens and switch? 
>(eric's other questions below are probably more valid)


HA   daemons does not prioritize. could you please provide info on how to prioritize application packets?
We tried with different switches, the same problem occurs. so switch may not be the issue here.
switch and qdisks does not prirotize the packets.
Here are network buffers used in the servers

txqueuelen is 1000 

net.core.netdev_max_backlog = 1000
net.core.rmem_default = 262144
net.core.rmem_max = 262144
net.core.wmem_default = 129024
net.core.wmem_max = 131071
net.ipv4.tcp_rmem = 4096    87380    4194304
net.ipv4.tcp_wmem = 4096    16384    4194304
net.ipv4.tcp_mem = 196608    262144    393216

Thanks
