Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab0EHAJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 20:09:53 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:49634 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab0EHAJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 20:09:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=c77QSE66tjhXOWGCj7x8qV/zkYVYC54XDwHa+pE3FFP5+X1/uUD8uqjav0mzn/WbdZ
         UbyM6yMHwLJ5HmSwgs7XBc2bf02LshgG3lmjGaGli/nY+R7DhPwnmBDOnFsNyJwJlT3c
         9JnDW7GsrpzYWuVUNKlK8kQDWbPJYO7GnDUEE=
MIME-Version: 1.0
In-Reply-To: <1272964935-10756-1-git-send-email-jassi.brar@samsung.com>
References: <1272964935-10756-1-git-send-email-jassi.brar@samsung.com>
Date: Fri, 7 May 2010 17:09:51 -0700
X-Google-Sender-Auth: d0722c43eb01002c
Message-ID: <x2te9c3a7c21005071709v6fc7941eyacf50a9e42c9defd@mail.gmail.com>
Subject: Re: [PATCH] DMA ENGINE: Do not reset 'private' of channel
From: Dan Williams <dan.j.williams@intel.com>
To: Jassi Brar <jassi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, maciej.sosnowski@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 4, 2010 at 2:22 AM, Jassi Brar <jassi.brar@samsung.com> wrote:
> The member 'private' of 'struct dma_chan' is meant for passing
> data between client and the controller driver.
>
> The DMA client driver may point it to platform specific stuff after
> acquiring the channel. So, it is the responsiblity of the same code
> to reset it, if it must.
>
> The DMA engine doesn't set it and hence, shouldn't reset it either.
>
> Signed-off-by: Jassi Brar <jassi.brar@samsung.com>
>
> This reseting of private by DMA Engine comes in the way of implementing
> default channel settings during DMAC probe. That capability is useful
> for not having the clients to always provide platform specific data,
> like Rx/Tx FIFO addresses, which usually doesn't change across channel
> requests.
>

Ok I like this explanation better than the changelog you have above
because it clarifies that the driver is setting a default that the
client can override at registration time, but when this is happening
dmaengine should get out of the way.

Applied.

Thanks,
Dan
