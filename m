Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab1DZIRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 04:17:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59451 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1DZIRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 04:17:01 -0400
Subject: Re: [PATCH 0/4] davinci-mcasp: fix tdm_slots and CBM/CFS
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        James Nuss <jamesnuss@nanometrics.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <cover.1303408522.git.bengardiner@nanometrics.ca>
References: <cover.1303408522.git.bengardiner@nanometrics.ca>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 09:16:56 +0100
Message-ID: <1303805816.3332.15.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 14:19 -0400, Ben Gardiner wrote:
> This patch series is comprised of three bugfixes and one cleanup that 
> were performed during prototyping of McASP operation in codec clock-
> master frame-slave mode.
> 
> First we noticed that the check of the number of tdm slots requested
> by platform data was always returning true -- unrelated to CMB/CFS
> mode.
> 
> Then a cleanup: the PDIR values set are currently based on magic 
> numbers and there are  available bitfield definitions. Not strictly
> needed but it makes the changes introduced in the last patch simpler
> to read.
> 
> It was found that the hardware parameters assigned when 
> codec clock-master frame-slave is requested were incorrect. This
> change is required for correct CBM/CFS operation.
> 
> Finally, the direction of the pins is corrected to reflect the
> implications of codec clock-master frame-slave -- i.e. mcasp clock-
> input frame-output. This change is also required for correct operation.
> 
> The combination was tested with a logic analyzer and the hrtimer pwm
> device from Bill Gatliff's PWM framework [1] on a da850evm with
> hardware modifications to access the McASP lines.
> 
> [1] http://article.gmane.org/gmane.linux.kernel.embedded/3486/
> 
> Ben Gardiner (4):
>   davinci-mcasp: correct tdm_slots limit
>   davinci-mcasp: use bitfield definitions for PDIR
>   davinci-mcasp: fix _CBM_CFS hw_params
>   davinci-mcasp: fix _CBM_CFS pin directions
> 
>  sound/soc/davinci/davinci-mcasp.c |   19 ++++++++++++-------
>  1 files changed, 12 insertions(+), 7 deletions(-)
> 

All

Acked-by: Liam Girdwood <lrg@ti.com>

