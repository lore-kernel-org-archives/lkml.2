Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab2EGBSE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 21:18:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51138 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab2EGBSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 21:18:01 -0400
Date: Mon, 7 May 2012 02:17:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IA32 Emulation: Fix build problem after commit ce7e5d2d1
Message-ID: <20120507011759.GE22082@ZenIV.linux.org.uk>
References: <4fa719e3.9iRhEn6/mKpQXtGf%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fa719e3.9iRhEn6/mKpQXtGf%Larry.Finger@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 07:40:03PM -0500, Larry Finger wrote:
> Commit ce7e5d2d19bc ("x86: fix broken TASK_SIZE for ia32_aout") breaks kernel
> builds when "CONFIG_IA32_AOUT=m" with
> 
> ERROR: "set_personality_ia32" [arch/x86/ia32/ia32_aout.ko] undefined!
> make[1]: *** [__modpost] Error 1
> 
> The entry point needs to be exported.

ACK, with apologies - I don't normally use that sucker, obviously, so I'd just
flipped CONFIG_IA32_AOUT to y while testing.  Missed that it was modular and
that no other binfmt using the same thing are modular, so it wasn't exported.
