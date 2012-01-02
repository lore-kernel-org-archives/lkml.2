Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab2ABUqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 15:46:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48304 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2ABUqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 15:46:11 -0500
Message-ID: <4F0217D6.2070705@gmail.com>
Date: Tue, 03 Jan 2012 07:47:18 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
CC: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        joe@perches.com, valdis.kletnieks@vt.edu, jj@chaosbits.net
Subject: Re: [PATCH 5/6] Staging: comedi: fix line over 80 character issue
 in daqboard2000.c
References: <1325509801-20036-1-git-send-email-ravishankar.km@greenturtles.in> <1325509801-20036-5-git-send-email-ravishankar.km@greenturtles.in>
In-Reply-To: <1325509801-20036-5-git-send-email-ravishankar.km@greenturtles.in>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/12 00:10, Ravishankar karkala Mallikarjunayya wrote:
> This is a patch to the daqboard2000.c file that fixes up a
> line over 80 character warning found by the checkpatch.pl tool.
>
> Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
> ---
>  drivers/staging/comedi/drivers/daqboard2000.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
> index e61c6a8..3550c6a 100644
> --- a/drivers/staging/comedi/drivers/daqboard2000.c
> +++ b/drivers/staging/comedi/drivers/daqboard2000.c
> @@ -414,7 +414,7 @@ static int daqboard2000_ai_insn_read(struct comedi_device *dev,
>  
>  	/* If pacer clock is not set to some high value (> 10 us), we
>  	   risk multiple samples to be put into the result FIFO. */
> -	fpga->acqPacerClockDivLow = 1000000;	/* 1 second, should be long enough */
> +	/* 1 second, should be long enough */

You broke the driver here.

>  	fpga->acqPacerClockDivHigh = 0;
>  
>  	gain = CR_RANGE(insn->chanspec);
> @@ -526,7 +526,8 @@ static void daqboard2000_pulseProgPin(struct comedi_device *dev)
>  	writel(DAQBOARD2000_SECRProgPinHi, devpriv->plx + 0x6c);
>  	udelay(10000);
>  	writel(DAQBOARD2000_SECRProgPinLo, devpriv->plx + 0x6c);
> -	udelay(10000);		/* Not in the original code, but I like symmetry... */
> +	/* Not in the original code, but I like symmetry... */
> +	udelay(10000);
>  }
>  
>  static int daqboard2000_pollCPLD(struct comedi_device *dev, int mask)

