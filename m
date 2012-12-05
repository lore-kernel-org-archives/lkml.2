Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab2LEHJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 02:09:05 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:33408 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2LEHJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 02:09:03 -0500
Date: Wed, 5 Dec 2012 08:09:01 +0100
From: Andreas Mohr <andi@lisas.de>
To: linux-kernel@vger.kernel.org
Cc: Li Shaohua <shaohua.li@intel.com>, linux-acpi@vger.kernel.org
Subject: Look Ma, da kernel is b0rken
Message-ID: <20121205070901.GA12123@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

drivers/pnp/pnpacpi/core.c: In function 'ispnpidacpi':
drivers/pnp/pnpacpi/core.c:65:2: warning: logical 'or' of collectively
exhaustive tests is always true [-Wlogical-op]
drivers/pnp/pnpacpi/core.c:66:2: warning: logical 'or' of collectively
exhaustive tests is always true [-Wlogical-op]
drivers/pnp/pnpacpi/core.c:67:2: warning: logical 'or' of collectively
exhaustive tests is always true [-Wlogical-op]


That's already the second less enticing -Wlogical-op issue
which was discovered by accident during less than two days
of my happy(?) activity of kernel suspend breakage bisection.


Why oh why, as a rather *very* critical piece of software,
can't the kernel use sufficiently aggressive warning levels *by default*??
IMHO it's simply NOT ACCEPTABLE to have such sloppiness creep into
the daily bandwagon of kernel development life
(or should I say: being mandated to creep in?).

Result: whichever default warning level you set
*will* end up as The New Normal,
and all those warnings which then remain able to rear their ugly heads
according to the chosen default level
will be fixed by the community eventually,
and *most others won't* (or at least not in time).

The amount of warnings spewn by make W=3 (or even W=2) is simply
shocking IMNSHO.
And there can always be an argument that most of such warnings
are fixable. If not directly (e.g. because analysis of that warning type
is partially unreliable), then by actively reworking code
into something slightly different.

So, unless there are very hard and *justified* reasons
for keeping builds at such lame-*ss defaults
(such as automated compliance test runs which may not fail -
but in such cases one could argue that *those* uses
should then be required to manually lessen *their* warning level settings),
I would strongly vote for having a hard discussion about the status
quo.


As a somewhat aggravating comment, please note that this warning
actually seems to date back to 1da177e (initial repository build)
according to blame on that file.

Andreas Mohr

P.S.: sorry for the subject line ;)
