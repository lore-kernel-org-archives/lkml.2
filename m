Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab2ADJuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 04:50:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59602 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab2ADJu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 04:50:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: interesting merges in the arm-soc tree
Date: Wed, 4 Jan 2012 09:50:10 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Vinod Koul'" <vinod.koul@intel.com>,
        "'Linus'" <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
References: <20120104104758.26b0ca5268d10fbf7b95903a@canb.auug.org.au> <01bc01ccca7b$f6483fe0$e2d8bfa0$%kim@samsung.com>
In-Reply-To: <01bc01ccca7b$f6483fe0$e2d8bfa0$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201040950.10835.arnd@arndb.de>
X-Provags-ID: V02:K0:IOLOCa93AKw5W11knHex25jtNIkntkJF38NUc4QcVYA
 9rY1qIXhGcIJDje+uwQMjCAsmB/D1c8oyasODRDOOTKLYY+6w6
 ZctHgVp/bEX6uxDMHD2tjmteCDzuFk0NFmq98AASIVMBCcaY+7
 QKn9tejFgiSFW9byCaOOxBs8M916i9lWxWzqBAipv+Wyv+ehC6
 U2A6zo8dk2hLB/ATV00tycT7HqLgakJTqknmxbTFjBBOHSHbLO
 mqK2JxlX3s8kjnzTtL8q1WtYgTXU4TONISxnZ5ZUakMJ71YnJU
 W7eYm4rBzttr7ojHJF5iE+DjvPOcegAbIrQDcVRsLdlNLpzLTg
 D0H1XqOdg7bnH/XNd4lE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 January 2012, Kukjin Kim wrote:
> > few conflicts (but that is not excuse) and there may be dependencies in a
> > driver on the v4l-dvb tree (but maybe that means that that driver should
> > be merged via the v4l-dvb tree - it looks like the "at91/drivers" is
> > based on the v4l-dvb tree, so probably doesn't depend on anything else on
> > the arm-soc tree).
> > 
> > If nothing else, are you sure that neither of those merged trees will
> > rebase?  You have also just inherited any bugs in those two trees.
> 
> I know, Vinod knows I merged his tree for above situation so he will not
> rebase that and Arnd will send that after merging of slave-dma into mainline
> during merge window. 

Right. The same is true for the other branch (depends/v4l) in next/drivers2.
The next/drivers2 branch will get submitted when all three of its dependencies
are merged.

Stephen, we have introduced a file arch/arm/arm-soc-for-next-contents.txt
to help us track those dependencies, and maybe it can also help you
understand our merge plans when you see potential problems like this.

Right now, there are 13 next/* branches that we plan to submit to Linus
in order. All of those are merged into the for-next branch that you pull,
and the contents.txt file tells you about the dependencies between those
branches and to external branches.

My understanding about the at91 changes from Nicolas Ferre is that they
depend on both the v4l and previous arm-soc changesets, so it was decided
to merge those through arm-soc after the v4l branch.

	Arnd
