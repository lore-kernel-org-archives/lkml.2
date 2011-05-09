Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab1EIKUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 06:20:19 -0400
Received: from nm20.bullet.mail.ird.yahoo.com ([77.238.189.77]:30579 "HELO
	nm20.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751217Ab1EIKUR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 06:20:17 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 325686.52120.bm@omp1003.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Ov+rpzfWMjAau6+FiYbYRLiVLC0TI9C/kHXcShy1PZuX+ZMo6ez4m3nJUZ5iAQIYUsAZBOVLjkBeY14IFMdQDNTRMwF1v2jmWkgQL3mKz6vCYhQLk/TA5V3/IrZo2sdCdhPAH03dFEniWnPzKyme54eoUVhr05BYThWMxPSXpIk=;
Message-ID: <185596.62393.qm@web29004.mail.ird.yahoo.com>
X-YMail-OSG: 9X3sldAVM1nDEusC3r4oMK3ONUrtvaINFRzcZ7lrLQ9itW8
 nrfmOxuIwq4W3M5SJZatBfJt6N8AwDZRRQI1rkak_8mvozmed1WdbPJ8Tqrk
 7wxR5ORlogDr.uoVOUiJarp.qeepcLzQImvMuQ1Xv5x_E36KMf2GT_yot4Au
 s9UC4QdwQsRoOqv02Cfk05x8Gkd_DlJ5uxLsKxyLu3NANP6r0W6mkwKzWnnZ
 OLQvPPLsp9kCUlIYNQS9wxOA8p3vzEUjc1rvGxC6aDUKUnf30XCPrgtHhgni
 9M_9PqE9fRJbqpGThNNhPR4TxiSKKcyy0.8Kwfs5E2ZSDBw4AOzZUVYQ50g-
 -
X-Mailer: YahooMailClassic/12.0.2 YahooMailWebService/0.8.110.299900
Date: Mon, 9 May 2011 11:20:16 +0100 (BST)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: Re: [PATCH 06/19] mfd: Pass htc-pasic3 led platform data through the cell platform_data
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Philipp Zabel <philipp.zabel@gmail.com>
In-Reply-To: <1304901131-7104-7-git-send-email-sameo@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

I presume an earlier post called "mfd: Remove mfd_data" provided the patch for struct mfd_cell. If so would you please forward it to the list since I have no visibility of the change. Perhaps linux-kernel bounced the original post?

Regards,
Paul

--- On Mon, 9/5/11, Samuel Ortiz <sameo@linux.intel.com> wrote:

> diff --git a/drivers/mfd/htc-pasic3.c
> b/drivers/mfd/htc-pasic3.c
> index 95a4ff4..2808bd1 100644
> --- a/drivers/mfd/htc-pasic3.c
> +++ b/drivers/mfd/htc-pasic3.c
> @@ -173,6 +173,8 @@ static int __init pasic3_probe(struct
> platform_device *pdev)
>      }
>  
>      if (pdata &&
> pdata->led_pdata) {
> +       
> led_cell.platform_data = pdata->led_pdata;
> +        led_cell.pdata_size
> = sizeof(struct pasic3_leds_machinfo);
>          ret =
> mfd_add_devices(&pdev->dev, pdev->id,
> &led_cell, 1, r, 0);
>          if (ret < 0)
>             
> dev_warn(dev, "failed to register LED device\n");
