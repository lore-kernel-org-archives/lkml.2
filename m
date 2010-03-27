Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab0C0Ic4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 04:32:56 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:37320 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab0C0Icy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 04:32:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ClUDgEkzKmh5QHI7astFSbMkCdfIdFlnGou2lSyI/CgJU+QaVTqo6d+AjVXKXJljqy
         /QLOj2Ckq9Ql07IH8b1yelvMkkhFV4OrFmBiFce/eyIkQjKlLQtPJUf7EC/hwkTLeikF
         8zJydi6ChH5F5A85C3ce2Lut6nvl65DTx9gLY=
MIME-Version: 1.0
In-Reply-To: <1269649039.23499.15.camel@dwillia2-linux>
References: <1269613211-12673-1-git-send-email-linus.walleij@stericsson.com>
	 <1269649039.23499.15.camel@dwillia2-linux>
Date: Sat, 27 Mar 2010 09:32:52 +0100
Message-ID: <63386a3d1003270132x48e1eaen9fa3fcb17b87aa85@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMAENGINE: generic channel status v2
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>, Pavel Machek <pavel@ucw.cz>,
       Li Yang <leoli@freescale.com>, Paul Mundt <lethal@linux-sh.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Magnus Damm <damm@opensource.se>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Joe Perches <joe@perches.com>, Roland Dreier <rdreier@cisco.com>,
       =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>,
       "Steven J. Magnani" <steve@digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/27 Dan Williams <dan.j.williams@intel.com>:

> Sidenote: one thing I notice via this exercise is that not every driver
> is triggering a descriptor cleanup in their device_tx_status()
> implementation.  It's really only needed for the drivers that will
> service requests from the async_tx api (now the minority), but something
> to keep in mind.  In some cases async_tx polls for completion on
> descriptor allocation failure, so either ->device_tx_status() or
> ->device_prep* needs to run descriptor reclaim.

Not that I designed this thing, but the idea of device_tx_status()
cleaning things up seems a bit kludgy, what about adding a new
control command to device_control() instead, like
DMA_CLEANUP_TX and require that you call this after a
polling async transfer has been found to be complete?

Is this thing supposed to be used for DMA hardware that cannot
trigger interrupts on completion by the way? That seems like the
natural reason...

Linus Walleij
