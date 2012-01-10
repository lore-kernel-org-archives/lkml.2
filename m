Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2AJS1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 13:27:25 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35172 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657Ab2AJS1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:27:23 -0500
MIME-Version: 1.0
In-Reply-To: <20120109073727.GF22134@opensource.wolfsonmicro.com>
References: <20120109073727.GF22134@opensource.wolfsonmicro.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Jan 2012 10:27:01 -0800
X-Google-Sender-Auth: _q3OsukrZPM3_shyR5nwN4QKQcM
Message-ID: <CA+55aFyhoh0rT_ujuE1w3RpuR7kqivYFwPpm66VC-xtq1PiGUQ@mail.gmail.com>
Subject: Re: Regulator updates for 3.3
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 8, 2012 at 11:37 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> Please pull from the tree below to merge regulator API updates for
> version 3.3  The major update here is the addition of device tree
> support by Rajendra Nayak, and we also have a new driver for the
> regulators on the DA9052 PMIC.  Otherwise most of the changes are
> bug fixes and cleanups of one form or another.

Mark, I pulled this, but I was *this* close to unpulling it because
it's such an unholy mess.

You seem to do the crazy "daily pull" crap that NOBODY IS EVER SUPPOSED TO DO.

There are lots of totally pointless

   Merge remote-tracking branch 'regulator/for-linus' into regulator-next

merge commits, and no, that's not ok. It makes the history really hard
to read, and has some bad practical impact outside of that
visualization issue too (bisection becomes slower and much more of a
pain, for example).

Just don't do it. There's no excuse. The *only* time you should merge
is when a sub lieutenant asks you to - and if you have people who work
with you and ask you to do pointless merges almost every day, just
tell them to shut the f*ck up already!

If you want to have a special linux-next branch that you want to merge
crap into (for linux-next), go right ahead. But dammit, don't then do
development on top of that kind of crap - use that branch *only* for
linux-next, not for anything else, and don't ask me to pull that
polluted piece of sh*t.

Do your development in a real branch, and do sane things in that real
branch - like pulling from the people who work with you, but only when
they ask, and only when they are ready.  And applying patches. But
never *ever* have those stupid pointless "Merge remote-tracking branch
'regulator/for-linus' into regulator-next" in the branch you actually
use for development, and the branch you send to me.

                       Linus
