Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1DDTrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 15:47:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48465 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab1DDTrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 15:47:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aD2+t6MecH4l8/V02ZQAyXxrt3dv5aacPZ9oXy28GAjISGICPfa1qDEvV+9LNvG84n
         OwfwoovC07Wg83iuDGgP8y6ZhOhPAkbc62CiTMg84hgNN1pk2NuoCKPS21/BPXUN2fD2
         5ZjbwcxsCRcqkiGmLC75L5BqFahEBcdLm0nxE=
Subject: Re: [PATCH] posix-timers: RCU conversion
From: Eric Dumazet <eric.dumazet@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>, ben@iagu.net,
        Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <1301940501.2319.25.camel@work-vm>
References: <AANLkTikZZ4MXZjx_+6u-vKVSgxULQo2BkQKRO6K_vzFy@mail.gmail.com>
	 <20110318123031.GB6066@8bytes.org>
	 <AANLkTin2k1ZSLa0NG6pKBvHYnKEV21t8pEqzeJWNn_rR@mail.gmail.com>
	 <4D871F6C.40207@redhat.com>
	 <AANLkTintxnKRQ4rD4Wo8_MHU4yJVzYaRhR=GjnDMGwNj@mail.gmail.com>
	 <AANLkTin8ZoUAVR2ajoV6cBFiUSe_Dof0_k60dcAGW3r-@mail.gmail.com>
	 <4D875842.9050308@redhat.com>
	 <AANLkTikWQS281kTtJ32-qo5U+w_BAak7qUwVhUQgOxxv@mail.gmail.com>
	 <4D8773AA.8030408@redhat.com>
	 <AANLkTin3Si1EAa=Va6f45vW-tYQ1Yk8dETXpHJHHHkxe@mail.gmail.com>
	 <1300726498.2884.493.camel@edumazet-laptop> <4D8784A9.8040303@redhat.com>
	 <1300727545.2884.513.camel@edumazet-laptop>
	 <AANLkTinn7OKKKvBYe7KWsrReuYDdma5+8gHJHXdCacDY@mail.gmail.com>
	 <1300746429.2837.20.camel@edumazet-laptop>
	 <1300777760.2837.38.camel@edumazet-laptop>
	 <1301849660.2837.211.camel@edumazet-laptop>
	 <1301940501.2319.25.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 21:47:16 +0200
Message-ID: <1301946437.3021.7.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 04 avril 2011 à 11:08 -0700, john stultz a écrit :
> On Sun, 2011-04-03 at 18:54 +0200, Eric Dumazet wrote:
> > Andrew, I submitted this patch some time ago and got no feedback from
> > Thomas, John, Richard or Paul.
> 
> Sorry about that. Its been on my list.
> 
> It looks ok to me, but I not very familiar with idr locking rules
> (though looking at the code the comments state that idr_find can be
> safely called the way you do here).

Not only comments, but ipc uses rcu locking as well ;)

Nadia Derbey did the work on idr and ipc in commits :

983bfb7db303cfde56ae5bbf4e0f2f46e38c9576
(ipc: call idr_find() without locking in ipc_lock())

f9c46d6ea5ce138a886c3a0f10a46130afab75f5
(idr: make idr_find rcu-safe)



