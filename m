Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab2EaAfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 20:35:50 -0400
Received: from nm31-vm7.bullet.mail.ne1.yahoo.com ([98.138.229.47]:46861 "HELO
	nm31-vm7.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753056Ab2EaAfW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 20:35:22 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 May 2012 20:35:22 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 808895.37569.bm@omp1037.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=xnubPNC/cqPmBs1X2STPBs5P9NxvpYT2Bo9eQw6j7Sm3IJag/ipOxojOe/gUZj4pqMoNOGSyoZ4DHRrb7DnNWPcLmj1Pw0lGRArvPpo/6fOjWEZIgkSAroVuO9PbJNieEya/kqpr8k4HoCfQGeiWAA5mAOsdgu7hFox6LcTa8C0=;
X-YMail-OSG: ZLOUuCUVM1mw8mKPQbeWIwC8mUrdxxw96bvcR6arlBt4IS3
 WCYLMxmHlLQqA.SN5X_fBXT6kvGDi_lVr8jjsQXa4piV0FKkc9HeHGhKSd_5
 EPNwV1ID80EO6UFs.e_BRTznpqIMHPGJfFSeWqRx.A5cw1CujIG8s_276Izq
 VPOTW6daK3wUcduyDvK_oqg6aGVVdsHEZuuPdPA0HElT2K671mVHy.hDeSbO
 1z_yjVdCx3g1kuSlh94j3JQEzUSBEYCaDvXdfC0L7YEEBZMyIc9lZuhaj9sz
 Q4vuHwnVYc71Udt5DWfgKWlOs0F2FlUzKzYEB8xGr_xuclEnmCv8N48tFCqT
 puRLDVXOcwVY0Lw1XevdHpHqUuKQH.tu8MrjSC_8mjXKMLHb8wQG653FNTwq
 PM7J8fQvnCVcJnu.9QtS7.ekSiQ--
X-Mailer: YahooMailWebService/0.8.118.349524
References: <1337406674.48432.YahooMailNeo@web121303.mail.ne1.yahoo.com>  <alpine.LSU.2.00.1205191301430.10539@eggly.anvils>  <1337992130.90506.YahooMailNeo@web121305.mail.ne1.yahoo.com>  <1338006309.10135.15.camel@edumazet-glaptop>  <1338010061.92361.YahooMailNeo@web121306.mail.ne1.yahoo.com> <1338013015.10135.23.camel@edumazet-glaptop>
Message-ID: <1338424121.11094.YahooMailNeo@web121306.mail.ne1.yahoo.com>
Date: Wed, 30 May 2012 17:28:41 -0700 (PDT)
From: Sam Portolla <samportolla@yahoo.com>
Reply-To: Sam Portolla <samportolla@yahoo.com>
Subject: Re: exit_mmap BUG_ON in 2.6.23 (and Add qdisc __NET_XMIT_STOLEN)
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, "kaber@trash.net" <kaber@trash.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1338013015.10135.23.camel@edumazet-glaptop>
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
Sent: Friday, May 25, 2012 11:16 PM
Subject: Re: exit_mmap BUG_ON in 2.6.23 (and Add qdisc __NET_XMIT_STOLEN)

On Fri, 2012-05-25 at 22:27 -0700, Sam Portolla wrote:

> Yes, thanks I had looked at the kernel  code and know how transmit
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

Hi Eric,

Can you please elaborate on what you mean by the commit is "about a very unusual use of qdiscs"?
The lack of this fix was at the time determined to cause the ether driver to do a NULL ptr de-ref on its  Tx ring SKB, which is what we saw in our case as well.  The qdisc code apparently was changing the "nr_frags" field in the SKB, while the driver was the owner of the SKB, causing the issue. 
 
Can't find the "tc" command mentioned above on our system. Tried from harddisk directory as well dev directory. 
What is "tc" and could you please paste how you run it on your system? Also the 2.6.23  GNU/linux we use is not fully compatible with the previously mentioned qdisc commit. For example, there is no qdisc_enqueue() function in our baseline and ditto for some of the other code. So seems risky to backport this patch. If we go w/ backporting it, i can post my diffs here, and would really appreciate a review from you. Regards.
