Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab1LBFdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 00:33:50 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51448 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab1LBFds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 00:33:48 -0500
Date: Fri, 2 Dec 2011 08:33:42 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: mmarek@suse.cz, sam@ravnborg.org
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Rewriting kernel config after generation
Message-ID: <20111202053342.GA13877@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to add compiling with -march=native to the kernel.
The problem is that then some config options become discoverable at
the beginning of the compilation. For example,
CONFIG_X86_L1_CACHE_SHIFT=6 can be derived from "--param l1-cache-line-size=64".
I suspect this is no-go, because all the dependency logic must be
duplicated somewhere else (in the march=native script) for the above
to work.

Is there any cleaner way I'm missing?

In theory, such script could even turn off CONFIG_CPU_SUP_AMD
if it detects Intel CPU.

	Alexey
