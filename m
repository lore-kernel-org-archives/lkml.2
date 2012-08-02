Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2HBOPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 10:15:24 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390Ab2HBOPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 10:15:22 -0400
Date: Thu, 2 Aug 2012 16:15:12 +0200
From: Richard Weinberger <richard@nod.at>
To: artem.bityutskiy@linux.intel.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, shmulik.ladkani@gmail.com,
        tglx@linutronix.de, tim.bird@am.sony.com, Marius.Mazarel@ugal.ro,
        nyoushchenko@mvista.com
Subject: Re: UBI fastmap updates
Message-ID: <20120802161512.5ac7a303@spider.haslach.nod.at>
In-Reply-To: <1343916747.25013.112.camel@sauron.fi.intel.com>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
	<1343916747.25013.112.camel@sauron.fi.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem,

Am Thu, 02 Aug 2012 17:12:27 +0300
schrieb Artem Bityutskiy <artem.bityutskiy@linux.intel.com>:

> On Mon, 2012-07-09 at 14:18 +0200, Richard Weinberger wrote:
> > This is the next round of UBI fastmap updates.
> > It fixes all issues pointed out by Shmulik. :-)
> 
> I see the following errors when rung UBI tests on nandsim:
> 
> [ 3698.041511] UBI error: __wl_get_peb: no free eraseblocks
> [ 3698.041781] UBI error: ubi_wl_get_fm_peb: no free eraseblocks
> [ 3714.773064] UBI error: __wl_get_peb: no free eraseblocks
> [ 3714.773336] UBI error: ubi_wl_get_fm_peb: no free eraseblocks
> 
> How can this happen? I do not have any bad blocks.
> 
> If I understand correctly, it can be only because of a bug. If I am
> correct, could you please add a 'dump_stack()' to improve the error
> report?
> 

This can happen if all PEBs are used and fastmap is unable to find (or
produce) an empty one.
In this case fastmap takes care that no invalid or outdated fastmap is
on flash.

Thanks,
//richard
