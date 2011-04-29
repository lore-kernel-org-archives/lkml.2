Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760800Ab1D2SKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:10:14 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49159 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760760Ab1D2SKL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:10:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=eGpeTk2zLyyRndKUx20SrUrFOBqlE3N2KbhnxYb0YsMVH+ZaRNd7fxELaeEdm2Oxws
         AXSNvKMXolELO8yrkBXRzu2Qe/e9IGLn1FEg1veLpeYL3/R6Ag+7pQZJbTrly2YApz8H
         IXJ+g3i9CRX8Jl8CGyz+N5JjWOW7viuglufHc=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1104282353140.3005@ionos>
References: <20110426112756.GF4308@linux.vnet.ibm.com> <20110426183859.6ff6279b@neptune.home>
 <20110426190918.01660ccf@neptune.home> <BANLkTikjuqWP+PAsObJH4EAOyzgr2RbYNA@mail.gmail.com>
 <alpine.LFD.2.02.1104262314110.3323@ionos> <20110427081501.5ba28155@pluto.restena.lu>
 <20110427204139.1b0ea23b@neptune.home> <alpine.LFD.2.02.1104272351290.3323@ionos>
 <alpine.LFD.2.02.1104281051090.19095@ionos> <BANLkTinB5S7q88dch78i-h28jDHx5dvfQw@mail.gmail.com>
 <20110428102609.GJ2135@linux.vnet.ibm.com> <1303997401.7819.5.camel@marge.simson.net>
 <BANLkTik4+PAGHF-9KREYk8y+KDQLDAp2Mg@mail.gmail.com> <alpine.LFD.2.02.1104282044120.3005@ionos>
 <20110428222301.0b745a0a@neptune.home> <alpine.LFD.2.02.1104282227340.3005@ionos>
 <20110428224444.43107883@neptune.home> <alpine.LFD.2.02.1104282251080.3005@ionos>
 <1304027480.2971.121.camel@work-vm> <alpine.LFD.2.02.1104282353140.3005@ionos>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 29 Apr 2011 14:09:50 -0400
Message-ID: <BANLkTinr9J5OQoia-+yH3_hjU6AciAxu9A@mail.gmail.com>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>,
        =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        sedat.dilek@gmail.com, Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 18:02, Thomas Gleixner wrote:
> -static int hrtimer_clock_to_base_table[MAX_CLOCKS];
> +static int hrtimer_clock_to_base_table[MAX_CLOCKS] = {
> +       [CLOCK_REALTIME] = HRTIMER_BASE_REALTIME,
> +       [CLOCK_MONOTONIC] = HRTIMER_BASE_MONOTONIC,
> +       [CLOCK_BOOTTIME] = HRTIMER_BASE_BOOTTIME,
> +};

this would let us constify the array too
-mike
