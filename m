Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab2D3FJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 01:09:15 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46645 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755280Ab2D3FJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 01:09:14 -0400
X-Sasl-enc: m44aA3FUO+riYyYZqESHPJYXR2kraPgo3OAophQS5Ghp 1335762553
Date: Sun, 29 Apr 2012 22:13:00 -0400
From: Greg KH <greg@kroah.com>
To: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
Message-ID: <20120430021300.GA18148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 12:40:30AM +0200, Markus Franke wrote:
> This patch adds a 1-wire slave device driver for the DS28E04-100.
> 
> Signed-off-by: Markus Franke <franm@hrz.tu-chemnitz.de>
> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

Andrew asked me to relook at this patch, and it turns out to be pretty
messy, I should have never applid it.

You have a lot of checkpatch warnings and errors, and you are creating
new sysfs files with no documentation at all as to what you are doing,
and why you are doing it.  sysfs binary files at that, which should not
be used by ANY code that is trying to intrepret the data being sent to
those files, sysfs binary files are for "pass-through" mode only.

So please redo this patch, cleaning up all of the warnings and errors,
and use the standard kernel interfaces for this type of stuff (i.e. not
sysfs binary files.)

I've reverted it from my tree now, sorry.

greg k-h
