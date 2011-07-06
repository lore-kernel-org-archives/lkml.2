Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab1GFTRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 15:17:15 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:25317 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755464Ab1GFTRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 15:17:13 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAEq0FE5tg3wf/2dsb2JhbABTqAd4iHzDPA6GKQSjAA
Date: Wed, 6 Jul 2011 21:17:10 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Wim Van Sebroeck <wim@iguana.be>, LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110706191710.GO29245@infomag.iguana.be>
References: <20110618171946.GB3441@infomag.iguana.be> <201106182058.14702.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106182058.14702.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> > +EXPORT_SYMBOL(watchdog_register_device);
> 
> How about making this EXPORT_SYMBOL_GPL?

My opinion: the new framework has been created for 2 reasons:
1) consolidation of the code that is being repeated in each driver
2) to make it possible to support more then one driver.
If we want to support more then one driver, then the out-of-tree drivers
would benefit from using the API. Even the non-GPL ones.
My feeling is that if we restrict to GPL only, that we then can have the
situation where users will have problems loading the normal in-tree drivers
together with a non-gpl driver that also wants to use /dev/watchdog...
where it could use the same framework.
On the other hand: I don't think there will be really many non-GPL out of
tree drivers anyway.

Alan: what's your opinion?

Kind regards,
Wim.

