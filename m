Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab1DBBLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 21:11:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56851 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756802Ab1DBBLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 21:11:54 -0400
Date: Sat, 2 Apr 2011 10:12:03 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Robert Rosengren <robert.rosengren@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] regulator: recursive locking detected
Message-ID: <20110402011202.GC25424@opensource.wolfsonmicro.com>
References: <1301652257-19347-1-git-send-email-robert.rosengren@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301652257-19347-1-git-send-email-robert.rosengren@stericsson.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 12:04:17PM +0200, Robert Rosengren wrote:
> "possible recursive locking detected"-warnings are issued when a
> regulator has specified supply regulator. Both when enabling and
> disabling regulators uses recursive call chains for notify the supply
> regulators. This is due to locking mutexes of the same lock class,
> i.e. the locks reside in the regulator_dev struct.

There's actually a race here reported by David Brown in the past week
when working with supplies so the lock warning is probably a real issue
which should be fixed rather than overriding the warning.  Search the
list for the past week or so for the details.

> +/* locks held by regulator_enable()
> + * lock_sublevel should always be 0, only used for recursive calls.
> + */
> +static int _regulator_enable(struct regulator_dev *rdev,
> +				int lock_sublevel)

This comment is inaccurate (and if it were then obviously sublevel
wouldn't be needed).
