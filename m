Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782Ab2DAGQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 02:16:18 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38925 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab2DAGQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 02:16:16 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.20.112]
In-Reply-To: <CAJK669ZN8F6DCeHG_UEJNiCb=1ADCUGdy3EsMA=JC-Nj-Kb5Tg@mail.gmail.com>
References: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com>
 <201112091442.04294.arnd@arndb.de> <81C3A93C17462B4BBD7E272753C105792060B42C9C@EXDCVYMBSTM005.EQ1STM.local>
 <201203221657.09820.arnd@arndb.de> <81C3A93C17462B4BBD7E272753C105792060C098E4@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=WgbY+n_CESWCSiC5tAXTm+8CJVEd2TOa4H0-iVeeb1=3C9Q@mail.gmail.com>
 <81C3A93C17462B4BBD7E272753C105792060C09F1D@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=WgbaCysxO32y9zz0QuAdPysK2kU5p6SaQ4nFdcRyeWSyqhA@mail.gmail.com>
 <81C3A93C17462B4BBD7E272753C105792060C0A318@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=WgbYz7_syim+LoTM-6MLJ=_8tsEuDQ+=fwOTfzOriPrMAEw@mail.gmail.com> <CAJK669ZN8F6DCeHG_UEJNiCb=1ADCUGdy3EsMA=JC-Nj-Kb5Tg@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 1 Apr 2012 09:15:55 +0300
Message-ID: <CAK=WgbbxVhbw2fdPb=T5giKmu1Hb=CjvS0D1vaSG27Vr+33nNQ@mail.gmail.com>
Subject: Re: Using remoteproc with ST-Ericsson modem.
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Sun, Apr 1, 2012 at 12:25 AM, Sjur Brændeland <sjurbren@gmail.com> wrote:
> Good stuff. One question from top of my mind: Have you considered
> option of using rpmsg without the protocol, eg something like
> RPMSG_RAW, where I can take advantage of rpmsg transport features
> without needing the muxing feature. Then I could use CAIF muxing layer
> without the rpmsg protocol and naming services....?

I think you may already be able to do so: the naming services are only
enabled when VIRTIO_RPMSG_F_NS is present. About the rest of the rpmsg
protocol - I think you can largely ignore it. Rpmsg drivers shouldn't
really care about it, they just need to use the send/receive API and
everything would just work.

> Another option is using virtio_console, but I realise virtio_console is doing
> normal kmalloc so memory handling in virtio_console would have to change
> then. (I have a memory addressing issue, so modem cannot access all
> kernel memory).

What's the limitation you have? only a certain range of addresses is
visible to the modem?

OMAP4 has a related problem: the memory that virtio_console allocates
isn't immediately visible to the OMAP4's remote processors, because it
isn't mapped in the relevant IOMMU. To fix this, we may need
virtio_console to start allocating its memory with the DMA API (but
we'll only start discussing it when the IOMMU-based DMA API will be
merged). I guess that something along these lines would work out for
you too ?

Thanks,
Ohad.
