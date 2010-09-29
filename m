Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab0I2VwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 17:52:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57049 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0I2VwR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 17:52:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bUyfQoirHuzZSlKFAd593Kz89ILgv0Q7dxqaP+CvQz2RJm/wQ+A7qraijCTGtiINDx
         nvUM4yBZdGKizb3/kc2HeJiU2x/klRLmIOqodwKulYb3W4r221Lli9fI6vn0F0Cg3Gbf
         ZsyFAjA4uYsRSBJoiOdzRh/sxxqScQkwUuy7U=
MIME-Version: 1.0
In-Reply-To: <1285628277-26894-4-git-send-email-iws@ovro.caltech.edu>
References: <1285628277-26894-1-git-send-email-iws@ovro.caltech.edu>
	<1285628277-26894-4-git-send-email-iws@ovro.caltech.edu>
Date: Wed, 29 Sep 2010 14:52:16 -0700
X-Google-Sender-Auth: nfMCVaxlh42YXDrW1rw_T22c3is
Message-ID: <AANLkTik4_se70GkKb2FLwsiUtQGyaHgxsLn3MQhmv5jh@mail.gmail.com>
Subject: Re: [PATCH 3/4] fsldma: remove DMA_SLAVE support
From: Dan Williams <dan.j.williams@intel.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 3:57 PM, Ira W. Snyder <iws@ovro.caltech.edu> wrote:
> Now that the generic DMAEngine API has support for scatterlist to
> scatterlist copying, this implementation of the DMA_SLAVE API is no
> longer necessary.
>
> In order to let device_control() continue to function, a stub
> device_prep_slave_sg() function is provided. This allows custom device
> configuration, such as enabling external control.
>

> +       case DMA_SLAVE_CONFIG:
> +
> +               cfg = (struct fsldma_slave_config *)arg;

Now that I actually see someone trying to use the recommended
extension model it comes across as unsafe, what guarantees that arg is
pointing to a fsldma_slave_config.  At at minimum you could ensure
that this channel has been claimed for private usage which loosely
implies that the client knows that it is talking to an fsldma channel.
 Even safer is to just assign you a one-off dma_ctrl_cmd
(FSLDMA_EXTERNAL_START) for this purpose.  Otherwise this and the
other patches look good.

--
Dan
