Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976Ab0ENXXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 19:23:01 -0400
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:40628 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753414Ab0ENXW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 19:22:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=uJjPUaxdRSw4ePnmgigL6LQYGCoklaKspBocKWw4WtPKll4CNnpOeECPuc2xsmMu;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Fri, 14 May 2010 19:22:53 -0400
From: Bill Fink <billfink@mindspring.com>
To: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
Cc: "Arce, Abraham" <x0066660@ti.com>, "Ben Dooks" <ben@simtec.co.uk>,
       "David Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, "Jan, Sebastien" <s-jan@ti.com>
Subject: Re: [PATCH 2.6.34-rc6] net: Improve ks8851 snl transmit performance
Message-Id: <20100514192253.d12babbe.billfink@mindspring.com>
In-Reply-To: <14385191E87B904DBD836449AA30269D021A66@MORGANITE.micrel.com>
References: <14385191E87B904DBD836449AA30269D021A64@MORGANITE.micrel.com>
	<27F9C60D11D683428E133F85D2BB4A53043DF7779A@dlee03.ent.ti.com>
	<14385191E87B904DBD836449AA30269D021A66@MORGANITE.micrel.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4dad4c1478c81a96377e15c94fa3ca4472350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 71.127.147.254
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010, Ha, Tristram wrote:

> I use a web browser to send patches through my company's e-mail system.  The message is composed by cut and paste, so it may not conform to Linux standard.
> 
> The latest nuttcp default size for UDP is 1500 bytes, rather than 8192 bytes.  In my case, the transmit performance improves from 10 Mbps to 11.  Have you tried TCP?

Just a nuttcp correction.  The default unicast UDP buflen in any
recent nuttcp is the largest power of 2 less than the MSS of the
control connection.  This means that the default UDP buflen for a
1500 byte MTU link is 1024, while for 9000 byte jumbo capable
networks it would be 8192.  This was done to avoid IP fragmentation
by default in most common scenarios (can be overridden by explicitly
setting the buflen with the "-l" nuttcp option).

						-Bill



> -----Original Message-----
> From: Arce, Abraham [mailto:x0066660@ti.com]
> Sent: Thu 5/6/2010 10:02 PM
> To: Ha, Tristram; Ben Dooks
> Cc: David Miller; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jan, Sebastien
> Subject: RE: [PATCH 2.6.34-rc6] net: Improve ks8851 snl transmit performance
>  
> Hi,
> 
> [snip]
> 
> > There is a driver option no_tx_opt so that the driver can revert to original
> > implementation.  This allows user to verify if the transmit performance
> > actually improves.
> 
> Should we limit patch description to 80 characters also?
> 
> > Signed-off-by: Tristram Ha <Tristram.Ha@micrel.com>
> > ---
> > This replaces the [patch 01/13] patch I submitted and was objected by David.
> > 
> > Other users with Micrel KSZ8851 SNL chip please verify the transmit
> > performance does improve or not.
> 
> Tested-by: Abraham Arce <x0066660@ti.com>
> 
> Executing some nuttcp scenarios:
> 
> - Without Patch -
> 
> # /testsuites/ethernet/bin/nuttcp -u -i -Ri50m <serverip>
>  1.2676 MB /   1.00 sec =   10.6330 Mbps     0 /  1298 ~drop/pkt  0.00 ~%loss
>  1.2705 MB /   1.00 sec =   10.6579 Mbps     0 /  1301 ~drop/pkt  0.00 ~%loss
>  1.2686 MB /   1.00 sec =   10.6414 Mbps     0 /  1299 ~drop/pkt  0.00 ~%loss
>  1.2695 MB /   1.00 sec =   10.6496 Mbps     0 /  1300 ~drop/pkt  0.00 ~%loss
>  1.2695 MB /   1.00 sec =   10.6496 Mbps     0 /  1300 ~drop/pkt  0.00 ~%loss
>  1.2686 MB /   1.00 sec =   10.6414 Mbps     0 /  1299 ~drop/pkt  0.00 ~%loss
>  1.2686 MB /   1.00 sec =   10.6414 Mbps     0 /  1299 ~drop/pkt  0.00 ~%loss
>  1.2646 MB /   1.00 sec =   10.6086 Mbps     0 /  1295 ~drop/pkt  0.00 ~%loss
>  1.2686 MB /   1.00 sec =   10.6412 Mbps     0 /  1299 ~drop/pkt  0.00 ~%loss
>  1.2695 MB /   1.00 sec =   10.6498 Mbps     0 /  1300 ~drop/pkt  0.00 ~%loss
> 
> 12.7314 MB /  10.02 sec =   10.6637 Mbps 4 %TX 0 %RX 0 / 13037 drop/pkt 0.00 %loss
> 
> - With Patch -
> 
> # /testsuites/ethernet/bin/nuttcp -u -i -Ri50m 10.87.231.229
>     1.2891 MB /   1.00 sec =   10.8133 Mbps     0 /  1320 ~drop/pkt  0.00 ~%loss
>     1.2900 MB /   1.00 sec =   10.8217 Mbps     0 /  1321 ~drop/pkt  0.00 ~%loss
>     1.2900 MB /   1.00 sec =   10.8217 Mbps     0 /  1321 ~drop/pkt  0.00 ~%loss
>     1.2910 MB /   1.00 sec =   10.8298 Mbps     0 /  1322 ~drop/pkt  0.00 ~%loss
>     1.2910 MB /   1.00 sec =   10.8299 Mbps     0 /  1322 ~drop/pkt  0.00 ~%loss
>     1.2900 MB /   1.00 sec =   10.8216 Mbps     0 /  1321 ~drop/pkt  0.00 ~%loss
>     1.2900 MB /   1.00 sec =   10.8216 Mbps     0 /  1321 ~drop/pkt  0.00 ~%loss
>     1.2891 MB /   1.00 sec =   10.8135 Mbps     0 /  1320 ~drop/pkt  0.00 ~%loss
>     1.2900 MB /   1.00 sec =   10.8216 Mbps     0 /  1321 ~drop/pkt  0.00 ~%loss
>     1.2910 MB /   1.00 sec =   10.8298 Mbps     0 /  1322 ~drop/pkt  0.00 ~%loss
> 
>    12.9492 MB /  10.02 sec =   10.8461 Mbps 4 %TX 0 %RX 0 / 13260 drop/pkt 0.00
> %loss
> 
> Also simulated heavy transmission consisting of 40 processes executed in parallel:
> 
>  - 20 ping instances using packet size of 32768
>  - 20 dd instances creating a 50MB file each under the nfs rootfs
> 
> If any specific test scenario/application is required please do let me know...
> 
> Best Regards
> Abraham
