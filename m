Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345Ab2EaScw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:32:52 -0400
Received: from nm25-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.185]:34617 "HELO
	nm25-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754714Ab2EaScv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:32:51 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 90524.78066.bm@omp1037.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=1kxFNqFj5nS4dFg5K6qDdJvYC81rYYxqVvMFk1/AHnRnQGqXOdyPo3pJVoekx/gCxoEKv0LB7gdp2JvoWcRzVzZTyGBwBxbbqpZ2smXiMmLS4f+bgSvQtqApZg28dGfi1UG8tMbp6zndolHiUhFfbAqt46E+DO6eZnZylk0YXZw=;
X-YMail-OSG: mGlkH04VM1kMFHLtVRLEhpAA51GCvnUdgNIlnkTdtv.N18g
 Nwg6cs.iBofPdplW.7jaQCJNuDQQs2SJKyEY7wDpuCtE_VkeiEJcgzNzuC0I
 SOXhb1D4n9PWrSU4rOeP8WPLW18RGj1tN9OGxIEHm8DaIX6_kgLjTMgOfQPy
 1m48KACxdFr6YTBb9S9nsbz.PwLRv8kvR01vs7MFOav8jYVjLx7uPliugTJa
 fQ8gKy3xAK9LOqZ8EoaNjkcw_mGPJ6DGrzezUnf8Ne3Qq0Ybihv8i12tzwFL
 B3kYl9rGxWOUNJ54RZ86BHDbPV5F.xmJg0R53hzMqZI0.avH1eI9rl9I9I8s
 KHNnD3AgV2RCJ0EQz8SaGR3zjhaq3bpzII9hBmvktHusg3T_PlFfkqq9c41q
 yJV97q0o7o82fW1ENdK5FVTX.BIs-
X-Mailer: YahooMailWebService/0.8.118.349524
References: <1337406674.48432.YahooMailNeo@web121303.mail.ne1.yahoo.com> <alpine.LSU.2.00.1205191301430.10539@eggly.anvils> <1337992130.90506.YahooMailNeo@web121305.mail.ne1.yahoo.com> <alpine.LSU.2.00.1205261033500.2033@eggly.anvils>
Message-ID: <1338489169.41890.YahooMailNeo@web121305.mail.ne1.yahoo.com>
Date: Thu, 31 May 2012 11:32:49 -0700 (PDT)
From: Sam Portolla <samportolla@yahoo.com>
Reply-To: Sam Portolla <samportolla@yahoo.com>
Subject: Re: exit_mmap BUG_ON in 2.6.23 (and Add qdisc __NET_XMIT_STOLEN)
To: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, "kaber@trash.net" <kaber@trash.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "samPortolla@yahoo.com" <samPortolla@yahoo.com>
In-Reply-To: <alpine.LSU.2.00.1205261033500.2033@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[please cc samPortolla@yahoo.com on the reply as not a member of this mailer]



----- Original Message -----
From: Hugh Dickins <hughd@google.com>
To: Sam Portolla <samportolla@yahoo.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>; "kaber@trash.net" <kaber@trash.net>; "jarkao2@gmail.com" <jarkao2@gmail.com>; "davem@davemloft.net" <davem@davemloft.net>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Sent: Saturday, May 26, 2012 11:06 AM
Subject: Re: exit_mmap BUG_ON in 2.6.23 (and Add qdisc __NET_XMIT_STOLEN)

On Fri, 25 May 2012, Sam Portolla wrote:
> 
> commit 378a2f090f7a478704a372a4869b8a9ac206234e
> Date:   Mon Aug 4 22:31:03 2008 -0700
> net_sched: Add qdisc __NET_XMIT_STOLEN flag
...
> 
>  I wonder if the lack of above patch in our code base could explain the
>  exit_mmap() BUG_ON as well due to memory corruption causing MMU to not
>  be able to locate the page(s) it had to free. NR_PTES keeps track of
>  that? Could you explain that more?

I concur with Eric in thinking it unlikely - though (unlike Eric)
I know far too little about networking to comment with authority.

I'd guess that there have been literally hundreds of fixes gone into
the kernel since 2.6.23, each more likely to be the fix to such memory
corruption than this one.  And I could also be wrong in attributing
your BUG to memory corruption: perhaps I'm forgetting an mm fix.

You ask me to explain more: mm->nr_ptes keeps track of the number of
page tables that have been allocated; when we free the mm, we should
be freeing exactly the number of page tables we allocated earlier,
but a bug in the code maintaining the vmas or the page tables might
break that, hence the BUG_ON to test.  But equally, if there has been
memory corruption of vmas or of higher-level page tables, we may now
be unable to locate all the page tables we allocated earlier, and so
hit the BUG_ON for that reason.

Would I be unfair to characterize this as a problem seen once at a
customer site in the 4.5 years since 2.6.23 was released?

As I said before, please just change that BUG_ON to WARN_ON, and
wait to see if more such issues come up: if they do, then you can
start to look for a pattern.

Hi Hugh, The concern I have with changing BUG_ON to WARN_ON, is one you had mentioned earlier in the thread.
If there is a memory corruption, BUG_ON causes system reboot and a clean start. WARN_ON won't and we might again end up crashing somewhere totally unrelated, possibly much later, i.e. unknown impact of this change. I know you know this area 100 times or more than me, but this is my concern and I am ready to be corrected, by all means.

Hugh and Eric, 

 Also, I can not get it out of my head that there was 3 instances of kernel crashes on the same system within 1 hour, all of them in different areas of the kernel and all of them just after the ethernet driver printed a transmit timeout message, which would come out if it the network layer saw the transmit Q's stopped. It seems really unlikely that 3 separate root causes exist in such a scenario. Therefore I keep thinking whatever caused the transmit timeout, also caused kernel memory corruption, which then manifested in different ways, namely: crash in the corresponding ethernet driver due to NULL ptr access, this BUG_ON and another NULL ptr access in buffer.c for the 3rd crash. The way I can think of unifying all these is that possibly the QDISC bug caused memory corruption AND also triggered the transmit timeout as it messed up the Tx Q to the device. We know when that QDISC issue happened originally couple of years ago, the same BNX2 driver had a
 NULL ptr access in its SKB area, because of what I explained in my reply to Eric yesterday. So, we may have a pure coincidence here, but in the absence of reproducibility, core file to analyze, and based on reasons above, I really am interested in this QDISC problem. Eric, could you kindly respond to the email I sent yesterday, with the above background in mind. Regards to both of you. 





Hugh 
