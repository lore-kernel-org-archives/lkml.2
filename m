Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab1BVUvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:51:10 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48408 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1BVUvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:51:09 -0500
MIME-Version: 1.0
In-Reply-To: <1298405266-1624-12-git-send-email-bigeasy@linutronix.de>
References: <1298405266-1624-1-git-send-email-bigeasy@linutronix.de> <1298405266-1624-12-git-send-email-bigeasy@linutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 22 Feb 2011 13:50:48 -0700
X-Google-Sender-Auth: FzdbXxptQmYt2CaKp6MBwYpUaqQ
Message-ID: <AANLkTimYJh8wU8vhN+MGysyjAn2pCaqL-mGE1Vjr5TYB@mail.gmail.com>
Subject: Re: [PATCH 11/11] rtc/cmos: add OF bindings
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 1:07 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> This allows to load the OF driver based informations from the device
> tree. Systems without BIOS may need to perform some initialization.
> PowerPC creates a PNP device from the OF information and performs this
> kind of initialization in their private PCI quirk. This looks more
> generic.
> This patch also avoids registering the platform RTC driver on X86 if we
> have a device tree blob. Without it we end up with of this devices. It
> is in this hunk in order to remain bisectable.
>
> Cc: rtc-linux@googlegroups.com
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>

Itty-bitty nit below, but otherwise:

Acked-by: Grant Likely <grant.likely@secretlab.ca>

[...]
> diff --git a/include/linux/of.h b/include/linux/of.h
> index d9dd664..8de7c29 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -70,6 +70,11 @@ extern struct device_node *allnodes;
>  extern struct device_node *of_chosen;
>  extern rwlock_t devtree_lock;
>
> +static inline int of_have_populated_dt(void)

Personally, I'd make this a 'bool' return value.

> +{
> +       return allnodes != NULL;
> +}
> +
>  static inline bool of_node_is_root(const struct device_node *node)
>  {
>        return node && (node->parent == NULL);
> @@ -222,5 +227,12 @@ extern void of_attach_node(struct device_node *);
>  extern void of_detach_node(struct device_node *);
>  #endif
>
> +#else
> +
> +static inline int of_have_populated_dt(void)
> +{
> +       return 0;

and then 'return false'; here.

But by *no means* should this patch be delayed by this comment.  :-)

g.
