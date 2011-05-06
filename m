Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437Ab1EFRJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 13:09:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55698 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab1EFRJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 13:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=o369ZElF0AYwJyV1k5UXWUwZrpJ6AeMu0c9NE8UkuuPoQ3APhdqlh2hNCrTAxxzXYR
         G4eBFcRgY+fZ6lFJszDtOPZWbchh4LKw+sCHf4iEp+P8oezf/UohljSaEGAlOtWKeJlq
         7qJPXmrE1a1vg5zgslbP18JWvpNqZM8vL61BY=
Subject: Re: [RFC] time: xtime_lock is held too long
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110506165913.GF11636@one.firstfloor.org>
References: <m2oc3jxgtt.fsf@firstfloor.org>
	 <1304564090.2943.36.camel@work-vm>
	 <1304574244.32152.666.camel@edumazet-laptop>
	 <1304576495.2943.40.camel@work-vm>
	 <1304604284.3032.78.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1105051630390.3005@ionos>
	 <1304608095.3032.95.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1105051750540.3005@ionos>
	 <20110505210118.GI2925@one.firstfloor.org>
	 <alpine.LFD.2.02.1105061117220.3005@ionos>
	 <20110506165913.GF11636@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 19:09:38 +0200
Message-ID: <1304701778.3066.165.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 06 mai 2011 à 18:59 +0200, Andi Kleen a écrit :
> On Fri, May 06, 2011 at 12:18:27PM +0200, Thomas Gleixner wrote:

> If that code path shows up in profiling. Only the timer interrupt
> did so far.
> 
> > That's the completely wrong aproach, really. If stuff takes too long,
> > then we need to tackle it at the root of the problem and not solve it
> > by sprinkling magic prefetches all over the place.
> 
> If you have a better way to make it faster please share it.
> 

Unless I am very mistaken, it cannot explain my original report of up to
24.000 instructions waiting in ktime_get()

BTW, how many consecutive prefetch() a cpu can 'store/execute' before
throwing away hints ?



