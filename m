Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab1EPHoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 03:44:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43837 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab1EPHoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 03:44:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=M80aTNUWEifmoBG3jwnWvecQilm9cvYt2WR1Uta77gkMz7E07Y3RGpdE9boGhgZfHI
         oVYwiA3dC6WZe5OI3QnUZv/EHX1WuuU3fsUngU4RKURsq0A2Svlny5h+cMzRQEcSF3ce
         xR1Vw7GGdn+KGNeehMdW1jMyDTx6IAxy624TU=
Subject: Re: [patch V3] percpu_counter: scalability works
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <1305530143.2375.42.camel@sli10-conroe>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
	 <20110511092848.GE1661@htj.dyndns.org>
	 <1305168493.2373.15.camel@sli10-conroe>
	 <20110512082159.GB1030@htj.dyndns.org>
	 <1305190520.2373.18.camel@sli10-conroe>
	 <20110512085922.GD1030@htj.dyndns.org>
	 <1305190936.3795.1.camel@edumazet-laptop>
	 <20110512090534.GE1030@htj.dyndns.org>
	 <1305261477.2373.45.camel@sli10-conroe>
	 <1305264007.2831.14.camel@edumazet-laptop>
	 <20110513052859.GA11088@sli10-conroe.sh.intel.com>
	 <1305268456.2831.38.camel@edumazet-laptop>
	 <1305298300.3866.22.camel@edumazet-laptop>
	 <1305301151.3866.39.camel@edumazet-laptop>
	 <1305304532.3866.54.camel@edumazet-laptop>
	 <1305305190.3866.57.camel@edumazet-laptop>
	 <1305324187.3120.30.camel@edumazet-laptop>
	 <1305507517.2375.10.camel@sli10-conroe>
	 <1305526296.3120.204.camel@edumazet-laptop>
	 <1305527828.2375.28.camel@sli10-conroe>
	 <1305528912.3120.213.camel@edumazet-laptop>
	 <1305530143.2375.42.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 09:44:37 +0200
Message-ID: <1305531877.3120.230.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 16 mai 2011 à 15:15 +0800, Shaohua Li a écrit :

> I can, but you can't prevent me to optimize percpu_counter.
> 

Well, I have the right to say you're wrong.

Your last patch is not good, sorry. Please take the time to read it
again and fix obvious problems. And also give us numbers if one process
does the mmap()/munmap() loop, before and after your patch.

A percpu_counter is already a beast as is, you're suggesting to double
its size, for a pathological case.

Its absolutely not clear to me why vm_committed_as is using the default
percpu_counter_batch. 

By the way could you make sure percpu_counter_batch has the right value
on your 24 cpus machine ?

Your 128Mbyte mmap threshold sounds like percpu_counter_batch=32 instead
of 48



