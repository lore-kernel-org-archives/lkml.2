Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab0KSTQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:16:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012Ab0KSTQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:16:53 -0500
Date: Fri, 19 Nov 2010 14:16:44 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Nicolas Kaiser <nikai@nikai.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/media: nuvoton: fix chip id probe
Message-ID: <20101119191644.GF5022@redhat.com>
References: <20101116211953.238012db@absol.kitzblitz>
 <20101116215408.GA17140@redhat.com>
 <4CE33527.8090800@infradead.org>
 <20101117113525.1ded029c@absol.kitzblitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117113525.1ded029c@absol.kitzblitz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 11:35:25AM +0100, Nicolas Kaiser wrote:
> Make sure we have a matching chip id high and one or the other
> of the chip id low values.
> Print the values if the probe fails.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
> Like this?
> Supersedes patch "drivers/media: nuvoton: always true expression".
> 
>  drivers/media/IR/nuvoton-cir.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/IR/nuvoton-cir.c b/drivers/media/IR/nuvoton-cir.c
> index 301be53..92d32c8 100644
> --- a/drivers/media/IR/nuvoton-cir.c
> +++ b/drivers/media/IR/nuvoton-cir.c
> @@ -249,9 +249,12 @@ static int nvt_hw_detect(struct nvt_dev *nvt)
>  	chip_minor = nvt_cr_read(nvt, CR_CHIP_ID_LO);
>  	nvt_dbg("%s: chip id: 0x%02x 0x%02x", chip_id, chip_major, chip_minor);
>  
> -	if (chip_major != CHIP_ID_HIGH &&
> -	    (chip_minor != CHIP_ID_LOW || chip_minor != CHIP_ID_LOW2))
> +	if (chip_major != CHIP_ID_HIGH ||
> +	    (chip_minor != CHIP_ID_LOW && chip_minor != CHIP_ID_LOW2)) {
> +		nvt_pr(KERN_ERR, "%s: chip id mismatch: 0x%02x 0x%02x",

I'd probably go with "unsupported chip, id: " instead, since it makes the
message a bit clearer, but generally speaking, yeah, something along
those lines should be fine.

-- 
Jarod Wilson
jarod@redhat.com

