Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab2BVNSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:18:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57099 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab2BVNSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:18:38 -0500
Date: Wed, 22 Feb 2012 13:18:16 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rmallon@gmail.com
Subject: Re: [PATCH v2 07/19] ARM: at91/pm_slowclock: function slow_clock()
	accepts parameters
Message-ID: <20120222131816.GB22562@n2100.arm.linux.org.uk>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329903206.git.nicolas.ferre@atmel.com> <5b8fbdf669825987a82b3b89b2e7f02239cad816.1329903206.git.nicolas.ferre@atmel.com> <20120222095250.GV22562@n2100.arm.linux.org.uk> <20120222125814.GA9407@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222125814.GA9407@game.jcrosoft.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 01:58:14PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> Btw I'm looking on a way to switch the assembly funciton to C but I didn,t find a
> good way to calculate the function size except by touching at the linker
> script. Which I don;t want to do.

Forget doing it in C.  C is too complicated, because either you have to
keep its relocations and fix them up, or you have to compile and link it
to run at a specific location and then copy it to that location.  You
also have literal pools to think about.

Assembly is much better controlled and you can write it so that you don't
end up with any of that stuff.  You have absolute control over the code
and associated data.
