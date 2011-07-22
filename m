Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab1GVTSv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:18:51 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:63782 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754859Ab1GVTSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:18:49 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJLMKU5tgwKe/2dsb2JhbABGDadJeIh8ArtBDoMWgxsEo08
Date: Fri, 22 Jul 2011 21:18:47 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] Generic Watchdog Timer Driver
Message-ID: <20110722191847.GI31767@infomag.iguana.be>
References: <20110711135056.GT29245@infomag.iguana.be> <20110711213145.GB5811@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711213145.GB5811@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

> > Changes since V2:
> > * all "flags" are unsigned
> > * timeout values are also unsigned
> > * removed unnececessary debugging
> > * clean-up comments
> > * the core will be in drivers/watchdog/ and not in drivers/watchdog/core/
> 
> Also (just in case someone started converting drivers):
> 
> * some error-codes changed
> * .name has been removed from watchdog_device in favor of watchdog_info->identity

Yup, I forgot these. Thanks.

Status update: I incorporated your comments and Lars-Peter Clausen's comments and
created V4.  The changes since V3 are:
* removed overdocumentation
* removed MODULE_SUPPORTED_DEVICE and +MODULE_ALIAS_MISCDEV
* removed return -ENOTTY after switch (cmd) because we have the default allready
* s/sent/send/
* I'd suggest to swap the logic here (branch taken on error)
* no_llseek removal squashed into patch 1
* provide getter/setter methods for driver specific data so that we can easily do the conversion towards the device driver model
* removed parent because this would change when we will start using the device driver model


> I already started converting a few drivers and will post the patches as RFC
> tomorrow. In general, converting went quite well and despite a few comments
> (see later mails), I think this could go into 3.1, so that converted drivers
> can go into 3.2 together with (probably) a few updates to the framework. There
> is potential for a bit more consolidation, yet I think the basic stuff could
> go in now.
> 
> Thanks to Wim and Alan for their work and CELF/LF for supporting the final
> steps :)

And for your assistance and the feedback from others also.

Kind regards,
Wim.

