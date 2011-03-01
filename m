Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab1CAIvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:51:31 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53541 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab1CAIva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:51:30 -0500
Date: Tue, 1 Mar 2011 08:49:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Simon Glass <sjg@chromium.org>
Cc: linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexander Shishkin <virtuoso@slind.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ARM: Use generic BUG() handler
Message-ID: <20110301084949.GA16733@n2100.arm.linux.org.uk>
References: <1298939263-16421-1-git-send-email-sjg@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298939263-16421-1-git-send-email-sjg@chromium.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 04:27:43PM -0800, Simon Glass wrote:
> +	asm volatile("1:\t.word %c3\n"				\
> +		     ".pushsection __bug_table,\"a\"\n"		\
> +		     "2:\t.word 1b, %c0\n"			\
> +		     "\t.hword %c1, 0\n"			\
> +		     "\t.org 2b+%c2\n"				\

%c doesn't work on lots of versions of gcc, which is why we can't use
the generic bug support.  There's no way to reliably generate constants
without many compiler versions spitting out a '#' before them.
