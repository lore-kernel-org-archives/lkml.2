Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063Ab0HEJ2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 05:28:16 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44964 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab0HEJ2O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 05:28:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OQe1K8foXD7WJy/lyOeBy1aMKteJx9x+VzBIm72TWqU0shg1cJ9DjIekhb66NEyzPW
         fpWTCAFHr62DuFYhTjnr9pKhcerq1xhbUEmDl74Wob1cN1A0sYaqUh7fdUIUfpXpGTPL
         grL1phJXHkwDKW/Jn/4nPWet53eadZynlk+BI=
MIME-Version: 1.0
In-Reply-To: <1277811391-17966-1-git-send-email-linus.walleij@stericsson.com>
References: <1277811391-17966-1-git-send-email-linus.walleij@stericsson.com>
Date: Thu, 5 Aug 2010 14:58:12 +0530
Message-ID: <AANLkTikFULpLdqOF9q2vpxiQKb__zzDRGGoYR1qE=zwA@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMAENGINE: driver for the ARM PL080/PL081 PrimeCells
From: viresh kumar <viresh.linux@gmail.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        yuanyabin1978@sina.com, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Peter Pearse <peter.pearse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 5:06 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> This creates a DMAengine driver for the ARM PL080/PL081 PrimeCells
> based on the implementation earlier submitted by Peter Pearse.
> This is working like a charm for memcpy and slave DMA to the PL011
> PrimeCell on the PB11MPCore.
>
> This DMA controller is used in mostly unmodified form in the ARM
> RealView and Versatile platforms, in the ST-Ericsson Nomadik, and
> in the ST SPEAr platform.
>
> It has been converted to use the header from the Samsung PL080
> derivate instead of its own defintions. The Samsungs have a custom
> driver in their mach-* folders though, atleast we can share the
> register definitions.
>
> Cc: Peter Pearse <peter.pearse@arm.com>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Alessandro Rubini <rubini@unipv.it>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
> Changes since last revision: this has now been successfully tested
> with PL011 UART on the PB11MPCore.
>
> It now uses the generic runtime slave control and not the PrimeCell
> extensions, and thus depends only on that patch set. With the previous
> patch to the header file this is cleanly separated from the ARM tree
> and any PrimeCell drivers and can go into the async_tx tree as it is
> without further dependencies.
> ---
>  drivers/dma/Kconfig        |    8 +
>  drivers/dma/Makefile       |    1 +
>  drivers/dma/amba-pl08x.c   | 2027 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/amba/pl08x.h |  183 ++++
>  4 files changed, 2219 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/dma/amba-pl08x.c
>  create mode 100644 include/linux/amba/pl08x.h
>

Acked-by: Viresh Kumar <viresh.kumar@st.com>

regards,
viresh.
