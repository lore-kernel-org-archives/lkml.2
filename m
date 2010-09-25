Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab0IYK2F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 06:28:05 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:33673 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab0IYK2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 06:28:04 -0400
Date: Sat, 25 Sep 2010 12:28:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tracey Dent <tdent48227@gmail.com>
Cc: greg@kroah.com, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/22] Staging: cx25821: Makefile:cleaned up
	makefile cflag lines
Message-ID: <20100925102801.GA3450@merkur.ravnborg.org>
References: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285370890-8984-1-git-send-email-tdent48227@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 07:27:49PM -0400, Tracey Dent wrote:
> changed to use proper ccflags-y option
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/staging/cx25821/Makefile |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/cx25821/Makefile b/drivers/staging/cx25821/Makefile
> index d0eb16e..2f1c73e 100644
> --- a/drivers/staging/cx25821/Makefile
> +++ b/drivers/staging/cx25821/Makefile
> @@ -7,7 +7,7 @@ cx25821-objs   := cx25821-core.o cx25821-cards.o cx25821-i2c.o \
>  obj-$(CONFIG_VIDEO_CX25821) += cx25821.o
>  obj-$(CONFIG_VIDEO_CX25821_ALSA) += cx25821-alsa.o
>  
> -EXTRA_CFLAGS += -Idrivers/media/video
> -EXTRA_CFLAGS += -Idrivers/media/common/tuners
> -EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
> -EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
> +ccflags-y := -Idrivers/media/video
> +ccflags-y := -Idrivers/media/common/tuners
> +ccflags-y := -Idrivers/media/dvb/dvb-core
> +ccflags-y := -Idrivers/media/dvb/frontends

This is wrong.

First you assign "ccflags-y" the value -Idrivers/media/video
And in next line you assign it a new value - loosing the old value.

It should lok like this:
> +ccflags-y := -Idrivers/media/video
> +ccflags-y += -Idrivers/media/common/tuners
> +ccflags-y += -Idrivers/media/dvb/dvb-core
> +ccflags-y += -Idrivers/media/dvb/frontends

In this way you append to the variable.

You said in another mil that it builds.
This tells me that either some of the assignments are not needes - or you just loose
something that you are not aware of.

Please go through all your patches and fix it up - I saw the above
bug in the two patches I looked at.

	Sam
