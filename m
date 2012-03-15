Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab2COKE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:04:27 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48059 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab2COKE0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:04:26 -0400
MIME-Version: 1.0
In-Reply-To: <CADTWAO+=Zu6EtzTxm3j50f29HATekCfXuwgGeK=m0Zrw5Ljjig@mail.gmail.com>
References: <CADTWAO+=Zu6EtzTxm3j50f29HATekCfXuwgGeK=m0Zrw5Ljjig@mail.gmail.com>
Date: Thu, 15 Mar 2012 19:04:25 +0900
Message-ID: <CADTWAOLcFnZThjvXNSO2uba2vDU4DG48gmQQsYL7GPPbO8rTpg@mail.gmail.com>
Subject: Re: [PATCH] mtd: fix section mismatch for doc_probe_device
From: Ryosuke Saito <raitosyo@gmail.com>
To: dwmw2@infradead.org
Cc: robert.jarzmik@free.fr, mikedunn@newsguy.com, ivan.djelic@parrot.com,
        artem.bityutskiy@linux.intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, please ignore it.
I will re-send a plain text message.

Best regards,
Ryosuke

On Thu, Mar 15, 2012 at 6:24 PM, Ryosuke Saito <raitosyo@gmail.com> wrote:
> doc_probe_device() is only called from docg3_probe() which is in .init.text,
> so it must be in the same section to avoid a section mismatch warning.
>
> Signed-off-by: Ryosuke Saito <raitosyo@gmail.com>
> ---
>  drivers/mtd/devices/docg3.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
> index 25f688c..db9a4b7 100644
> --- a/drivers/mtd/devices/docg3.c
> +++ b/drivers/mtd/devices/docg3.c
> @@ -1846,8 +1846,8 @@ static void __init doc_set_driver_info(int chip_id,
> struct mtd_info *mtd)
>   * if a memory allocation failed. If floor 0 is checked, a reset of the
> ASIC is
>   * launched.
>   */
> -static struct mtd_info *doc_probe_device(void __iomem *base, int floor,
> -  struct device *dev)
> +static struct mtd_info * __init
> +doc_probe_device(void __iomem *base, int floor, struct device *dev)
>  {
>   int ret, bbt_nbpages;
>   u16 chip_id, chip_id_inv;
