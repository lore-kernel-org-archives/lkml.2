Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967Ab0JHR14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:27:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33506 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758941Ab0JHR1z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:27:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UWip0sttKKEotSlt9KXGhN5YDevALAdOWSoMJVqta3RLFlw3jBQapsFuH32wVbuKYu
         Jnjc4c8p4JDCtwwUabKNKUaxsyCp6kwfJNuZYHRH/utH5OE6sJvhL4O/LRPrY9VzghvW
         zUcS/1aumxiaQVvK85wAV/g5KJhE2OEr5QOz8=
MIME-Version: 1.0
In-Reply-To: <1286188723-6341-1-git-send-email-vinod.koul@intel.com>
References: <1286188723-6341-1-git-send-email-vinod.koul@intel.com>
Date: Fri, 8 Oct 2010 10:27:53 -0700
X-Google-Sender-Auth: xvI1GjNsdXyuiJpRfvZ0KUwt5HM
Message-ID: <AANLkTi=8dV1EaAsT-Gkjkb-UY9R10r8LFQxMK3xQOwDw@mail.gmail.com>
Subject: Re: [PATCH 6/6] intel_mid_dma: change the slave interface
From: Dan Williams <dan.j.williams@intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, ramesh.b.k.v@intel.com,
        yong.y.wang@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 4, 2010 at 3:38 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> In 2.6.36 kernel, dma slave control command was introduced,
> this patch changes the intel-mid-dma driver to this
> new kernel slave interface
>
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> ---
[..]
> +static int dma_slave_control(struct dma_chan *chan, unsigned long arg)
> +{
> +       struct intel_mid_dma_chan       *midc = to_intel_mid_dma_chan(chan);
> +       struct dma_slave_config  *slave = (struct dma_slave_config *)arg;
> +       struct intel_mid_dma_slave *mid_slave;
> +
> +       BUG_ON(!midc);
> +       BUG_ON(!slave);
> +       pr_debug("MDMA: slave control called\n");
> +
> +       mid_slave = to_intel_mid_dma_slave(slave);

I know this was the initial recommendation to support custom
extensions to dma_slave_config, but this isn't safe.  How does this
routine know that that 'slave' is embedded in an intel_mid_dma_slave
structure.  I applied it as is, but I think we need a better approach.

Maybe a per device alloc_dma_slave_config() such that ->dma_control()
can assume the driver allocated the dma_slave_config.  As it stands
nothing in the calling convention guarantees type safety.

--
Dan
