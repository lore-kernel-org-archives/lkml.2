Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164Ab0LTXBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:01:34 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:53295 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758164Ab0LTXBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:01:32 -0500
Subject: Re: [PATCH v3] kptr_restrict for hiding kernel pointers
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, jmorris@namei.org,
        eric.dumazet@gmail.com, tgraf@infradead.org, eugeneteo@kernel.org,
        kees.cook@canonical.com, mingo@elte.hu, davem@davemloft.net,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org
In-Reply-To: <50259.1292883991@localhost>
References: <1292692835.10804.67.camel@dan>  <50259.1292883991@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 18:01:28 -0500
Message-ID: <1292886088.4061.3.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 17:26 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Sat, 18 Dec 2010 12:20:34 EST, Dan Rosenberg said:
> 
> > @@ -1035,6 +1038,26 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
> >  		return buf + vsnprintf(buf, end - buf,
> >  				       ((struct va_format *)ptr)->fmt,
> >  				       *(((struct va_format *)ptr)->va));
> > +	case 'K':
> > +		/*
> > +		 * %pK cannot be used in IRQ context because it tests
> > +		 * CAP_SYSLOG.
> > +		 */
> > +		if (in_irq() || in_serving_softirq() || in_nmi())
> > +			WARN_ONCE(1, "%%pK used in interrupt context.\n");
> 
> Should this then continue on and test CAP_SYSLOG anyhow, or should it
> return a "" or or "<invalid>" or something?

This is a valid point.  I'll resend a new version shortly that defaults
to zeroing pointers if it's used incorrectly without relying on
capability checks.

Thanks,
Dan

