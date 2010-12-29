Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab0L2PUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 10:20:36 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:46758 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab0L2PUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 10:20:35 -0500
Date: Wed, 29 Dec 2010 16:19:03 +0100
From: Daniel Kiper <dkiper@net-space.pl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, akpm@linux-foundation.org,
        andi.kleen@intel.com, haicheng.li@linux.intel.com,
        fengguang.wu@intel.com, jeremy@goop.org, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] drivers/xen/balloon.c: Various balloon features and fixes
Message-ID: <20101229151903.GB2743@router-fw-old.local.net-space.pl>
References: <20101220134724.GC6749@router-fw-old.local.net-space.pl> <20101227150847.GA3728@dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101227150847.GA3728@dumpdata.com>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 27, 2010 at 10:08:47AM -0500, Konrad Rzeszutek Wilk wrote:
> On Mon, Dec 20, 2010 at 02:47:24PM +0100, Daniel Kiper wrote:
> > +
> > +		/*
> > +		 * state > 0: hungry,
> > +		 * state == 0: done or nothing to do,
> > +		 * state < 0: error, go to sleep.
>
> Would it be better to just have #defines for this?

Changed to enum. I will send new patch release today.

> > +	balloon_stats.schedule_delay = 1;
> > +	balloon_stats.max_schedule_delay = 32;
>
> How did you arrive at that number?

This is in seconds. Initial delay is 1 s.
It could not be greater than 32 s.
I think that those values are good for
default config because they provide good
resposivnes of balloon process and protect
before CPU exhaust by it during erros.
However, if those values are not acceptable
by user he/she could change them using sysfs.

Daniel
