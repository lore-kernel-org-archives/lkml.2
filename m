Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab0G1H2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 03:28:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63366 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab0G1H2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 03:28:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=kiBNZhhfkZqg1Z/Z1INsNF7ZDVGcFfVK+Da//VkbnGVnaO8B3+e4TGwPQjBQ4PfvpF
         GMGAPlR5kDR5j7oyRbKbMmdPCYFC1GwKm1R4NyBAa4u/jzF7KJy4BjYmT5rQWjDaNsCP
         JV9N3+QCiB1Nd2bAXP5/WG/UtWvc2bKfboW+A=
MIME-Version: 1.0
In-Reply-To: <1279906072-377-1-git-send-email-linus.walleij@stericsson.com>
References: <1279906072-377-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 28 Jul 2010 00:28:03 -0700
X-Google-Sender-Auth: -nlQO26X6ytRv_2YSq552Kq130I
Message-ID: <AANLkTikiV7+qvy8rG0nFqFoYxYqmwBswZK76abqj5DVb@mail.gmail.com>
Subject: Re: [PATCH] DMAENGINE: generic slave channel control v3
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 10:27 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> This adds an interface to the DMAengine to make it possible to
> reconfigure a slave channel at runtime. We add a few foreseen
> config parameters to the passed struct, with a void * pointer
> for custom per-device or per-platform runtime slave data.
>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>

Ok, let's go with this version, but one question before I apply it:

What are the rules for when a new dma_slave_config can be set?
Looking at the driver implementations it seems there is nothing
preventing a concurrent call to device_control to occur at "wrong
time"?  Is there a synchronization context I'm missing?

--
Dan
