Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab0HPSsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 14:48:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64269 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0HPSsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 14:48:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AzOZ+A+PTFoX+Qpk85smBI4VtadByDJoOH7Dn7+YTr5WJ5867iewdUvEKkNk7M0XKb
         GcBtfECCj365hYAq9RD5sM19+konYhbvDcS3wgq08QWBfZFVzZALXIAvXJdWExvzk6XO
         ctcrKkNz6pKFDByV6zwYUjCOUiVDiLgrsGMYc=
Subject: Re: [LOCKDEP BUG][2.6.36-rc1] xt_info_wrlock?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1281983814.1926.1763.camel@laptop>
References: <1281978469.3268.55.camel@gandalf.stny.rr.com>
	 <1281979893.2524.54.camel@edumazet-laptop>
	 <1281981301.3268.110.camel@gandalf.stny.rr.com>
	 <1281982566.3268.137.camel@gandalf.stny.rr.com>
	 <1281983814.1926.1763.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 20:48:48 +0200
Message-ID: <1281984528.2487.25.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 16 août 2010 à 20:36 +0200, Peter Zijlstra a écrit :
> On Mon, 2010-08-16 at 14:16 -0400, Steven Rostedt wrote:
> > @@ -729,8 +729,10 @@  static void get_counters(const struct
> > xt_table_info *t,
> >         local_bh_enable();
> >         /* Processing counters from other cpus, we can let bottom half
> > enabled,
> >          * (preemption is disabled)
> > +        * We must turn off lockdep to avoid a false positive.
> >          */
> >  
> > +       lockdep_off();
> >         for_each_possible_cpu(cpu) {
> > 
> nack!


Interesting.

Care to elaborate ?



