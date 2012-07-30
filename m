Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab2G3WT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 18:19:26 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52088 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab2G3WTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 18:19:25 -0400
Date: Mon, 30 Jul 2012 23:19:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] ARM: Sort exception table at compile time
Message-ID: <20120730221911.GB10335@n2100.arm.linux.org.uk>
References: <1343683803-15507-1-git-send-email-sboyd@codeaurora.org> <20120730215118.GA32670@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120730215118.GA32670@merkur.ravnborg.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 11:51:18PM +0200, Sam Ravnborg wrote:
> Here you should be able to use the macro EXCEPTION_TABLE from
> vmlinux.lds.h.
> I cannot see why the ifdef for not NON-MMU case is needed,
> but if it is needed the macro is not good...

Because you can not mention the same input section in two different
places and end up with predictable output from the linker.

We discard the __ex_table for noMMU, but I think the start/stop
symbols are still referenced somewhere.  Dunno, I don't have much to
do with noMMU ARM, and the only platform I'd be interested in never
got merged.
