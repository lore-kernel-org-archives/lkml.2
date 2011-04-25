Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab1DYVhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 17:37:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121Ab1DYVhW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 17:37:22 -0400
MIME-Version: 1.0
In-Reply-To: <20110425231016.34b4293e@neptune.home>
References: <20110424235928.71af51e0@neptune.home> <20110425114429.266A.A69D9226@jp.fujitsu.com>
 <BANLkTinVQtLbmBknBZeY=7w7AOyQk61Pew@mail.gmail.com> <20110425111705.786ef0c5@neptune.home>
 <BANLkTi=d0UHrYXyTK0CBZYCSK-ax8+wuWQ@mail.gmail.com> <20110425180450.1ede0845@neptune.home>
 <BANLkTikSLA59tdgRL4B=cr5tvP2NbzZ=KA@mail.gmail.com> <20110425190032.7904c95d@neptune.home>
 <BANLkTi=hQ=HcPLCdbb1pSi+xJByMTah-gw@mail.gmail.com> <20110425203606.4e78246c@neptune.home>
 <20110425191607.GL2468@linux.vnet.ibm.com> <20110425231016.34b4293e@neptune.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 25 Apr 2011 14:30:02 -0700
Message-ID: <BANLkTin7wSGi1=E2c2u6Jb5TG_KUpYh=Dw@mail.gmail.com>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: paulmck@linux.vnet.ibm.com, Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/25 Bruno Prémont <bonbons@linux-vserver.org>:
>
> Between 1-slabinfo and 2-slabinfo some values increased (a lot) while a few
> ones did decrease. Don't know which ones are RCU-affected and which ones are
> not.

It really sounds as if the tiny-rcu kthread somehow just stops
handling callbacks. The ones that keep increasing do seem to be all
rcu-free'd (but I didn't really check).

The thing is shown as running:

root         6  0.0  0.0      0     0 ?        R    22:14   0:00  \_
[rcu_kthread]

but nothing seems to happen and the CPU time hasn't increased at all.

I dunno. Makes no  sense to me, but yeah, I'm definitely blaming
tiny-rcu. Paul, any ideas?

                          Linus
