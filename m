Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab1AFH25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 02:28:57 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:48607 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab1AFH24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 02:28:56 -0500
Date: Thu, 6 Jan 2011 16:26:58 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Zhang Lily-R58066 <r58066@freescale.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Subject: Re: [PATCH 4/9] fb: export fb mode db table
Message-ID: <20110106072658.GB15914@linux-sh.org>
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de> <1291902441-24712-5-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291902441-24712-5-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 02:47:16PM +0100, Sascha Hauer wrote:
> The different modes can be useful for drivers. Currently there is
> no way to expose the modes to sysfs, so export them.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

I'll admit I don't really like the idea of exposing the modedb to drivers
in this way, but given that we're already doing it for the vesa and cea
modes, allowing drivers to copy ranges in to their modelist from the
standard db is probably something we can live with.

The mode list dumping is basically a blatant sysfs abuse already though,
and it would be much cleaner simply to back the mode store with an
fb_find/try_mode() pair that grovels all the right places in addition to
doing a pass over the fb_info's modelist.
