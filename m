Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab2ARJ4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:56:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756308Ab2ARJ4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:56:32 -0500
Date: Wed, 18 Jan 2012 10:54:28 +0100
From: Andrew Jones <drjones@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        david.woodhouse@intel.com, gregkh@suse.de, davem@davemloft.net,
        axboe@kernel.dk, holt@sgi.com, linux-arch@vger.kernel.org,
        linux@arm.linux.org.uk, hskinnemoen@gmail.com, egtvedt@samfundet.no,
        msalter@redhat.com, a-jacquiot@ti.com, starvik@axis.com,
        jesper.nilsson@axis.com, dhowells@redhat.com, takata@linux-m32r.org,
        geert@linux-m68k.org, yasutake.koichi@jp.panasonic.com,
        jonas@southpole.se, kyle@mcmartin.ca, deller@gmx.de,
        jejb@parisc-linux.org, chris@zankel.net, greg@kroah.com,
        davej@redhat.com, airlied@linux.ie, jkosina@suse.cz,
        mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
Message-ID: <20120118095427.GD2317@turtle.usersys.redhat.com>
References: <20120113085125.GA2452@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201130230320.15417@chino.kir.corp.google.com>
 <20120113122202.GB2452@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201131318340.24089@chino.kir.corp.google.com>
 <4F1442C5.70500@redhat.com>
 <alpine.DEB.2.00.1201161530170.16270@chino.kir.corp.google.com>
 <20120117144644.GC3188@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201171246280.2595@chino.kir.corp.google.com>
 <20120118085620.GB2317@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201180119550.19730@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1201180119550.19730@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 01:31:30AM -0800, David Rientjes wrote:
> CONFIG_EXPERT isn't an invitation to be able to configure everything in 
> the kernel.

Correct. It definitely shouldn't. It actually shouldn't configure *ANYTHING*
in the kernel. Stopping it from doing so is exactly what this patch does.
It should only expose expert options, and it can expose *ALL* expert
options, including EMBEDDED and FOOBAR options. Which defaults people want
for those is not in the scope of this patch. However, using EMBEDDED to
fix EXPERT is the best choice for precisely the reason you state

> I think it's fine to break backwards compatibility for options that are
> currently configurable for CONFIG_EXPERT when it only makes sense for
> embedded systems and use CONFIG_EMBEDDED instead.  They better already
> have it enabled and my patch a year ago didn't break it for them.

While EMBEDDED may not be appropriate for all those default changes now,
EXPERT *CERTAINLY* isn't appropriate. Let's fix EXPERT now and then
EMBEDDED later. Anybody who cared about those things was using EMBEDDED
before, let them keep using it now.

