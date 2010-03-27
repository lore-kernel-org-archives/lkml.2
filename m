Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab0C0OVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 10:21:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59437 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab0C0OVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 10:21:18 -0400
Date: Sat, 27 Mar 2010 15:21:13 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: linux-fbdev@vger.kernel.org, Jaya Kumar <jayalk@intworks.biz>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       James Simmons <jsimmons@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] fbdev: section cleanup in arcfb
Message-ID: <20100327142113.GB15267@pengutronix.de>
References: <1269671092-19948-1-git-send-email-henne@nachtwindheim.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1269671092-19948-1-git-send-email-henne@nachtwindheim.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 27, 2010 at 07:24:45AM +0100, Henrik Kretzschmar wrote:
> This patch fixes the sections in the arcfb driver.
> 
> WARNING: drivers/video/built-in.o(.devinit.text+0x543): Section mismatch in reference from the function arcfb_probe() to the variable .init.data:arcfb_var
> The function __devinit arcfb_probe() references
> a variable __initdata arcfb_var.
> If arcfb_var is only used by arcfb_probe then
> annotate arcfb_var with a matching annotation.
> 
> WARNING: drivers/video/built-in.o(.devinit.text+0x558): Section mismatch in reference from the function arcfb_probe() to the variable .init.data:arcfb_fix
> The function __devinit arcfb_probe() references
> a variable __initdata arcfb_fix.
> If arcfb_fix is only used by arcfb_probe then
> annotate arcfb_fix with a matching annotation.

... by moving arcfb_fix and arcfb_var to .devinit.data

Addionally it moves arcfb_remove to .devexit.text.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
