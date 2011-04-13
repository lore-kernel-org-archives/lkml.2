Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab1DMCcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 22:32:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40225 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab1DMCcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 22:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UZGH4a8GbUBgO6bkzBAaBw7cBfFNe/kTGnUcc7Rs/njGX+xUoQkJEDI74CHbGg3AcO
         CTdkS3HhyRbMJKwr7oG6tAAFiuFJ4aTHP4byJOewIdW8qpGG/x9ZTNO0Dy9Gs0UhtR1S
         71VW8P0RxqOsWMTYpneK+ZX4Ur8sEcu6V/VrU=
Subject: Re: [PATCH 3/4]percpu_counter: fix code for 32bit systems
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "tj@kernel.org" <tj@kernel.org>
In-Reply-To: <1302656465.3981.133.camel@sli10-conroe>
References: <1302595444.3981.129.camel@sli10-conroe>
	 <1302599035.3233.27.camel@edumazet-laptop>
	 <1302656465.3981.133.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 04:32:07 +0200
Message-ID: <1302661927.2811.18.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 13 avril 2011 à 09:01 +0800, Shaohua Li a écrit :
> On Tue, 2011-04-12 at 17:03 +0800, Eric Dumazet wrote:
> > 
> > Hmm... did you test this with LOCKDEP on ?
> > 
> > You add a possible deadlock here.
> > 
> > Hint : Some percpu_counter are used from irq context.
> there are some places we didn't disable interrupt, for example
> percpu_counter_add. So the API isn't irq safe to me.
> 

So what ? Callers must disable IRQ before calling percpu_counter_add(),
and they actually do in network stack. Please check again,
tcp_sockets_allocated for example.

> > This interface assumes caller take the appropriate locking.
> no comments say this, and some places we don't hold locking.
> for example, meminfo_proc_show.
> 

This doesnt answer my question about LOCKDEP ;)

Just fix the few callers that might need a fix, since this is the only
way to deal with potential problems without adding performance penalty
(for stable trees)



