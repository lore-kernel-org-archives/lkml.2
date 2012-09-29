Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab2I2Lp7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 07:45:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab2I2Lp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 07:45:58 -0400
Subject: Re: [PATCH] kbuild: Fix gcc -x syntax
From: Jean Delvare <jdelvare@suse.de>
To: Bernhard Walle <bernhard@bwalle.de>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Michal Marek <mmarek@suse.cz>,
        Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <20120929082459.GA10005@brahe.fritz.box>
References: <1348859536.22956.4.camel@amber.site>
	 <20120929073749.GA7672@gmail.com>  <20120929082459.GA10005@brahe.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Sat, 29 Sep 2012 13:46:32 +0200
Message-ID: <1348919192.4216.2.camel@amber.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, hi Bernhard,

Le samedi 29 septembre 2012 à 09:24 +0100, Bernhard Walle a écrit :
> * Ingo Molnar <mingo@kernel.org> [2012-09-29 08:37]:
> > * Jean Delvare <jdelvare@suse.de> wrote:
> > 
> > > The correct syntax for gcc -x is "gcc -x assembler", not "gcc 
> > > -xassembler". Even though the latter happens to work, the 
> > > former is what is documented in the manual page and thus what 
> > > gcc wrappers such as icecream do expect.
> > > 
> > > This isn't a cosmetic change. The missing space prevents 
> > > icecream from recognizing compilation tasks it can't handle, 
> > > leading to silent kernel miscompilations.
> > 
> > Although we can apply this patch, it won't solve the problem of 
> > building older kernels (and bisecting, etc.).

WRT older kernels, I recommend that we apply the fix to all stable and
longterm kernel branches.

> > Wouldn't it be prudent to increase the compatibility of 
> > icecream, so that it accepts what GCC accepts in practice,
> > such as -xassembler?
> 
> Wouldn't it make sense to do both? Using the documented syntax in the
> build system *and* increase compatibility in 3rd party tools?

Yes of course, this is exactly the plan. Silent micompilations are very
painful so we want to fix the problem on every side we can.

Thanks,
-- 
Jean Delvare
Suse L3

