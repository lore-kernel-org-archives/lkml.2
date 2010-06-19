Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab0FSGV5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 02:21:57 -0400
Received: from n1-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.153]:34404 "HELO
	n1-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753195Ab0FSGV4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 02:21:56 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 488883.24277.bm@omp119.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=mfqm/D5rHW9wjLzWrSrqDPXSMrMwN78lqZ2HrIy0+UhNXmNP4Idjg1BWxMrF/nq4K+IBy8RnmpFCa9/ztr697p/6XubturxIJxjHiWqihx430uNadfXpgWyjCRhjAhVc9BvSO2F7le0oMDC9aRNwaMl8cf/0UyAl0FSH2NCie6U=;
Message-ID: <386783.17931.qm@web180310.mail.gq1.yahoo.com>
X-YMail-OSG: Zt7Nho0VM1lSS_uNq1Z1erxlqP4fwsA.clSAjQ2hH_u2jD6
 kaQjN_Rb2zTpKNzJw3HLZNU1kX36dZtR5DDpp7ht1DPkazqCJHpRtNwUK8.o
 LZh3zc9V01WJniatK69eF3t6aFO0H2ER28yjQAGcvFSq0ARNbYk_M.zOAMH6
 K9InI1SkLS1bmLtJ_vq00PjCQf9GGNFxxiijwQUlkniu4XM.OoUo8U2RMWsL
 p20bNx_7RrZaEFAE57GWlZf9Oj6fBrtaQD8R0Dxu.t_rGedshANGWuw0OKW3
 NN.J6yaX0RgBNquq37w--
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.103.269680
Date: Fri, 18 Jun 2010 23:21:55 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: gpiolib and sleeping gpios
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       ext-jani.1.nikula@nokia.com
In-Reply-To: <4C1BECC9.7000805@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> The runtime warnings will only show instances where the
> non-sleeping
> versions where called instead of the sleeping versions.

... *AND* the GPIO requires the cansleep() version...

Right; such calls are errors.  We issue
warnings since fault returns are inapplicable. 

> There is no
> warning to say that we are calling the spinlock safe
> version, where it is possible to sleep.

The call context isn't what controls whether
gpio_get_value() or gpio_get_value_cansleep()
is appropriate ... it's the GPIO itself, and
how its implementation works.

"possible to sleep" is a GPIO attribute,
exposed by a predicate.  If spinlock-safe
calls are used on GPIOs with that attribute,
 a warning *IS* issued.




> 
> The point I was trying to make is that there are lots of
> drivers which
> will not work with gpios on sleeping io expanders because
> they call the
> spinlock safe gpio calls.

And they will trigger runtime warnings, and
thus eventually get fixed.  The way to do that
is to check if the GPIO needs the cansleep()
call


That's the first category above:  the driver
should have used the cansleep() variant, and
sotriggers a runtime warning.



