Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935121Ab2JYJYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:24:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58356 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934971Ab2JYJY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:24:29 -0400
Date: Thu, 25 Oct 2012 11:24:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add some drop_caches documentation and info messsge
Message-ID: <20121025092424.GA16601@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Dave Hansen <dave@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20121023164546.747e90f6.akpm@linux-foundation.org>
 <20121024062938.GA6119@dhcp22.suse.cz>
 <20121024125439.c17a510e.akpm@linux-foundation.org>
 <50884F63.8030606@linux.vnet.ibm.com>
 <20121024134836.a28d223a.akpm@linux-foundation.org>
 <20121024210600.GA17037@liondog.tnic>
 <50885B2E.5050500@linux.vnet.ibm.com>
 <20121024224817.GB8828@liondog.tnic>
 <5088725B.2090700@linux.vnet.ibm.com>
 <CAHGf_=pfdgoeG5pPJb+UgjqfieU1yxt=46FGW1=th0RbgVKNRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHGf_=pfdgoeG5pPJb+UgjqfieU1yxt=46FGW1=th0RbgVKNRQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 08:56:45PM -0400, KOSAKI Motohiro wrote:
> > That effectively means removing it from the kernel since distros ship
> > with those config options off.  We don't want to do that since there
> > _are_ valid, occasional uses like benchmarking that we want to be
> > consistent.
> 
> Agreed. we don't want to remove valid interface never.

Ok, duly noted.

But let's discuss this a bit further. So, for the benchmarking aspect,
you're either going to have to always require dmesg along with
benchmarking results or /proc/vmstat, depending on where the drop_caches
stats end up.

Is this how you envision it?

And then there are the VM bug cases, where you might not always get
full dmesg from a panicked system. In that case, you'd want the kernel
tainting thing too, so that it at least appears in the oops backtrace.

Although the tainting thing might not be enough - a user could
drop_caches at some point in time and the oops happening much later
could be unrelated but that can't be expressed in taint flags.

So you'd need some sort of a drop_caches counter, I'd guess. Or a last
drop_caches timestamp something.

Am I understanding the intent correctly?

Thanks.

-- 
Regards/Gruss,
    Boris.
