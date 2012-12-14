Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab2LNLEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:04:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41271 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980Ab2LNLCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:02:55 -0500
Date: Fri, 14 Dec 2012 12:02:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, wim@iguana.be,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: kernel panic when reboot
Message-ID: <20121214110253.GB4966@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Wanlong Gao <gaowanlong@cn.fujitsu.com>,
	LKML <linux-kernel@vger.kernel.org>, wim@iguana.be,
	Tomas Winkler <tomas.winkler@intel.com>
References: <50CAF165.5080209@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50CAF165.5080209@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 05:29:09PM +0800, Wanlong Gao wrote:
> Hi, 
> 
> I hit the kernel panic when reboot the system today, just system reboot can cause kernel panic.
> 
> $ git describe 
> v3.7-7784-g7313264
> 
> The config file is attached.
> And the crash screen is uploaded here http://www.tiikoni.com/tis/view/?id=e187047

AFAICT, it looks like list corruption in the mutex_lock path when
trying to grab the watchdog->lock, when we're coming down from
mei_watchdog_unregister().

Is it reproducible?

Btw, this is pre -rc1 kernel so I wouldn't take any issues it has too
seriously before Linus hasn't done -rc1 at least. Testing arbitrary
points in the history is known to lead to all kinds of issues which
aren't reproducible later in my experience.

Adding a MEI guy to CC just in case.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
