Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab1EWO1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 10:27:21 -0400
Received: from nm11.bullet.mail.ird.yahoo.com ([77.238.189.64]:39117 "HELO
	nm11.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754352Ab1EWO1U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 10:27:20 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 787006.46624.bm@omp1019.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=CU8DfXy2uqBFp7dD17ads4kPC8dYS1UHt0iplwusU1eXKhHM2Iub1LLGmnNspi8a/V2+M/qfQDFH1KBCTgGCE6jREPrp3/l7lyNNBN0a58+fdM0NfyqK8GLyhM0Z/NhmoH4L+a0CrGpza+NtPdTxIJydhSLW/gWFwU2InSxZnN8=;
Message-ID: <680026.93151.qm@web29013.mail.ird.yahoo.com>
X-YMail-OSG: .reyWkkVM1npIg2wXG5TRUc3YtsSRMwo.ZrB_cJYSm30pYb
 nvkc1F4FpEmBrXL85UmsSqx6DEK3KklHe2bo5xTIUKV3UrQlU1_ht7lk1ea6
 hd6SUvAdUOnfl7DQ1VUFvXk8jfIZwdk3rCej.860MS5BNysRdnlBXSc5EAyR
 lY4_irS0UXCHCQbtLSOtzSyaCVuiDXE.rNzhsDVi1bCN4wgKAEwSl0gTSQT4
 immQsY4W7MMtz.6DJ5dAq8jiZVl28K4XyxFitTTna83kK.QQGIvWStI_p_dL
 c9HZTJippcDzZnE0UtHak8HhUqg5OiEpgNcFjj9xIJCm4Fmb0mIS532cx9w-
 -
X-Mailer: YahooMailClassic/14.0.1 YahooMailWebService/0.8.111.303096
Date: Mon, 23 May 2011 15:27:18 +0100 (BST)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: Re: [PATCH] mfd: Add ASIC3 PCMCIA/CF support
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, philipp.zabel@gmail.com, mad_soft@inbox.ru
In-Reply-To: <20110522221459.GQ18610@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

> Why is this driver linked to the pxa2 pcmcia driver ? Can't
> we make it just
> asic3 specific and enable it from the board asic3 platform
> data ?

This driver isn't the actual driver! This patch merely provides the platform_data for the asic3 pcmcia platform_device. This is then linked to the existing pxa2xx-pcmcia platform_driver, which is the actual driver.

In the case of pcmcia, the platform_data provides callbacks (struct pcmcia_low_level) rather than simple static data, and thus needs to reside in drivers/pcmcia where those callbacks are declared.

In the case of asic3, the pcmcia platform_device also needs to provide a parent link back to the asic3 platform_device because the callbacks need to access asic3 registers (in addition to GPIOs).

Thus either the pcmcia platform_data or the asic3 platform_device need to be made global if both are to be referenced by the pcmcia platform_device. I chose the former, simply because the pcmcia platform_device was already defined in arch/arm/mach-pxa/hx4700.c

Agreed this arrangement seems somewhat untidy. I am keen to hear if someone can improve upon it.

Paul
