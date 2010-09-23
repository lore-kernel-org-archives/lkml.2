Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab0IWUYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:24:43 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57646 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab0IWUYm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:24:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uqie8Hj+EG6jQSpqO/5C2rhn1XwqYkTjbeGZReQxJMoH06YlU4eLDrSyvYnwd8THjZ
         RgSjEoASX2yQL6HPs0MKmokyD9uyM889qw3biAQz1uO+HVkXu/iCS3W3L8uTBsig/pof
         1ObeLJtVRGg+P/EZPp0TEyS3ilc0QZy0ci84I=
MIME-Version: 1.0
In-Reply-To: <1284113586-25808-1-git-send-email-linus.walleij@stericsson.com>
References: <1284113586-25808-1-git-send-email-linus.walleij@stericsson.com>
Date: Thu, 23 Sep 2010 13:24:40 -0700
X-Google-Sender-Auth: zASiBM3njZU78tfxemZF_DuhIn8
Message-ID: <AANLkTinOOwZrT3Tu0zTr4hXr=OHiFCbXaCxu3872VZsA@mail.gmail.com>
Subject: Re: [PATCH] DMAENGINE: make sure we can always define platform data
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 3:13 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> If you try to compile platform data structs for the PL08X without
> it being compiled in, symbol resoltion will fail on the filter
> function when linking the kernel, so provide a dummy function.
>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
> Dan, this goes on top of the other stuff queued on top of the
> PL08X driver merged for next. Feel free to squash this too if
> you prefer.
> ---
>  include/linux/amba/pl08x.h |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/amba/pl08x.h b/include/linux/amba/pl08x.h
> index 8435f4a..daee6d0 100644
> --- a/include/linux/amba/pl08x.h
> +++ b/include/linux/amba/pl08x.h
> @@ -179,6 +179,13 @@ struct pl08x_platform_data {
>        void (*put_signal)(struct pl08x_dma_chan *);
>  };
>
> +#ifdef CONFIG_AMBA_PL08X
>  bool pl08x_filter_id(struct dma_chan *chan, void *chan_id);
> +#else
> +static bool pl08x_filter_id(struct dma_chan *chan, void *chan_id)

Missing "inline"?

You can include this when you respin the driver for the prep vs submit rework.

--
Dan
