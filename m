Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab0IWSbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 14:31:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35545 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab0IWSbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 14:31:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kpXO1v8bU+0aHMZz+8b/huCnMAWysy90zodC1vHkwkRjIHiRumj2CH6Veg13qj93CD
         tki6ZvmwzsMOUHu+4rpKtSFsVhoJgijzmecK+ISWLlQnjXTwEitVnKev6r/b902lfkBj
         TYHEaQ6QbhkR+nZkf0tiRydnRtfjp5coa/3WM=
MIME-Version: 1.0
In-Reply-To: <20100907204510.GA27909@ovro.caltech.edu>
References: <20100907204510.GA27909@ovro.caltech.edu>
Date: Thu, 23 Sep 2010 11:31:11 -0700
X-Google-Sender-Auth: 9Yhx2sIwv-iLzbhqp1j9CWhEX4I
Message-ID: <AANLkTikxy=fQo-rNj39Uv553C+wRzxhPWcGn9pX0jnfo@mail.gmail.com>
Subject: Re: [PATCH] fsldma: move DMA_SLAVE support functions to the driver
From: Dan Williams <dan.j.williams@intel.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 7, 2010 at 1:45 PM, Ira W. Snyder <iws@ovro.caltech.edu> wrote:
> The DMA_SLAVE support functions all existed as static inlines in the
> driver specific header arch/powerpc/include/asm/fsldma.h. Move the body
> of the functions to the driver itself, and EXPORT_SYMBOL_GPL() them.
>
> At the same time, add the missing linux/list.h header.
>
> Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
> ---
>
> Hello AKPM, Dan,

Hi, I'm back from paternity leave.

>
> At AKPM's request, I moved these static inline'd functions into the driver
> code itself, and then EXPORT_SYMBOL_GPL()'d them. I also added a gfp
> parameter to the fsl_dma_slave_alloc() function. And included the
> linux/list.h header.
>
> If you'd like three separate patches, I can do that. The changes were so
> trivial that I lumped all of them into a single patch.
>
> Thanks,
> Ira
>
>  arch/powerpc/include/asm/fsldma.h |   70 +++------------------------------
>  drivers/dma/fsldma.c              |   77 +++++++++++++++++++++++++++++++++++++

Remind me why we need this header file and these routines again?  git
grep says nothing in-tree is using these?

I also do not want to proliferate driver specific interfaces.  It
defeats the purpose of having a common dmaengine structure.  Along
these lines Linus W. added the new device_control() method (first
added in commit c3635c78, later tweaked in 05827630).  Could that be
massaged for your needs?

--
Dan
