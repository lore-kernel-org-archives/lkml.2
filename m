Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab2LXSZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 13:25:57 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48100 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2LXSZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 13:25:55 -0500
Date: Mon, 24 Dec 2012 10:25:49 -0800
From: Tejun Heo <tj@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-input@vger.kernel.org
Subject: Re: [PATCH 17/25] wm97xx: don't use [delayed_]work_pending()
Message-ID: <20121224182549.GA11817@htj.dyndns.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-18-git-send-email-tj@kernel.org>
 <20121223095450.GA17407@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121223095450.GA17407@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dmitry.

On Sun, Dec 23, 2012 at 01:54:50AM -0800, Dmitry Torokhov wrote:
> This is not 100% equivalent transformation as now we schedule first and
> disable IRQ later... Anyway, I think the driver shoudl be converted to
> threaded IRQ instead. Mark, does the patch below make any sense to you?

Yeah, I think the conversion is actually broken.  There isn't anything
which prevents work item execution racing against irq disabling.  I
agree the right thing to do is using threaded irq handler.

Thanks!

-- 
tejun
