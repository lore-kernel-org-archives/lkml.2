Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761168Ab2BJXgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:36:52 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59233 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761110Ab2BJXgu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 18:36:50 -0500
MIME-Version: 1.0
In-Reply-To: <20120210162134.GA2723@r65073-Latitude-D630>
References: <1328612075-5825-1-git-send-email-b32955@freescale.com>
	<1328612075-5825-2-git-send-email-b32955@freescale.com>
	<20120210162134.GA2723@r65073-Latitude-D630>
Date: Sat, 11 Feb 2012 07:36:50 +0800
Message-ID: <CAMiH66EP6UFDYkguzfSFgysDzVREPZ8P1x29TkYvQ+Cuvz-4hg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mxs-dma : move the mxs dma.h to a more common place
From: Huang Shijie <shijie8@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Huang Shijie <b32955@freescale.com>, vinod.koul@intel.com,
        artem.bityutskiy@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        LW@karo-electronics.de, alsa-devel@alsa-project.org,
        b29396@freescale.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

On Sat, Feb 11, 2012 at 12:21 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Tue, Feb 07, 2012 at 06:54:34PM +0800, Huang Shijie wrote:
>> Move the header to a more common place.
>> The mxs dma engine is not only used in mx23/mx28, but also used
>> in mx50/mx6q.  It will also be used in the future chips.
>>
>> Rename it to mxs-dma.h
>>
>> change mxs-dma driver, mxs-mmc driver, gpmi-nand driver, mxs-saif driver
>> to the new header file.
>>
>> Signed-off-by: Huang Shijie <b32955@freescale.com>
>> ---
>>  drivers/dma/mxs-dma.c                              |    2 +-
>>  drivers/mmc/host/mxs-mmc.c                         |    2 +-
>>  drivers/mtd/nand/gpmi-nand/gpmi-nand.h             |    2 +-
>>  .../include/mach/dma.h => include/linux/mxs-dma.h  |    0
>>  sound/soc/mxs/mxs-pcm.c                            |    2 +-
>>  sound/soc/mxs/mxs-pcm.h                            |    2 +-
>>  sound/soc/mxs/mxs-saif.c                           |    2 +-
>>  7 files changed, 6 insertions(+), 6 deletions(-)
>>  rename arch/arm/mach-mxs/include/mach/dma.h => include/linux/mxs-dma.h (100%)
>
> I suggested you rename it include/linux/fsl/mxs-dma.h [1].  It seems
> you are ignoring the comment.  Can you explain why it's not a
> reasonable suggestion?

For gpmi-nand.h is placed in include/linux/mtd/ directory, so i think
it's better to place the mxs-dma.h
to similar include/linux/dma/ directory, but the directory does not exit.

If i place it at include/linux/fsl/mxs-dma.h , i have to create a new
folder, I am not sure i have the right
to do so. But i can try it in the next version.

thanks a lot.



>
> And Wolfram and Mark told you that you need to Cc subsystem maintainers
> to collect their acks [2].  But you are still not Ccing Mark Brown and
> Chris Ball for sound/soc/ and drivers/mmc changes.  So you are not
> listening.

ok, i will CC them in next version.  I　really did not know to whom I　should cc .

BR
Huang Shijie

>
> Regards,
> Shawn
>
> [1] http://article.gmane.org/gmane.linux.kernel.mmc/12301
> [2] http://article.gmane.org/gmane.linux.alsa.devel/93751
