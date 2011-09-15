Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab1IOKP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 06:15:29 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57886 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab1IOKP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 06:15:27 -0400
X-AuditID: cbfee61b-b7b7fae000005864-72-4e71d03eacfe
From: Inki Dae <inki.dae@samsung.com>
To: "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com
References: <1315544581-16379-1-git-send-email-inki.dae@samsung.com>
 <1316080393.23214.12.camel@deskari>
In-reply-to: <1316080393.23214.12.camel@deskari>
Subject: RE: [PATCH] FB: add early fb blank feature.
Date: Thu, 15 Sep 2011 19:14:40 +0900
Message-id: <000001cc7390$482c00f0$d88402d0$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcxzjUyfXWCxuUR/RweYjPMGgDhYWAAALUTg
Content-language: ko
X-OriginalArrivalTime: 15 Sep 2011 10:15:57.0687 (UTC)
 FILETIME=[75DE0070:01CC7390]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Tomi.

> -----Original Message-----
> From: Tomi Valkeinen [mailto:tomi.valkeinen@ti.com]
> Sent: Thursday, September 15, 2011 6:53 PM
> To: Inki Dae
> Cc: FlorianSchandinat@gmx.de; linux-fbdev@vger.kernel.org; akpm@linux-
> foundation.org; linux-kernel@vger.kernel.org; kyungmin.park@samsung.com
> Subject: Re: [PATCH] FB: add early fb blank feature.
> 
> Hi,
> 
> On Fri, 2011-09-09 at 14:03 +0900, Inki Dae wrote:
> > this patch adds early fb blank feature that this is a callback of
> > lcd panel driver would be called prior to fb driver's one.
> > in case of MIPI-DSI based video mode LCD Panel, for lcd power off,
> > the power off commands should be transferred to lcd panel with display
> > and mipi-dsi controller enabled because the commands is set to lcd panel
> > at vsync porch period. on the other hand, in opposite case, the callback
> > of fb driver should be called prior to lcd panel driver's one because of
> > same issue. now we could handle call order to fb blank properly.
> >
> > the order is as the following:
> >
> > at fb_blank function of fbmem.c
> >   -> fb_early_notifier_call_chain()
> >      -> lcd panel driver's early_set_power()
> >   -> info->fbops->fb_blank()
> >      -> fb driver's fb_blank()
> >   -> fb_notifier_call_chain()
> >      -> lcd panel driver's set_power()
> 
> I'm not familiar with the lcd.c, so I may be talking nonsense, but I
> don't quite understand the need for this patch. If you have some kind of
> panel driver, shouldn't the panel driver handle power off in just one
> place?
> 


Yes, almost lcd panels are ok. but for command setting, our lcd panel, mipi-dsi based RGB panel, should be power on before it transfers commands to panel. for example, if user requested FB_BLANK_POWERDOWN then first, display controller would be off and then set_power callback of lcd panel driver would be called. at this time, it has a problem. The problem is that display controller already is off so lcd panel can't accept some commands, such as sleep in command. Lcd panel can accept such commands with vsync period. And also there is another case. This is sparkling issue and would have implications for all ones.
for this, you can refer to a link below:
< http://adras.com/fixed-sparkling-issue-on-lcd-panel-when-fb-blank-mode-is.t196691-141.html >


> With omapfb and omapdss, the omapfb's fb_blank function just calls power
> off in the panel driver, which handles all necessary actions. Is your
> model somehow totally different?
> 
>  Tomi

Best Regards,
Inki Dae.

