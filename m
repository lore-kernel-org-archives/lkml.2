Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760809Ab0HLTOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 15:14:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62392 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760332Ab0HLTOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 15:14:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=iuHWJsduk/F5kbaDbrRdSbxNnswaPplaRrEgHT91rzFVjoEDDEFh64gswmWHiDM4Cw
         tpACgPDV9smxebLD4xZvvO3UYWGel6suVuxzlg3SYW02Oh6nWt2z0+j4DxU74p94ZwsR
         /vcR12Q5mUxr+RdyCpX6oO+5ZA/ihbsmwALhs=
MIME-Version: 1.0
In-Reply-To: <20100812150030.GB27749@pengutronix.de>
References: <20100812150030.GB27749@pengutronix.de>
Date: Thu, 12 Aug 2010 12:14:20 -0700
X-Google-Sender-Auth: YSA4mc8hg0N9rkCqKxmxhTIKZn4
Message-ID: <AANLkTikSExz3ELLEZ90LgitTsxwkE1dxu1BM1VhfCOmy@mail.gmail.com>
Subject: Re: dmaengine questions
From: Dan Williams <dan.j.williams@intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.ml.walleij@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 8:00 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> Hi,
>
> I am currently looking into implementing the Freescale i.MX SDMA engine
> into the dmaengine API. The SDMA engine can handle sg transfers from/to
> devices. During implementation some questions came up.
>
> On the i.MX we already have a DMA engine which can do slave dma
> transfers, the IPU (drivers/dma/ipu/), which is exclusively used for
> image operations. My problem is that I found no way for the clients
> to select which DMA engine to use as both have the same capabilities
> (DMA_SLAVE).

Yes, if you need finer grained matching of channels, beyond simple
capability matching, this is the intended purpose of the
'dma_filter_fn' and 'filter_param' arguments to dma_request_channel.
Dmaengine will pass all available channels that match the base
capability to the filter function for further, usually architecture
specific, discrimination.

> For the SDMA engine the clients have to pass some platform specific data
> to the SDMA engine (dma request line, word width and the like). The
> current mechanism is to pass this data through the dma_chan->private
> field, which seems more like tunneling instead of passing the data as we
> lose type safety. Are there any ideas to improve this?

Hopefully dma_chan->private can eventually be phased out in favor of
Linus' dma_slave_config scheme [1].

--
Dan

[1]: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=c156d0a5
