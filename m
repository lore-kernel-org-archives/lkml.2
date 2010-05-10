Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542Ab0EJXp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:45:58 -0400
Received: from n5-vm0.bullet.mail.gq1.yahoo.com ([67.195.8.62]:43223 "HELO
	n5-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932337Ab0EJXpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 19:45:50 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 837352.12748.bm@omp120.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=nKyRvuq0rCENStD9weycOIATFRt79Dq2yhyPZ8WqjWUd3G45bYc+nqH0SR27BE7LajOfraG3i2ts09Iv2GkCc6JG8+d5jh9euvmvlw6K/qBT/3eIJqrUx61unjCU34sblj0TWLaMwIdm1V2Xkr6VnJJ9+9R4ko3zXwqF9jDtY6Y=;
Message-ID: <689426.33806.qm@web112505.mail.gq1.yahoo.com>
X-YMail-OSG: _GRx3OMVM1l0h3_28OrKvFSL.eYeWV24mgIAeMYlITwfRtJ
 7d0xHhZ7O89ZT7D7sxZ504ExD_JZcCojo8Ffl758cLD_3hs2bBRwExX7ihpp
 wAeMEea0A6aLclkPMLf81vg.iL2U2pEcIBvdwM_Pm_Ti2E2ppuEERoQsY2iJ
 zk_nQJFQIBPvZvDP6riytkOxqO9gySxHudNvBhvsfJuAxglqYxj6Xk6lOYhw
 Wjo.m.VeSJd8iY1QG1Optb0paHl1weKM-
X-Mailer: YahooMailClassic/11.0.8 YahooMailWebService/0.8.103.269680
Date: Mon, 10 May 2010 16:45:48 -0700 (PDT)
From: Sharat Masetty <sharat_masetty@yahoo.com>
Subject: Question about more headroom in skb in outgoing packets 
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

For my project I need 3 words of headroom in the skb in the network driver level, to add a  custom header to the ethernet/ip packets. I looked into the tcp code and figured out tcp uses sk->sk_prot->max_header for header allocation size. But I was not able to confirm that all other transport protocol use the same mechanism(?) For example in UDP/ICMP I was not able to figure out from the code where the skb allocation and header reservation happens(Any light here would be really helpful.). Is there a parameter I can tune to allocate 3 words for any outgoing skb's, or what is the best way to do it?

I want to figure out a good way(may be tune some parameters) to allocate extra 3 words for any skbuff independent of the transport protocol being used. I have also looked at an API in skbuff skb_pad() which does what I want(add either headroom or tailroom), but I want to avoid that for performance reasons(skb_pad does kmalloc and memcpy).  Any light here would be very much appreciated.

Thanks,
Sharat.




      

