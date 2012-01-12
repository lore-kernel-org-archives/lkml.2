Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab2ALU7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:59:18 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44876 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab2ALU7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:59:10 -0500
Date: Thu, 12 Jan 2012 12:59:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Arnd Bergmann <arnd@arndb.de>
cc: Andrew Jones <drjones@redhat.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, david.woodhouse@intel.com,
        gregkh@suse.de, davem@davemloft.net, axboe@kernel.dk, holt@sgi.com,
        linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        hskinnemoen@gmail.com, egtvedt@samfundet.no, msalter@redhat.com,
        a-jacquiot@ti.com, starvik@axis.com, jesper.nilsson@axis.com,
        dhowells@redhat.com, takata@linux-m32r.org, geert@linux-m68k.org,
        yasutake.koichi@jp.panasonic.com, jonas@southpole.se, kyle@mcmartin.ca,
        deller@gmx.de, jejb@parisc-linux.org, chris@zankel.net, greg@kroah.com,
        davej@redhat.com, airlied@linux.ie, jkosina@suse.cz,
        mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
In-Reply-To: <201201120918.53026.arnd@arndb.de>
Message-ID: <alpine.DEB.2.00.1201121255310.17287@chino.kir.corp.google.com>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com> <alpine.DEB.2.00.1201111353330.21755@chino.kir.corp.google.com> <201201120918.53026.arnd@arndb.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jan 2012, Arnd Bergmann wrote:

> > I would think that something like CONFIG_SMALLMEM would identify those 
> > candidates (for things like SLOB) and then you could separate the rest 
> > based on the platform they exist for since you're essentially introducing 
> > a new config symbol here that existed in the past but are now using it 
> > with different semantics.
> 
> The CONFIG_SMALLMEM would also require people to know what they are doing,
> beyond what we expect the average person building a kernel to, which is
> just what CONFIG_EXPERT means, and the same reason why we ended up renaming
> CONFIG_EMBEDDED to CONFIG_EXPERT. People have a very different understanding
> of what "embedded" actually means, and not all of those require small
> memory footprint or even a custom kernel. Let's just stay with CONFIG_EXPERT.
> 

I think the intention here, correct me if I'm wrong, is to aid those who 
are configuring the kernel to prefer certain options over others for 
special devices such as embedded devices that require a low memory 
footprint.  So if a CONFIG_SMALLMEM were to exist with helpful text 
associated with it, then it could be chosen to enable things like 
CONFIG_SLOB that the user may not previously have looked for or understood 
and wouldn't make sense without CONFIG_SMALLMEM unless debugging.
