Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab0LGOaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:30:12 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57067 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab0LGOaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:30:10 -0500
Date: Tue, 7 Dec 2010 09:26:39 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: sedat.dilek@gmail.com
Cc: wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Nick Kossifidis <mickflemm@gmail.com>, Bruno Randolf <br1@einfach.org>,
        ath5k-devel <ath5k-devel@venema.h4ckr.net>
Subject: Re: [linux-next] next-20101207: Better now, but modinfo ath5k
Message-ID: <20101207142639.GB2700@tuxdriver.com>
References: <AANLkTik1P7vQbgL8qxoTEEyR0D0cTV+9zsBcHT3L_nwm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik1P7vQbgL8qxoTEEyR0D0cTV+9zsBcHT3L_nwm@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 12:24:14PM +0100, Sedat Dilek wrote:

> I have already reported on linux-wireless (short: l-w) ML that after
> especially the merge of "AHB Bus support" patchset (see [2]) my ath5k
> was not working as expected in daily use (also modinfo).
> 
> I am not sure if it is the driver but reverting the 9 commits in my
> local linux-next GIT seemed to "stabilize" a bit the Internet
> connection.
> The patchset from Nick (see below) definitely helped to stabilize ath5k.

I imagine that these are the "9 commits" you mean:

> git rev-list c30ae13..4cebb34
4cebb34caa5122216a1e2451eae9e0fc47ec2589
a0b907ee2a71052fefdf6151764095f3f97b3275
c31b5c9c806b1fbdc9e98885d897664a0d482989
e7aecd327d80b2f156b54769013aaccb2a20645a
8efa5d7d6ad307ae2d220def37ca89594062c40d
4aa5d783c9e1c72e4950ff34f388077ccecac74a
e5b046d86fac609f636d127a38de94a175c7e83b
132b1c3ee38ea6fa0501004fd0f19acb554e5a44
aeae4ac9090462ea38387dcdbac4f01b944af6a4

Most of those look fairly harmless so long as you don't define
CONFIG_ATHEROS_AR231X.  Just to narrow things down...if you only revert
the first 8 (i.e. leave aeae4ac alone), do you still have problems?
Or does it still "stabilize"?

That patch converts the driver to the generic DMA API.  It seems
OK at first glance, but I suspect it is the only one likely to be
effecting your situation.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
