Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab1HOFQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:16:35 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55896 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab1HOFQd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:16:33 -0400
MIME-Version: 1.0
In-Reply-To: <1313384834-24433-8-git-send-email-lacombar@gmail.com>
References: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
	<1313384834-24433-8-git-send-email-lacombar@gmail.com>
Date: Mon, 15 Aug 2011 01:16:33 -0400
Message-ID: <CACqU3MULBWSfs6gJCP6OY1qZx2gYXy-JpmQZLNGUepcaSAHKAQ@mail.gmail.com>
Subject: Re: [PATCH 07/11] drivers/pps: do not use EXTRA_CFLAGS
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Rodolfo Giometti <giometti@enneenne.com>, linuxpps@ml.enneenne.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 1:07 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Usage of these flags has been deprecated for nearly 4 years by:
>
>    commit f77bf01425b11947eeb3b5b54685212c302741b8
>    Author: Sam Ravnborg <sam@neptun.(none)>
>    Date:   Mon Oct 15 22:25:06 2007 +0200
>
>        kbuild: introduce ccflags-y, asflags-y and ldflags-y
>
> Moreover, these flags (at least EXTRA_CFLAGS) have been documented for command
> line use. By default, gmake(1) do not override command line setting, so this is
> likely to result in build failure or unexpected behavior.
>
> Replace their usage by Kbuild's `{as,cc,ld}flags-y'.
>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Rodolfo Giometti <giometti@enneenne.com>
> Cc: linuxpps@ml.enneenne.com
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>

 - Arnaud

> ---
>  drivers/pps/generators/Makefile |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pps/generators/Makefile b/drivers/pps/generators/Makefile
> index 303304a..21e5e3b 100644
> --- a/drivers/pps/generators/Makefile
> +++ b/drivers/pps/generators/Makefile
> @@ -4,6 +4,4 @@
>
>  obj-$(CONFIG_PPS_GENERATOR_PARPORT) += pps_gen_parport.o
>
> -ifeq ($(CONFIG_PPS_DEBUG),y)
> -EXTRA_CFLAGS += -DDEBUG
> -endif
> +ccflags-$(CONFIG_PPS_DEBUG) += -DDEBUG
> --
> 1.7.6.153.g78432
>
>
