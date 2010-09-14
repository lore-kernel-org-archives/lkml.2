Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab0INUFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:05:49 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:52268 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab0INUFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:05:48 -0400
X-SpamScore: -15
X-BigFish: VS-15(zz1432N98dNef8Kzz1202hzzz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
Date: Tue, 14 Sep 2010 15:05:39 -0500
From: Scott Wood <scottwood@freescale.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, kumar.gala@freescale.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        amit.shah@redhat.com, Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH] hvc_console: fix dropping of characters when output
 byte channel is full
Message-ID: <20100914150539.45c0672e@schlenkerla.am.freescale.net>
In-Reply-To: <20100914204410.71942cdc@lxorguk.ukuu.org.uk>
References: <1282329921-24394-1-git-send-email-timur@freescale.com>
	<20100914121721.c8671ed8.akpm@linux-foundation.org>
	<20100914204410.71942cdc@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Sep 2010 20:05:40.0538 (UTC) FILETIME=[348019A0:01CB5448]
X-Reverse-DNS: az33egw01.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010 20:44:10 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Yes, hvc_push() reschedules.  It doesn't sit in a tight loop burning
> > electrons!
> > 
> > Can we do something safer&smarter here?
> 
> 
> Its a printk handler - better to lose the bytes than hang the box. I
> think the current code is probably right.

Losing the bytes is unacceptable.  Even if an hvc backend erroneously
returns zero on a permanent error, the timeout should prevent hanging
the box for too long.

Though I suspect the right answer for us may be "don't use the hvc
layer".

-Scott

