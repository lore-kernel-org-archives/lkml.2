Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab1IPOI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 10:08:56 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:37124 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995Ab1IPOIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 10:08:55 -0400
Date: Fri, 16 Sep 2011 16:08:39 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, agk@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: request baset device mapper in Linux
Message-ID: <20110916140839.GE7428@ics.muni.cz>
References: <20110720082640.GZ7561@ics.muni.cz>
 <4E280964.6070000@ct.jp.nec.com>
 <20110721132627.GY7561@ics.muni.cz>
 <4E291F28.2040609@ct.jp.nec.com>
 <20110722081903.GB7561@ics.muni.cz>
 <4E2A7806.1060601@ce.jp.nec.com>
 <20110724221619.GM16487@ics.muni.cz>
 <4E367256.8020206@ct.jp.nec.com>
 <20110908132756.GT31717@ics.muni.cz>
 <CAMM=eLd9fToJ5Kh+vf4WG1ZN-qTc2CX98-+BUkFWWQQ=tCG7LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMM=eLd9fToJ5Kh+vf4WG1ZN-qTc2CX98-+BUkFWWQQ=tCG7LQ@mail.gmail.com>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Muni-Spam-TestIP: 147.251.17.147
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 16 Sep 2011 16:08:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 02:49:52PM -0400, Mike Snitzer wrote:
> Does "with your patch" mean against 3.0.3 or the original 2.6.32 kernel?
> 
> If you apply the patch to the 3.0.3 kernel do you regain the performance?

Unfortunately, the patch does not help with 3.0.3 kernel

top looks like this:
   63 root      20   0     0    0    0 S   38  0.0   0:16.65 kswapd1                                      
   18 root      20   0     0    0    0 R   32  0.0   0:14.38 kworker/4:0                                  
   19 root      20   0     0    0    0 R   30  0.0   0:20.88 ksoftirqd/4                                  
  153 root      20   0     0    0    0 R   29  0.0   0:14.46 kworker/4:2                                  
   62 root      20   0     0    0    0 S   22  0.0   0:09.44 kswapd0                                      
16726 root      20   0  9484 1628  588 D   11  0.0   0:03.94 dd                                           
16721 root      20   0  9484 1628  588 D   11  0.0   0:03.87 dd                                           
16723 root      20   0  9484 1624  588 D   11  0.0   0:04.02 dd                                           
16725 root      20   0  9484 1628  588 D   11  0.0   0:03.89 dd                                           
16727 root      20   0  9484 1628  588 D   11  0.0   0:03.91 dd                                           
16728 root      20   0  9484 1624  588 D   11  0.0   0:03.89 dd                                           
16729 root      20   0  9484 1624  588 D   11  0.0   0:03.89 dd                                           
16724 root      20   0  9484 1624  588 D   11  0.0   0:03.93 dd                                           
16674 root      20   0  9484 1624  588 R    6  0.0   0:01.99 dd                                           
16685 root      20   0  9484 1624  588 D    6  0.0   0:02.00 dd                                           
16654 root      20   0  9484 1628  588 D    5  0.0   0:01.55 dd                                           
16662 root      20   0  9484 1588  588 D    5  0.0   0:01.53 dd                                           
16665 root      20   0  9484 1628  588 D    5  0.0   0:01.57 dd 

with patched 2.6.32, it looks like:
17330 root      20   0  9432 1752  616 D    4  0.0   0:00.34 dd                                           
17335 root      20   0  9432 1756  616 D    4  0.0   0:00.35 dd                                           
17316 root      20   0  9432 1756  616 D    4  0.0   0:00.34 dd                                           
17318 root      20   0  9432 1756  616 D    4  0.0   0:00.34 dd                                           
17322 root      20   0  9432 1756  616 D    4  0.0   0:00.34 dd                                           
17323 root      20   0  9432 1756  616 D    4  0.0   0:00.33 dd                                           
17324 root      20   0  9432 1756  616 D    4  0.0   0:00.34 dd                                           
17325 root      20   0  9432 1756  616 D    4  0.0   0:00.34 dd                                           
17326 root      20   0  9432 1756  616 D    4  0.0   0:00.33 dd                                           
17327 root      20   0  9432 1756  616 D    4  0.0   0:00.34 dd                                           
17328 root      20   0  9432 1756  616 D    4  0.0   0:00.34 dd                                           
17329 root      20   0  9432 1756  616 D    4  0.0   0:00.34 dd                                           
17333 root      20   0  9432 1756  616 D    4  0.0   0:00.34 dd                                           
17336 root      20   0  9432 1756  616 D    4  0.0   0:00.35 dd                                           
17344 root      20   0  9432 1756  616 D    4  0.0   0:00.32 dd                                           
17317 root      20   0  9432 1756  616 D    4  0.0   0:00.33 dd                                           
17319 root      20   0  9432 1752  616 D    4  0.0   0:00.34 dd                                           
17320 root      20   0  9432 1756  616 D    4  0.0   0:00.33 dd                                           
17321 root      20   0  9432 1756  616 D    4  0.0   0:00.33 dd                                           
17331 root      20   0  9432 1756  616 R    4  0.0   0:00.33 dd                                           
17332 root      20   0  9432 1756  616 D    4  0.0   0:00.34 dd                                           
17334 root      20   0  9432 1756  616 D    4  0.0   0:00.34 dd 

unpatched 2.6.32 looks like:
    4 root      20   0     0    0    0 R  100  0.0   0:25.60 ksoftirqd/0                                  
19325 root      20   0  9432 1756  616 D   48  0.0   0:12.51 dd                                           
19294 root      20   0  9432 1756  616 D   11  0.0   0:01.09 dd                                           
19323 root      20   0  9432 1756  616 D    4  0.0   0:01.02 dd                                           
19295 root      20   0  9432 1756  616 D    2  0.0   0:02.73 dd                                           
19305 root      20   0  9432 1756  616 D    2  0.0   0:00.53 dd                                           
19327 root      20   0  9432 1760  616 D    2  0.0   0:00.65 dd                                           
19328 root      20   0  9432 1752  616 D    2  0.0   0:00.60 dd                                           
19336 root      20   0  9432 1752  616 D    2  0.0   0:00.49 dd                                           
19350 root      20   0  9432 1756  616 D    2  0.0   0:00.55 dd                                           
19366 root      20   0  9432 1752  616 D    2  0.0   0:00.50 dd                                           
19292 root      20   0  9432 1756  616 D    2  0.0   0:00.65 dd                                           
19300 root      20   0  9432 1756  616 D    2  0.0   0:00.51 dd                                           
19303 root      20   0  9432 1752  616 D    2  0.0   0:00.59 dd                                           
19307 root      20   0  9432 1756  616 D    2  0.0   0:00.71 dd                                           
19318 root      20   0  9432 1756  616 R    2  0.0   0:00.46 dd                                           
19321 root      20   0  9432 1756  616 D    2  0.0   0:00.47 dd                                           
19332 root      20   0  9432 1756  616 D    2  0.0   0:00.49 dd                                           
19334 root      20   0  9432 1760  616 D    2  0.0   0:00.49 dd                                           
19339 root      20   0  9432 1756  616 D    2  0.0   0:00.47 dd                                           
19348 root      20   0  9432 1756  616 D    2  0.0   0:00.48 dd                                           
19355 root      20   0  9432 1756  616 D    2  0.0   0:00.47 dd             

-- 
Luká¹ Hejtmánek
