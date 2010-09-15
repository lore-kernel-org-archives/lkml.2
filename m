Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab0IOV0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 17:26:47 -0400
Received: from web50108.mail.re2.yahoo.com ([206.190.38.36]:32775 "HELO
	web50108.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753331Ab0IOV0q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 17:26:46 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Sep 2010 17:26:46 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=M933uHDRcvTP7FrHBrqbnTHgxKBDCAaqM/pWoEZOJBSp7IaVAe3yRn7lJlUOorDQT/ZRjfZzjRyYZS7pHi+QzycjFMrAydK4axEGlivDT+bw6WXoryhHusQL7pMnV5b9VMV+wMNZN4af2NsXTXQjvlgi1qxIqHnIyStl7WXZfmw=;
Message-ID: <216309.52558.qm@web50108.mail.re2.yahoo.com>
X-YMail-OSG: NyKpwtQVM1mloVEl3iXtKTsOt2sKN4CSUmPqwMld.f93xJk
 NRFOxU8wRMKfRWF542l4UwLCWFz7XRdw.5VDuqub_FkdL1WuG5p25UfvilvJ
 BhnvCmLlVcr4TMN1jTuKAyy0z6ckjB59WtFpPHpQP1_9OWlnOB0gSe5FtLDk
 4L6_fW.2nQwclA.MEkrrdCOcU52OVvx04IVfgytsiiH8LFHINz8I7L1tAz_u
 zkEGRNkqdKf44.eE7n6xoWYTKa7lPsZWI1rXatcOgBqxGqMwlvjK31mL3srI
 7dpoRLJafr3oEr2ELdAj1PDifzjzcoSkwvLaR6OSlOLN5YfuaIsy3pD6VmW4
 -
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.105.279950
Date: Wed, 15 Sep 2010 14:20:05 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] i7core_edac: fix panic in udimm sysfs attributes registration
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-edac@vger.kernel.org
In-Reply-To: <20100914162602.GA6047@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Tue, 9/14/10, Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> Subject: [PATCH] i7core_edac: fix panic in udimm sysfs attributes registration
> To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
> Cc: "LKML" <linux-kernel@vger.kernel.org>, linux-edac@vger.kernel.org
> Date: Tuesday, September 14, 2010, 10:26 AM
> Array of udimm sysfs attributes was
> not ended with NULL marker.
> 
> EDAC DEBUG: edac_create_mci_instance_attributes:
> edac_create_mci_instance_attributes() file udimm0
> EDAC DEBUG: edac_create_mci_instance_attributes:
> edac_create_mci_instance_attributes() file udimm1
> EDAC DEBUG: edac_create_mci_instance_attributes:
> edac_create_mci_instance_attributes() file udimm2
> BUG: unable to handle kernel NULL pointer dereference at
> 00000000000001a4
> IP: [<ffffffff81330b36>]
> edac_create_mci_instance_attributes+0x148/0x1f1
> PGD 0
> Oops: 0000 [#1] PREEMPT SMP
> last sysfs file:
> CPU 3
> Modules linked in:
> 

> Kernel panic - not syncing: Attempted to kill init!
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: stable@kernel.org
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Doug Thompson <dougthompson@xmission.com>


> ---
>  drivers/edac/i7core_edac.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/edac/i7core_edac.c
> b/drivers/edac/i7core_edac.c
> index e0187d1..0fd5b85 100644
> --- a/drivers/edac/i7core_edac.c
> +++ b/drivers/edac/i7core_edac.c
> @@ -1140,6 +1140,7 @@ static struct mcidev_sysfs_attribute
> i7core_udimm_counters_attrs[] = {
>      ATTR_COUNTER(0),
>      ATTR_COUNTER(1),
>      ATTR_COUNTER(2),
> +    { .attr = { .name = NULL } }
>  };
>  
>  static struct mcidev_sysfs_group i7core_udimm_counters =
> {
> -- 
> 1.7.2.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
