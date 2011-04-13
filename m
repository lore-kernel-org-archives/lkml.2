Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab1DMGyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 02:54:08 -0400
Received: from nm21.bullet.mail.bf1.yahoo.com ([98.139.212.180]:26226 "HELO
	nm21.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756020Ab1DMGyH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 02:54:07 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 650451.58657.bm@omp1005.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=KQ2itCJPJYoOtRL/IjYnnrhS+ij9lfHtXhyMOsca7G1BSsKiJiDLdEIPP1VJ4LZRKRrfbXVdDby1ApvEgYrRREXjOLlKwx/KWChNLLcERNOv+kjtc7nYpofEEVNaVcANOxPoGua3c2y7ZdpyNX1c+4f82BrU/eku/VSI6O13bi4=;
Message-ID: <530486.50523.qm@web162020.mail.bf1.yahoo.com>
X-YMail-OSG: L0fY.u8VM1ktPYxyYhe_tUIVCAFCLrnG5kTID4GOjcjEX1o
 2Aa3ujnXUyXx4nrh3Usn4Xt53OnGlALt2FIZTaIkw.x11xWvQkUQt9308Iwn
 stkFrzzhT65hMQ8UIHnQJRjl72vwPI7uXckz0XaVocjP_FFvCZPc2tQRmcXy
 KgdQ4YyanYSfL_fzDUm..1UT3lj3siO1Rfi1yjeqWGsEuzn2HR2U5qcDKkTV
 5M4qPvRJxbha5AA_FNq0Uenk3ywRgtS0PcO3v42zsf6dWFQJEjr78Nj3cSMF
 fltuZnzmzDjh_6AGecOM3EwJENchJ2QSd2m24Q9mt7Uh0hwFD1jH3oYYW5TI
 aeG_pI4ZDxTCcEd8WRkFsKvWktIdAIjAGm69EA0qFSo3v6Ma6mZaL8PU-
X-Mailer: YahooMailClassic/12.0.2 YahooMailWebService/0.8.109.295617
Date: Tue, 12 Apr 2011 23:54:05 -0700 (PDT)
From: Pintu Agarwal <pintu_agarwal@yahoo.com>
Subject: Regarding memory fragmentation using malloc....
To: Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc: Changli Gao <xiaosuo@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, azurIt <azurit@pobox.sk>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <1302662256.2811.27.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

I am trying to understand how memory fragmentation occurs in linux using many malloc calls.
I am trying to reproduce the page fragmentation problem in linux 2.6.29.x on a linux mobile(without Swap) using a small malloc(in loop) test program of BLOCK_SIZE (64*(4*K)).
And then monitoring the page changes in /proc/buddyinfo after each operation.
>From the output I can see that the page values under buddyinfo keeps changing. But I am not able to relate these changes with my malloc BLOCK_SIZE.
I mean with my BLOCK_SIZE of (2^6 x 4K ==> 2^6 PAGES) the 2^6 th block under /proc/buddyinfo should change. But this is not the actual behaviour.
Whatever is the blocksize, the buddyinfo changes only for 2^0 or 2^1 or 2^2 or 2^3.

I am trying to measure the level of fragmentation after each page allocation.
Can somebody explain me in detail, how actually /proc/buddyinfo changes after each allocation and deallocation.


Thanks,
Pintu



      
