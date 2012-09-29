Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142Ab2I2Hh4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 03:37:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44855 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab2I2Hhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 03:37:55 -0400
Date: Sat, 29 Sep 2012 09:37:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Bernhard Walle <bernhard@bwalle.de>, Michal Marek <mmarek@suse.cz>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] kbuild: Fix gcc -x syntax
Message-ID: <20120929073749.GA7672@gmail.com>
References: <1348859536.22956.4.camel@amber.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348859536.22956.4.camel@amber.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jean Delvare <jdelvare@suse.de> wrote:

> The correct syntax for gcc -x is "gcc -x assembler", not "gcc 
> -xassembler". Even though the latter happens to work, the 
> former is what is documented in the manual page and thus what 
> gcc wrappers such as icecream do expect.
> 
> This isn't a cosmetic change. The missing space prevents 
> icecream from recognizing compilation tasks it can't handle, 
> leading to silent kernel miscompilations.

Although we can apply this patch, it won't solve the problem of 
building older kernels (and bisecting, etc.).

Wouldn't it be prudent to increase the compatibility of 
icecream, so that it accepts what GCC accepts in practice,
such as -xassembler?

Thanks,

	Ingo
