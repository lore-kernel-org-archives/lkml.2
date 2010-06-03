Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609Ab0FCKLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:11:13 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:54518 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758949Ab0FCKLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:11:11 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 3/4] Add scripts/coccinelle/kzalloc-simple.cocci
Date: Thu, 3 Jun 2010 12:11:04 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>, Roland Dreier <rdreier@cisco.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk,
       Wolfram Sang <w.sang@pengutronix.de>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
References: <1273508667-5152-1-git-send-email-npalix@diku.dk> <1273508667-5152-4-git-send-email-npalix@diku.dk> <4C077B2F.8010204@suse.cz>
In-Reply-To: <4C077B2F.8010204@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201006031211.05118.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 June 2010 11:51:43 Michal Marek wrote:
> On 10.5.2010 18:24, Nicolas Palix wrote:
> > +@script:python depends on org@
> > +p << r.p;
> > +x << r.x;
> > +@@
> > +
> > +msg="%s" % (x)
> > +msg_safe=msg.replace("[","@(").replace("]",")")
> > +coccilib.org.print_todo(p[0], msg_safe)
> > +
> > +@script:python depends on report@
> > +p << r.p;
> > +x << r.x;
> > +@@
> > +
> > +msg="WARNING: kzalloc should be used for %s, instead of kmalloc/memset" % (x)
> > +coccilib.report.print_report(p[0], msg_safe)
> 
> msg_safe is not defined in this scriptlet, I'm only getting
> 
> Traceback (most recent call last):
>   File "<string>", line 5, in <module>
> NameError: name 'msg_safe' is not defined

Oops. Thank you for reporting this.

I fixed it for my upcoming submission.

In the meantime, you can replace "msg_safe" by "msg" in the rule
dedicated to the "report" mode.

That is

coccilib.report.print_report(p[0], msg_safe)

by 

coccilib.report.print_report(p[0], msg

The good point is that you only reach this point if Coccinelle has found
something to change in the code. So there is some patches to do... ;)


> 
> Michal
> 

-- 
Nicolas Palix
Tel: (+33) 1 44 27 87 25
Tel: (+33) 6 81 07 91 72
Web: http://www.diku.dk/~npalix/
