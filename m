Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab1EEGui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 02:50:38 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65422 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab1EEGuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 02:50:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uquna0ORZwpIMypft7PTDOSkgyMYTMB5ElPnk1DZCihIY1ENcwng9MJ92TsLZcKnwQ
         yl4fYO/CL68sEx7yjQcGZg3q5iBPDWAQIyyu+9ujRSJq8rGTLr3tZdysQ9s4zSW57iRw
         5oBN7nAx8agrnrd/ZLza25XsdbjYrwhYY+tJk=
Subject: Re: [PATCH] time: Add locking to xtime access in get_seconds()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1304576495.2943.40.camel@work-vm>
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org>
	 <m2oc3jxgtt.fsf@firstfloor.org>  <1304564090.2943.36.camel@work-vm>
	 <1304574244.32152.666.camel@edumazet-laptop>
	 <1304576495.2943.40.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 08:50:31 +0200
Message-ID: <1304578231.32152.781.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 04 mai 2011 à 23:21 -0700, john stultz a écrit :

> Would a comment to the effect of "ensure processors don't re-order calls
> to get_seconds" help, or is it still too opaque (or even still
> nonsense?).
> 

Where is corresponding smp_wmb() ? It's not obvious, so you must add a
comment to help reader of this code.



