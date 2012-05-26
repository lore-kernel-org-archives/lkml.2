Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310Ab2EZF1o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 01:27:44 -0400
Received: from nm15-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.145]:38220 "HELO
	nm15-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751114Ab2EZF1m convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 01:27:42 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 591088.47645.bm@omp1043.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=6vE69yYWelYYL6KjwPj93EJ1Gs4OAGfTD1BD7oPsQUnyR0NELkXCR8dUHgJA3hMjTIiFWCirEM0BiyB6e0C+IOYV+odDCUVvsUgeocy9P4d9L/Nv1S+rj+FUCdyGbOEZ9aj4ocSh+kj7jnsV+vT4qKQAWd2nmR4xYcpqizb4O5s=;
X-YMail-OSG: 0kYTWSgVM1nYYQKUfRi8qA2C.t4cnPcx6E2RQaK.1uTe.zv
 EfNs.YM.E8lbMXn3bDSAkRt2EkE5fcDbiqDo6bxmqhTInrt9L17YJvbWfLEo
 rTu6VgQlGoHXmhL2Ck.WP.5M9tZSnvrEfBavhR6gXEyQSChxW8v8Qp1tge3V
 V224SpuTTlJBAqNO5NbXjKJLWYU5fkPBABhOdoBi2x4f_7YUY9wiXcjDscLW
 Jtbx2iL3X.kWy.CtTump8BMxEVeLW_WbhAwA1xNQYMwYC_FbOqOFsdMVu20n
 BjGV58BQ.1n0Amt704ydLvmfpULheBSf7Fs19A17u3NA5drMhdG2Ogmh52gc
 Ve.klTZga7EIpcIwcCI3rGNEikN95x41XT.i_yiR.zGZTOG0inpEShi4obRe
 Nxtse0AC2CtYjiC5BncAYwA5PIg--
X-Mailer: YahooMailWebService/0.8.118.349524
References: <1337406674.48432.YahooMailNeo@web121303.mail.ne1.yahoo.com>  <alpine.LSU.2.00.1205191301430.10539@eggly.anvils>  <1337992130.90506.YahooMailNeo@web121305.mail.ne1.yahoo.com> <1338006309.10135.15.camel@edumazet-glaptop>
Message-ID: <1338010061.92361.YahooMailNeo@web121306.mail.ne1.yahoo.com>
Date: Fri, 25 May 2012 22:27:41 -0700 (PDT)
From: Sam Portolla <samportolla@yahoo.com>
Reply-To: Sam Portolla <samportolla@yahoo.com>
Subject: Re: exit_mmap BUG_ON in 2.6.23 (and Add qdisc __NET_XMIT_STOLEN)
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, "kaber@trash.net" <kaber@trash.net>,
        "jarkao2@gmail.com" <jarkao2@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "samPortolla@yahoo.com" <samPortolla@yahoo.com>
In-Reply-To: <1338006309.10135.15.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





----- Original Message -----
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sam Portolla <samportolla@yahoo.com>
Cc: Hugh Dickins <hughd@google.com>; "kaber@trash.net" <kaber@trash.net>; "jarkao2@gmail.com" <jarkao2@gmail.com>; "davem@davemloft.net" <davem@davemloft.net>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sent: Friday, May 25, 2012 9:25 PM
Subject: Re: exit_mmap BUG_ON in 2.6.23 (and Add qdisc __NET_XMIT_STOLEN)

On Fri, 2012-05-25 at 17:28 -0700, Sam Portolla wrote:

Please don't top post on this list

> 
> [pease cc samPortolla@yahoo.com on the replies; not a member of this
> mailer]
> 
> Hi Hugh,
> 
> Thank you!  It turns out our 2.6.23 kernel does not have this old
> patch, I am also adding Jarek, David and Patrick who were involved in
> the below fix for their insights:
> 
> 
> commit 378a2f090f7a478704a372a4869b8a9ac206234e
> Date:   Mon Aug 4 22:31:03 2008 -0700
> net_sched: Add qdisc __NET_XMIT_STOLEN flag
> In this failure case below, as well as some others, the ethernet
> driver printed a transmit timeout just before the crash.
> 
> It seems since we don't have the above patch, the kernel qdisc Tx
> packet path for fragmented packets can be messed up and corrupt the
> skb  it passes to drivers, which in the historic case that led to
> above fix, caused an skb NULL ptr de-ref in the driver itself (which
> we also saw once). 
> 
> Jarek, David or Patrick,
> 
> Could the lack of above patch cause the kernel to also falsely detect
> transmit timeouts on various drivers as it can not properly keep track
> of packets transmitted? Can you please elaborate so  a newbie like me
> can understand?
> 
> Is the above commit the sole one required for the kernel panic/skb
> NULL de-ref driver issue or is there more needed fixes later on that
> can be backported to an older kernel (2.6.23 GNU/Linux x86_64)?
> 

Transmit timeouts are because of races in some network drivers.

The device stay in XOFF state for too long time (forever as a matter of
fact once the race triggered)

Since 2.6.23 we fixed a lot of them, but still races still exist.

Yes, thanks I had looked at the kernel  code and know how transmit timeouts come to be in normal cases. The driver specifies a timeout period to the network layer, along with a callback function to call in case of Tx timeout so the driver can do error handling which is typically to reset the driver (and this happened in the case of the BNX2 linux driver our system uses as well). Above I had asked some specific questions with regards to whether a known bug w/ qdisc could stop the Tx Q's to the device and thereby cause traffic timeouts. Also it seems from the email thread on the patch I had mentioned above that the qdisc issue can cause memory corruption, which could then tie it in with the BUG_ON in exit_mmap() which Hugh had previously commented on. I am hoping the engineers who fixed the QDISC issue can comment on the former and Hugh can comment on the BUG_ON again. Regards. 
