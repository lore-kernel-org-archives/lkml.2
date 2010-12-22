Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab0LVN1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:27:32 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38237 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab0LVN1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:27:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GPKoWRpSanSyVbukyn0B5SMqorPdlYLvrRyh1nGdKaciV5s5Y9LQfQLCDDWhWStGmM
         4p5ESS48eDvjsuJUVbl8dywwVjYqypL2ZwGjOnXkXFvW8Zr3h5mKTqDpxn463CcsuuWo
         cetIo3kiZe5PkbxjdQn0qCs238zIYixNJmAJA=
MIME-Version: 1.0
In-Reply-To: <20101206122236.GC30654@intel.com>
References: <20101206122236.GC30654@intel.com>
Date: Wed, 22 Dec 2010 14:26:39 +0100
Message-ID: <AANLkTinO7cgJgR0w=9dF0uSFFMh_ybb0bNXffXiCxy8p@mail.gmail.com>
Subject: Re: [PATCH v2 2/3]mmc: enable runtime PM support of sdhci host controller
From: Pierre Tardy <tardyp@gmail.com>
To: Yunpeng Gao <yunpeng.gao@intel.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +int sdhci_runtime_suspend(struct sdhci_host *host)
> +{
> +       int ret = 0;
> +
> +       if (host->vmmc)
> +               ret = regulator_disable(host->vmmc);
Please dont suspend the card's power in the sdhci's suspend function.
This means the card will die.
Think of the wifi idle use case where the wifi is working, but sdio
bus is not used. sdhci will suspend, but wifi card wont.
manipulation of the host->vmmc must be done in set_ios() (I will send
the patch later in the week...)

Regards,
-- 
Pierre
