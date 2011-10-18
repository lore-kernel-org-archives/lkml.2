Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab1JRPLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:11:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932066Ab1JRPLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:11:35 -0400
Date: Tue, 18 Oct 2011 11:10:58 -0400
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Chen, Gong" <gong.chen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "hughd@chromium.org" <hughd@chromium.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH -next] make pstore/kmsg_dump run after stopping
 other cpus in panic path
Message-ID: <20111018151058.GE3452@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C5747DC7B@USINDEVS01.corp.hds.com>
 <20111017164715.e42591d5.akpm@linux-foundation.org>
 <20111018124929.GA3452@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C57565D3A@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C57565D3A@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 10:52:22AM -0400, Seiji Aguchi wrote:
> Hi,
> 
> >> afacit this assumes that (reason == KMSG_DUMP_PANIC) if in_nmi().  Is
> >> that always the case, and will it always be the case in the future?
> >
> 
> Currently, when kernel is in nmi context and kmsg_dump() are called, its reason is always "KMSG_DUMP_PANIC".
> 
> >
> >Perhaps a 'BUG_ON(in_nmi() && reason != KMSG_DUMP_PANIC)'?
> 
> I don't think BUG_ON() is needed.
> 
> If someone would like to log messages in the case of "in_nmi() && reason != KMSG_DUMP_PANIC",
> he/she will add a new trigger as follows.

The point I was trying to make with the BUG_ON is to catch future uses of
NMI and kmsg_dump that were implemented without understanding the
restriction we place (you have to be in a panic path for NMI to use
pstore/kmsg_dump).

That is part of the wider problem with kmsg_dump that Vivek talks about
with me, is that it is just a giant hook in the panic path with limited
auditing.  So we need to explicit set our expectations with BUG_ONs/WARNs
otherwise we might get bit later by them.

Cheers,
Don
