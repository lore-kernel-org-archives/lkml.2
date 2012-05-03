Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab2ECGtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:49:07 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:21165
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934Ab2ECGtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:49:05 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz936eK1432Nzz1202hzz8275bhz2dh2a8h668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 3 May 2012 07:49:05 +0100
Subject: RE: [PATCH] IIO: industrialio-core: Use simple_open
Thread-Topic: [PATCH] IIO: industrialio-core: Use simple_open
Thread-Index: Ac0o0Ey/ZwBDBMwgSPqo406NWKlDrwAKID1g
Message-ID: <544AC56F16B56944AEC3BD4E3D5917714E79717075@LIMKCMBX1.ad.analog.com>
References: <1336009851.3590.4.camel@phoenix>
In-Reply-To: <1336009851.3590.4.camel@phoenix>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q436nRue025990

Axel Lin wrote on 2012-05-03:
> Use simple_open to replace iio_debugfs_open.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
> ---
>  drivers/iio/industrialio-core.c |   10 +---------
>  1 files changed, 1 insertions(+), 9 deletions(-)
> diff --git a/drivers/iio/industrialio-core.c
> b/drivers/iio/industrialio-core.c index 72e33b8..52aa44a 100644 ---
> a/drivers/iio/industrialio-core.c +++ b/drivers/iio/industrialio-core.c
> @@ -152,14 +152,6 @@ static void __exit iio_exit(void)
>  }
>
>  #if defined(CONFIG_DEBUG_FS)
> -static int iio_debugfs_open(struct inode *inode, struct file *file) -{
> -     if (inode->i_private) -         file->private_data = inode->i_private; -
> -     return 0; -} -
>  static ssize_t iio_debugfs_read_reg(struct file *file, char __user
>  *userbuf,                          size_t count, loff_t *ppos) {
> @@ -218,7 +210,7 @@ static ssize_t iio_debugfs_write_reg(struct file
> *file,
>  }
>
>  static const struct file_operations iio_debugfs_reg_fops = {
> -     .open = iio_debugfs_open,
> +     .open = simple_open,
>       .read = iio_debugfs_read_reg,
>       .write = iio_debugfs_write_reg,
>  };

Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin, Margaret Seif


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
