Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab0HNO7l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 10:59:41 -0400
Received: from smtp145.mail.ukl.yahoo.com ([77.238.184.76]:38040 "HELO
	smtp145.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756702Ab0HNO7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 10:59:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=V0mJyi4Xegn2wWuTYiuFxiUFlF/LRBJxG3r1fvaKhQbNogpRpziLeMF+KNQ3N5OQ1mWFrbzz+gEdxKnfp1ZZgZOE+j3t684RFDSDy918X0PWEEQmUpdsfK39OUEf9Fqxdms9n+9mdmmJw6EaO/GcoQBRRZBx4tpuZ/DuASAGtKk=  ;
X-Yahoo-SMTP: tW.h3tiswBBMXO2coYcbPigGD5Lt6zY_.Zc-
X-YMail-OSG: NcN.X4MVM1kXKViGebb8zMMEcAZvPY0NvLNId8q.rhDk83o
 yXaSx2bHlVX1XZOUUgAnHR094KDOV0hHMiS1jiXx4qFBxfMgrY4y0HxJa5jT
 XMqmYJUY0IRFUc9DwfRHHazvMwEflJmgTkcUc72KR7wT8aW08RbPTsT4EMpt
 HcFA3MuV.0V3NmFS_JyivNKkGRMgX3pV.kuQlixUgnuaNGJC8Ovh61SKEjz5
 x3Lirgw6Calk5uicp2EM7NUQsLPPe.X9ixXoRwQBxCH671Rs5PwXtkInl4kL
 ywSGdseHqpToTPZs1efL.1AMznzD3WsE.6HhZkv31nS3vUeY-
X-Yahoo-Newman-Property: ymail-3
From: Marek Lindner <lindner_marek@yahoo.de>
To: Vasiliy Kulikov <segooon@gmail.com>,
        Linus =?utf-8?q?L=C3=BCssing?= <linus.luessing@web.de>
Subject: Re: batman-adv: design suggestions
Date: Sat, 14 Aug 2010 16:59:13 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.32-5-amd64; KDE/4.4.5; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, Andrew Lunn <andrew@lunn.ch>,
        Sven Eckelmann <sven.eckelmann@gmx.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <20100809203403.GA16183@albatros> <20100813181833.GA5632@albatros>
In-Reply-To: <20100813181833.GA5632@albatros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008141659.14868.lindner_marek@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 August 2010 20:18:33 Vasiliy Kulikov wrote:
> d) Why do you send icmp TTL exceeded for the icmp itself? E.g. in case
> of loop or/and small default TTL you'll probably get a storm of icmps.
> Exactly in this case IP silently drops TTL exceeded icmps ;)

These layer2 icmp packets are not ordinary icmp packets. We needed to provide 
a mechanism to make the network topology visible to debug tools like ping or 
traceroute which normally "see" no more than one hop as they operate on 
layer3. Hence, batman-adv does not send an icmp packet for each payload TTL 
exceeded but for traceroute only. I recommend reviewing the traceroute code to 
understand how this is supposed to work:
http://www.open-mesh.org/browser/trunk/batctl/traceroute.c

I'd be interested to learn about a problematic scenario in which this 
mechanism breaks.

Regards,
Marek
