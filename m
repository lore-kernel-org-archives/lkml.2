Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab2EZGRB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 02:17:01 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36428 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab2EZGQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 02:16:59 -0400
Subject: Re: exit_mmap BUG_ON in 2.6.23 (and Add qdisc __NET_XMIT_STOLEN)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sam Portolla <samportolla@yahoo.com>
Cc: Hugh Dickins <hughd@google.com>, "kaber@trash.net" <kaber@trash.net>,
        "jarkao2@gmail.com" <jarkao2@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1338010061.92361.YahooMailNeo@web121306.mail.ne1.yahoo.com>
References: <1337406674.48432.YahooMailNeo@web121303.mail.ne1.yahoo.com>
	 <alpine.LSU.2.00.1205191301430.10539@eggly.anvils>
	 <1337992130.90506.YahooMailNeo@web121305.mail.ne1.yahoo.com>
	 <1338006309.10135.15.camel@edumazet-glaptop>
	 <1338010061.92361.YahooMailNeo@web121306.mail.ne1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 May 2012 08:16:55 +0200
Message-ID: <1338013015.10135.23.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 22:27 -0700, Sam Portolla wrote:

> Yes, thanks I had looked at the kernel  code and know how transmit
> timeouts come to be in normal cases. The driver specifies a timeout
> period to the network layer, along with a callback function to call in
> case of Tx timeout so the driver can do error handling which is
> typically to reset the driver (and this happened in the case of the
> BNX2 linux driver our system uses as well). Above I had asked some
> specific questions with regards to whether a known bug w/ qdisc could
> stop the Tx Q's to the device and thereby cause traffic timeouts. Also
> it seems from the email thread on the patch I had mentioned above that
> the qdisc issue can cause memory corruption, which could then tie it
> in with the BUG_ON in exit_mmap() which Hugh had previously commented
> on. I am hoping the engineers who fixed the QDISC issue can comment on
> the former and Hugh can comment on the BUG_ON again. Regards. 


The commit you mention is about a very unusual use of qdiscs.
I really doubt it is your problem.
Most advanced tc users probably wont stick with 2.6.23 kernels.

Please post :

tc -s -d qdisc

And for all your network devices : 

for DEV in eth0 eth1 eth2
do
tc -s -d class show dev $DEV
done


