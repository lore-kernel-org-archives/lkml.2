Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1EYGfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 02:35:37 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:49896 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1EYGfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 02:35:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TEKLeqD+r/CXF/RXFBjqHgLpzyrlkjdMaYYncqQIiCZd759IJch5GFQmf3PsahLYpC
         reVH9Og5BPRkBzNuNaOPGRIUkB5iUYVmhLl9udRkHeDnyYiBk6fxZIS48Mzc9f7iiUSy
         EHhmUOaveendKx15/FoRLEee5omVSm2QVloaY=
Subject: Re: Kernel crash after using new Intel NIC (igb)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, StuStaNet Vorstand <vorstand@stusta.mhn.de>
In-Reply-To: <20110525060609.GA32244@dev1756.snc6.facebook.com>
References: <201104250033.03401.maxi@daemonizer.de>
	 <1303878240.2699.41.camel@edumazet-laptop>
	 <1303878771.2699.44.camel@edumazet-laptop>
	 <201104271352.00601.maxi@daemonizer.de>
	 <20110512211033.GA3468@dev1756.snc6.facebook.com>
	 <1305234953.2831.2.camel@edumazet-laptop>
	 <20110524213327.GA3917@dev1756.snc6.facebook.com>
	 <1306291469.3305.11.camel@edumazet-laptop>
	 <20110525060609.GA32244@dev1756.snc6.facebook.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 May 2011 08:35:31 +0200
Message-ID: <1306305331.3305.22.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 24 mai 2011 à 23:06 -0700, Arun Sharma a écrit :
> On Wed, May 25, 2011 at 04:44:29AM +0200, Eric Dumazet wrote:
> > 
> > Hmm, thanks for the report. Are you running x86 or another arch ?
> > 
> 
> This was on x86.
> 
> > We probably need some sort of memory barrier.
> > 
> > However, locking this central lock makes the thing too slow, I'll try to
> > use an atomic_inc_return on p->refcnt instead. (and then lock
> > unused_peers.lock if we got a 0->1 transition)
> 
> Another possibility is to do the list_empty() check twice. Once without
> taking the lock and again with the spinlock held.
> 

Why ?

list_del_init(&p->unused); (done under lock of course) is safe, you can
call it twice, no problem.

No, the real problem is the  (!list_empty(&p->unused) test : It seems to
not always tell the truth if not done under lock.



