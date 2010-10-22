Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760Ab0JVTQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:16:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49998 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759708Ab0JVTQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:16:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dma/coh901318: use simple_read_from_buffer
Date: Fri, 22 Oct 2010 21:16:31 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-next-20101021+; KDE/4.5.1; x86_64; ; )
Cc: Nicolas Kaiser <nikai@nikai.net>, Per Friden <per.friden@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
References: <20101022192953.1f67b10a@absol.kitzblitz> <201010221938.12591.arnd@arndb.de> <20101022203039.7b353056@absol.kitzblitz>
In-Reply-To: <20101022203039.7b353056@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010222116.32069.arnd@arndb.de>
X-Provags-ID: V02:K0:P5X/GX+lR3w/G/K676tAzLVGGhA6UVVgTsTbE5N5Gzn
 UIRSdJ+S2cMKZFr7xGMAT2QrZfwaUawN/UdemgHUyF5LMn4cie
 mie7QOWU0YtELYr43sui0+O5gVJbijdFpiW4FhnffQHDAvsRzK
 alJRQfy2vo6CFIn7XQb3uBeeuJmwQkU2sRRiAYVENX2XIbiAVv
 EGx9ZRXroxzx+haXdcemg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 October 2010 20:30:39 Nicolas Kaiser wrote:
> * Arnd Bergmann <arnd@arndb.de>:
> > On Friday 22 October 2010 19:29:53 Nicolas Kaiser wrote:
> > > If copy_to_user fails, the assigned error code instantly gets
> > > overwritten, and the failure apparently ignored. Moreover,
> > > shouldn't the error code be -EFAULT instead of -EINVAL?
> > 
> > Looks good, but it would be even better to just use
> > simple_read_from_buffer in this function, which takes care of
> > a lot the other complexities as well.
> 
> Like this? (Sorry, untested.)
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>

Yes, exactly. For stable kernels, your smaller fix is probably good
enough though and it's obviously correct.

	Arnd
