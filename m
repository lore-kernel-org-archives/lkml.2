Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab2H3XBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 19:01:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61535 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab2H3XBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 19:01:34 -0400
Date: Thu, 30 Aug 2012 16:01:29 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, rdunlap@xenotime.net, arve@android.com,
        kernel-team@android.com, john.stultz@linaro.org
Subject: Re: [PATCH v2] drivers/tty: Folding Android's keyreset driver in
 sysRQ
Message-ID: <20120830230129.GC21501@core.coreip.homeip.net>
References: <1346365854-28441-1-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346365854-28441-1-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthieu,

On Thu, Aug 30, 2012 at 04:30:54PM -0600, mathieu.poirier@linaro.org wrote:
> From: "Mathieu J. Poirier" <mathieu.poirier@linaro.org>
> 
> This patch adds keyreset functionality to the sysrq driver. It
> allows certain button/key combinations to be used in order to
> trigger device resets.
> 
> The first time the key-combo is detected a work function that syncs
> the filesystems is scheduled and the kernel rebooted. If all the keys
> are released and then pressed again, it calls panic. Reboot on panic
> should be set for this to work.  A platform device that specify a
> reset key-combo should be added to the board file to trigger the
> feature.

Why do we need to involve a platform device and not use, for example, a module
parameter, that could be set up from userspace?

Also, why do we need reset_fn() and not simply invoke SysRq-B handler
that should call ctrl_alt_del() for us?

Thanks.

-- 
Dmitry
