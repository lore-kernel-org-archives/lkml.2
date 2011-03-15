Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab1COFCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 01:02:18 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37727 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1COFCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 01:02:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=eaX09YYEJ5faIwnPRo1fnPTFi0fYGYxm2Zxh/gBaJd+S81090QAXM/DejIZ0vi6c4Y
         Go0ih9U7N89/gXrVFSCqbsPsspbSBMAm0K4xpXq3BvqSewgfOjz8T1GlVKtKvGw5n+zB
         rlC0qMaudc0jfdLfShq6GEHz57AfJNB4Bt0ME=
Date: Mon, 14 Mar 2011 22:02:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Haojian Zhuang <hzhuang1@marvell.com>
Cc: "johnpol@2ka.mipt.ru" <johnpol@2ka.mipt.ru>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] input: touchscreen: use polling mode in 88pm860x
Message-ID: <20110315050206.GC1046@core.coreip.homeip.net>
References: <1299512600-29047-1-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-2-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-3-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-4-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-5-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-6-git-send-email-haojian.zhuang@marvell.com>
 <20110313064426.GG31566@core.coreip.homeip.net>
 <25B60CDC2F704E4E9D88FFD52780CB4C05CEAFFB99@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C05CEAFFB99@SC-VEXCH1.marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 05:41:35AM -0700, Haojian Zhuang wrote:
> 
> 
> >-----Original Message-----
> >From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> >Sent: 2011年3月13日 2:44 PM
> >To: Haojian Zhuang
> >Cc: johnpol@2ka.mipt.ru; sameo@linux.intel.com; a.zummo@towertech.it;
> >lrg@slimlogic.co.uk; broonie@opensource.wolfsonmicro.com;
> >rpurdie@rpsys.net; linux-kernel@vger.kernel.org
> >Subject: Re: [PATCH] input: touchscreen: use polling mode in 88pm860x
> >
> >On Mon, Mar 07, 2011 at 11:43:14PM +0800, Haojian Zhuang wrote:
> >> Measuring point on touchscreen with IRQ mode can only monitor pen-down
> >> event. If finger is moving on touchscreen, it can't be monitored by
> >> IRQ pen-down event. So switch to polling mode after pen-down event.
> >>
> >
> >Instead of scheduling work you could stay in the interrupt handler
> >(which is a separate thread) and poll from it. Or is it a nested
> >interrupt and it is sharing the interrupt thread?
> >
> >Thanks.
> >
> >--
> >Dmitry
> 
> I'm using a nested interrupt. Do you mean that I should keep polling in the nested interrupt handler?
> 

No, I do not believe you can poll from the nested handler since I
believe it shares the thread with other interrupts. In non-nested case
you could though.

Thanks.

-- 
Dmitry
