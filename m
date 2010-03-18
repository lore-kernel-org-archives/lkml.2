Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab0CRUpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 16:45:19 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:47610 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab0CRUpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 16:45:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WzhjKcmppojSq5t/lGt6qmYMpQZTWEg1kKSvtwf5MVzqF8qn9tYrghqDv++qZFcOYw
         Vh0CAOH72ssGT/6VwvLOKvc6ssb7SPS13gVVFheQx+MgHD1187Lk1yJDKKNNg+AaODya
         flrFNmAfRLmvFVNgctELOnoYoPdAq2+jA/2AM=
Subject: Re: [PATCH] softlockup: stop spurious softlockup messages due to
 overflow
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Colin Ian King <colin.king@canonical.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20100318152535.GB12564@elte.hu>
References: <1268661673-21638-1-git-send-email-colin.king@canonical.com>
	 <1268663388.3154.30.camel@edumazet-laptop> <20100316101251.GM7961@elte.hu>
	 <1268918537.1894.143.camel@lenovo>  <20100318152535.GB12564@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 21:45:10 +0100
Message-ID: <1268945110.2894.162.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 18 mars 2010 à 16:25 +0100, Ingo Molnar a écrit :
> * Colin Ian King <colin.king@canonical.com> wrote:
> 
> > 
> > Using time_after/before:
> > 
> > diff --git a/kernel/softlockup.c b/kernel/softlockup.c
> > index 0d4c789..4b493f6 100644
> > --- a/kernel/softlockup.c
> > +++ b/kernel/softlockup.c
> > @@ -155,11 +155,11 @@ void softlockup_tick(void)
> >          * Wake up the high-prio watchdog task twice per
> >          * threshold timespan.
> >          */
> > -       if (now > touch_ts + softlockup_thresh/2)
> > +       if (time_after(now - softlockup_thresh/2, touch_ts))
> >                 wake_up_process(per_cpu(softlockup_watchdog, this_cpu));
> >  
> >         /* Warn about unreasonable delays: */
> > -       if (now <= (touch_ts + softlockup_thresh))
> > +       if (time_before_eq(now - softlockup_thresh, touch_ts))
> >                 return;
> 
> Ok, that looks like the most readable variant, agreed?
> 

Sure ! Colin please submit formally your patch :)

Thanks


