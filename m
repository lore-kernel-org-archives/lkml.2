Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab2DMM7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 08:59:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41235 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074Ab2DMM7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 08:59:22 -0400
Date: Fri, 13 Apr 2012 14:59:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Simon Wood <simon@mungewell.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>
Subject: Re: [PATCH] HID: hid-lg4ff: Add support for G27 LEDs
In-Reply-To: <1333987734-8217-1-git-send-email-simon@mungewell.org>
Message-ID: <alpine.LNX.2.00.1204131458290.16373@pobox.suse.cz>
References: <1649210.pcO5IpzBEF@qosmio-x300> <1333987734-8217-1-git-send-email-simon@mungewell.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2012, Simon Wood wrote:

> This patch adds supports for controlling the LED 'tachometer' on
> the G27 wheel, via the LED subsystem.
> 
> The 5 LEDs are arranged from right (1=grn, 2=grn, 3=yel, 4=yel, 5=red)
> and 'mirrored' to the left (10 LEDs in total).
> 
> Signed-off-by: Simon Wood <simon@mungewell.org>
> ---
>  drivers/hid/hid-lg4ff.c |  149 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 148 insertions(+), 1 deletions(-)

This patch introduces a clear dependency of hid-lg4ff driver on 
CONFIG_LEDS_CLASS, but the code doesn't reflect it.

So either you have to put #ifdef into source to compile the leds part out 
if leds subsystem is not enabled, or you have to introduce Kconfig rule to 
cover this.

-- 
Jiri Kosina
SUSE Labs
