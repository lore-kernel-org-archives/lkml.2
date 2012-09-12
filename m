Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab2ILGxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:53:50 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:43324 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab2ILGxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:53:48 -0400
Message-ID: <1347432846.4293.0.camel@jlt4.sipsolutions.net>
Subject: Re: iwl3945: order 5 allocation during ifconfig up; vm problem?
From: Johannes Berg <johannes@sipsolutions.net>
To: Marc MERLIN <marc@merlins.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
        David Rientjes <rientjes@google.com>, sgruszka@redhat.com,
        linux-wireless@vger.kernel.org, wey-yi.w.guy@intel.com,
        ilw@linux.intel.com, Andrew Morton <akpm@osdl.org>,
        Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Wed, 12 Sep 2012 08:54:06 +0200
In-Reply-To: <20120912055712.GE11613@merlins.org> (sfid-20120912_075811_640589_74AB6505)
References: <20120909213228.GA5538@elf.ucw.cz>
	 <alpine.DEB.2.00.1209091539530.16930@chino.kir.corp.google.com>
	 <20120910111113.GA25159@elf.ucw.cz>
	 <20120911162536.bd5171a1.akpm@linux-foundation.org>
	 <1347426988.13103.684.camel@edumazet-glaptop>
	 <20120912055712.GE11613@merlins.org> (sfid-20120912_075811_640589_74AB6505)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-11 at 22:57 -0700, Marc MERLIN wrote:
> On Wed, Sep 12, 2012 at 07:16:28AM +0200, Eric Dumazet wrote:
> > On Tue, 2012-09-11 at 16:25 -0700, Andrew Morton wrote:
> > 
> > > Asking for a 256k allocation is pretty crazy - this is an operating
> > > system kernel, not a userspace application.
> > > 
> > > I'm wondering if this is due to a recent change, but I'm having trouble
> > > working out where the allocation call site is.
> > > --
> > 
> > (Adding Marc Merlin to CC, since he reported same problem)
> > 
> > Thats the firmware loading in iwlwifi driver. Not sure if it can use SG.
> > 
> > drivers/net/wireless/iwlwifi/iwl-drv.c
> > 
> > iwl_alloc_ucode() -> iwl_alloc_fw_desc() -> dma_alloc_coherent()
> > 
> > It seems some sections of /lib/firmware/iwlwifi*.ucode files are above
> > 128 Kbytes, so dma_alloc_coherent() try order-5 allocations
> 
> Thanks for looping me in, yes, this looks very familiar to me :)
> 
> In the other thread, Johannes Berg gave me this patch which is supposed to
> help: http://p.sipsolutions.net/11ea33b376a5bac5.txt

Yes, but that patch won't apply to iwlegacy as is. However, I'm pretty
sure that it should be possible to solve the issue in the same way in
iwlegacy.

johannes

