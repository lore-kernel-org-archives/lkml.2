Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab0FWMkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 08:40:55 -0400
Received: from n2-vm0.bullet.mail.gq1.yahoo.com ([67.195.23.154]:23003 "HELO
	n2-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751144Ab0FWMkx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 08:40:53 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 522797.24747.bm@omp205.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=308i5J7lIJoDdOWuGqLpI/IFJUhHUUpBH2hmfeulxtoASyKhdx08pAOnaIRz5nNJu3C2qR8hi/CJRl4RqSrdjRRzYg2pw5R+N8CnwS0e7uoPhT0oUz8C2PDR24xI/exuFgKIpz68JnHtNBJoTYVS+q6CC9BTxkuSUmTRoBsAwRU=;
Message-ID: <564390.64703.qm@web180307.mail.gq1.yahoo.com>
X-YMail-OSG: 1M9Ga6AVM1m96w97Ny6hiObPguDFxwX7JYWNaGyOsVc.UYk
 QqoskVdOuTbOQfVNJieIA4yhBrQUhlzluG4bi..BdMXbxdgfH9IRYUurgxTr
 xW.IbyJ7ILEcp9_mU30IJVLteLA52PCW10XFjXpiPzRqbIMWP.sjGYM.Veo6
 OqTWI_Nxfvq.GtpCvPY_XtPCmTh8M_aU1y.ZTnDyByueXwDs857PBW9ZFrGN
 FlpigNf7_u1JyosPKMDrNUm9r.XpfO0NTLmbULejTkEAslTvhxRJQzTUCqcs
 yvmwEUaDtszTpAH6q.qJyyTX9zmsyOjydj6ADSYH8lLLCbIRuAWs-
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.104.274457
Date: Wed, 23 Jun 2010 05:40:01 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: gpiolib and sleeping gpios
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       "gregkh@suse.de" <gregkh@suse.de>,
       =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <alpine.DEB.2.00.1006231435410.8344@wnav-qrfxgbc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Wed, 6/23/10, Jani Nikula <ext-jani.1.nikula@nokia.com> wrote:

> Hi David -
> 
> Part of the reason why such drivers haven't been fixed
> might be that the runtime warnings are only issued if DEBUG
> is defined in gpiolib.c:

A very good point.  those cansleep() warnings
should perhaps be issued more consistently.

(Other warnings are safer to skip.)

I think the normal case for the GPIO calls is
the spinlock-safe code path, so I'd probably
ack a patch which incurs the extra costs only
for gpio chips that are already sleeping.

(The desire to trim costs for bitbanging is
not going to affect gpio chips accesssed over
I2C or SPI ... ;)

- Dave


