Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab2EYWjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:39:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43160 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2EYWjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:39:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 26 May 2012 00:38:56 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v3.5-rc1] media updates for v3.5
Message-ID: <20120526003856.7e4efd77@stein>
In-Reply-To: <4FBF773B.10408@redhat.com>
References: <4FBE5518.5090705@redhat.com>
	<CA+55aFyt2OFOsr5uCpQ6nrur4zhHhmWUJrvMgLH_Wy1niTbC6w@mail.gmail.com>
	<4FBEB72D.4040905@redhat.com>
	<CA+55aFyYQkrtgvG99ZOOhAzoKi8w5rJfRgZQy3Dqs39p1n=FPA@mail.gmail.com>
	<4FBF773B.10408@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 25 Mauro Carvalho Chehab wrote:
> A simple way to solve it seems to make those options dependent on CONFIG_EXPERT.
> 
> Not sure if all usual distributions disable it, but I guess most won't have
> EXPERT enabled.
> 
> The enclosed patch does that. If nobody complains, I'll submit it together
> with the next git pull request.

I only want dvb-core and firedtv.  But when I switch off
CONFIG_MEDIA_TUNER_CUSTOMISE, suddenly also

  CC [M]  drivers/media/common/tuners/tuner-xc2028.o
  CC [M]  drivers/media/common/tuners/tuner-simple.o
  CC [M]  drivers/media/common/tuners/tuner-types.o
  CC [M]  drivers/media/common/tuners/mt20xx.o
  CC [M]  drivers/media/common/tuners/tda8290.o
  CC [M]  drivers/media/common/tuners/tea5767.o
  CC [M]  drivers/media/common/tuners/tea5761.o
  CC [M]  drivers/media/common/tuners/tda9887.o
  CC [M]  drivers/media/common/tuners/tda827x.o
  CC [M]  drivers/media/common/tuners/tda18271-maps.o
  CC [M]  drivers/media/common/tuners/tda18271-common.o
  CC [M]  drivers/media/common/tuners/tda18271-fe.o
  CC [M]  drivers/media/common/tuners/xc5000.o
  CC [M]  drivers/media/common/tuners/xc4000.o
  CC [M]  drivers/media/common/tuners/mc44s803.o
  LD [M]  drivers/media/common/tuners/tda18271.o

are built.  Why is that?

$ grep DVB .config
CONFIG_DVB_CORE=m
# CONFIG_DVB_NET is not set
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set
CONFIG_DVB_CAPTURE_DRIVERS=y
# CONFIG_DVB_BUDGET_CORE is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_DVB_B2C2_FLEXCOP is not set
# CONFIG_DVB_PLUTO2 is not set
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y
# CONFIG_DVB_PT1 is not set
# CONFIG_DVB_NGENE is not set
# CONFIG_DVB_DDBRIDGE is not set
# Supported DVB Frontends
# CONFIG_DVB_FE_CUSTOMISE is not set
# DVB-S (satellite) frontends
# DVB-T (terrestrial) frontends
# DVB-C (cable) frontends
# SEC control devices for DVB-S
# CONFIG_DVB_DUMMY_FE is not set

-- 
Stefan Richter
-=====-===-- -=-= ==-=-
http://arcgraph.de/sr/
