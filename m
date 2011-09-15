Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab1IOJyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 05:54:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35600 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755479Ab1IOJyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 05:54:31 -0400
Date: Thu, 15 Sep 2011 10:54:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: ASoC: uninitialized variable i used in wait_for_dc_servo
Message-ID: <20110915095427.GB7988@opensource.wolfsonmicro.com>
References: <1316055154.3496.6.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316055154.3496.6.camel@phoenix>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 10:52:34AM +0800, Axel Lin wrote:
> @@ -722,7 +723,7 @@ static void wait_for_dc_servo(struct snd_soc_codec *codec, u16 mask)
>  
>  		} else {
>  			msleep(1);
> -			if (--i) {
> +			if (--i == 0) {

You should avoid making random stylistic changes that aren't needed when
doing things like this.
