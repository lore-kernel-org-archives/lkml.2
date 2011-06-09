Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab1FIS6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 14:58:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35015 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab1FIS61 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 14:58:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FL9Wc1Qh/gewFHc3V+EzUTICHTBmlbVDpyWGVXIPOyOete/sgct1v9udzqGnNH+qMM
         E2U659xkvYRjIvkog58N0JuAbGUisBHqNUsG5yddgeh/g030n2FjYVH+NN+NEHuIgYff
         0m8VhQWHgl4nJmJwgZ2xY2CwnItxm8U4ocbwQ=
MIME-Version: 1.0
In-Reply-To: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2DED@dbde02.ent.ti.com>
References: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2DED@dbde02.ent.ti.com>
Date: Fri, 10 Jun 2011 00:28:25 +0530
Message-ID: <BANLkTikvURS7aQEBax0xEfcFZMg3-cUPow@mail.gmail.com>
Subject: Re: [RFC] dmaengine: add new api for preparing simple slave transfer
From: Jassi Brar <jassisinghbrar@gmail.com>
To: "Raju, Sundaram" <sundaram@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 6:09 PM, Raju, Sundaram <sundaram@ti.com> wrote:

> Generic buffer description:
> A generic buffer can be split into number of frames which contain number of chunks inside them. The frames need not be contiguous, nor do the chunks inside a frame.
>
>        -------------------------------------------------------------------
>        | Chunk 0 |ICG| Chunk 1 |ICG| ... |ICG| Chunk n |       Frame 0
>        -------------------------------------------------------------------
>        |                       Inter Frame Gap                     |
>        -------------------------------------------------------------------
>        | Chunk 0 |ICG| Chunk 1 |ICG| ... |ICG| Chunk n |       Frame 1
>        -------------------------------------------------------------------
>        |                       Inter Frame Gap                     |
>        -------------------------------------------------------------------
>        |                               ........                                    |
>        -------------------------------------------------------------------
>        |                       Inter Frame Gap                     |
>        -------------------------------------------------------------------
>        | Chunk 0 |ICG| Chunk 1 |ICG| ... |ICG| Chunk n |       Frame m
>        -------------------------------------------------------------------

IIUC the above figure, the work done by DMA controller remains the
same, either by
passing this as a transfer of the new type or as a normal sg-list  - unless
the DMAC driver attempts to reorder the transfers or the DMAC h/w
natively supports
some form of sg-list.
For DMACs, that have no special support, different representation
wouldn't make a
difference.
And if the DMAC does support the kind of fancy scatter-gather, it
should be possible for
the dma api driver to analyze the submitted 'normal' sg-list and
program the transfers at one go.
Besides, it should be possible to have a 'template' sequence of
requests prepared
already because usually, for above mentioned scenario, the parameters
don't change across
items in a list.
