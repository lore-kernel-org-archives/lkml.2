Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab2LQRGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 12:06:25 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:47377 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2LQRGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 12:06:24 -0500
Message-ID: <50CF510E.6050406@tilera.com>
Date: Mon, 17 Dec 2012 12:06:22 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Simon Marchi <simon.marchi@polymtl.ca>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] arch/tile: implement user_regset interface on tilegx
References: <1355546091-32537-1-git-send-email-simon.marchi@polymtl.ca>
In-Reply-To: <1355546091-32537-1-git-send-email-simon.marchi@polymtl.ca>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 11:34 PM, Simon Marchi wrote:
> This is an implementation of user_regset for the tilegx architecture. It
> reuses the basic blocks that were already there.

Thanks, Simon!  A couple of comments:

I encourage you to respin this for tilepro as well as tilegx, since it's going to be trivial to make it happen.  Just take away all yours ifdefs, and use #include <arch/chip.h> and CHIP_ARCH_NAME instead of the string "tilegx".  It's worth it just to avoid the ifdefs in the code :-)

I think with this support added, we have all the prerequisites to add "select HAVE_ARCH_TRACEHOOK" under "config TILE" in arch/tile/Kconfig, so we might as well do that too.  That will enable PTRACE_GETREGSET and PTRACE_SETREGSET, as well as /proc/PID/syscall, so why not?

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

