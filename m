Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab2BTChu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 21:37:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55226 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab2BTCht convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 21:37:49 -0500
Date: Sun, 19 Feb 2012 20:37:40 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: booster@wolke7.net, hayeswang <hayeswang@realtek.com>,
        "'Eric Dumazet'" <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        "'nic_swsd'" <nic_swsd@realtek.com>, linux-kernel@vger.kernel.org,
        "'Armin Kazmi'" <armin.kazmi@tu-dortmund.de>,
        Lucas Stach <dev@lynxeye.de>
Subject: Re: [PATCH 1/2] r8169: Rx FIFO overflow fixes.
Message-ID: <20120220023740.GA4433@burratino>
References: <20111127092808.GE21635@elie.hsd1.il.comcast.net>
 <4ED2A573.1020807@wolke7.net>
 <20111127231147.GA1784@electric-eye.fr.zoreil.com>
 <D95C09DB1A7E493E89FE5A0B3879CEB0@realtek.com.tw>
 <20111129105440.GA2410@electric-eye.fr.zoreil.com>
 <4ED538EC.4010509@wolke7.net>
 <20111201102000.GA14013@electric-eye.fr.zoreil.com>
 <4ED7E6AB.6050308@wolke7.net>
 <20111201222612.GA27998@electric-eye.fr.zoreil.com>
 <20111205063045.GA3103@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20111205063045.GA3103@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi François, Gerd, et al,

Francois Romieu wrote:

> Realtek has specified that the post 8168c gigabit chips and the post
> 8105e fast ethernet chips recover automatically from a Rx FIFO overflow.
> The driver does not need to clear the RxFIFOOver bit of IntrStatus and
> it should rather avoid messing it.
>
> The implementation deserves some explanation:

I would be interested in some subset of these fixes for 3.0.y and
2.6.32.y.  In particular:

> 1. events outside of the intr_event bit mask are now ignored.
>    a no-processing policy for the events that either should not be there
>    or should be ignored.

This seems like a valuable and unrisky change.

> 2. RxFIFOOver was already ignored in rtl_cfg_infos[RTL_CFG_1] for the
>    whole 8168 line of chips with two exceptions:
>    - RTL_GIGA_MAC_VER_22 since b5ba6d12bdac21bc0620a5089e0f24e362645efd
>      ("use RxFIFO overflow workaround for 8168c chipset.").
>      This one should now be correctly handled.

This seems useful if we can test it.

[...]
> 3. RxFIFOOver is masked for post 8105e 810x chips, namely the sole 8105e
>    (RTL_GIGA_MAC_VER_30) itself.

This also seems useful if we can test it.

What do you think?  Is there any way I can help?  (E.g., given rough
guidelines about what approach is acceptable I'd be happy to work with
Gerd to produce a tested patch that does (1) and (2) but not (3) for
3.0.y.)

Thanks for your hard work,
Jonathan
