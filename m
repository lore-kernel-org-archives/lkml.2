Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab2JIH0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 03:26:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:30091 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070Ab2JIH0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 03:26:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,558,1344236400"; 
   d="scan'208";a="202213116"
Date: Tue, 9 Oct 2012 15:19:59 +0800
From: Feng Tang <feng.tang@intel.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 27/30] ACPI: EC: Add a quirk for CLEVO M720T/M730T
 laptop
Message-ID: <20121009151959.548d8718@feng-i7>
In-Reply-To: <20121009065907.GB3648@elie.Belkin>
References: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
	<67bfa9b60bd689601554526d144b21d529f78a09.1349761836.git.len.brown@intel.com>
	<20121009061633.GA3648@elie.Belkin>
	<20121009142206.63dd9981@feng-i7>
	<20121009065907.GB3648@elie.Belkin>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2012 23:59:07 -0700
Jonathan Nieder <jrnieder@gmail.com> wrote:

> Feng Tang wrote:
> > Jonathan Nieder <jrnieder@gmail.com> wrote:
> 
> >> What would go wrong if the threshold were just increased to 20 on all
> >> models?
> >
> > Then some other platform will stop to work.
> >	https://bugzilla.kernel.org/show_bug.cgi?id=11892 
> >
> > The 26/30 and 27/30 patches are bound together to fix one bug. Some
> > quote from description from the 26th patch:
> >
> > ACPI_EC_STORM_THRESHOLD was initially 20 when it's created, and
> > was changed to 8 in 2.6.28 commit 06cf7d3c7 "ACPI: EC: lower interrupt storm
> > threshold" to fix kernel bug 11892 by forcing the laptop in that bug to
> > work in polling mode.
> >
> > Hope this answers your question.
> 
> Thanks much.  Yes, that clarifies.
> 
> The magic numbers are not too thrilling.  If the polling mode just
> doesn't work on the Clevo M720, why isn't the appropriate storm
> threshold 999999 or infinity rather than 20?  Do we know why the
> polling mode doesn't work?

I don't know why it doesn't work, if you check the https://bugzilla.kernel.org/show_bug.cgi?id=45151 
you'll see the debugging model is
   test result --> patch --> 1-2 weeks + result --> patch
    --> 1-2 weeks + result ...
over and over, which makes it difficult to root cause it but
provide a workaround.

And frankly speaking, I'm not sure if I can figure it out 100%
even if I had that HW at hand. As per my understanding, EC is
very tricky, as OS, ACPI FW, EC FW, BIOS will all access it
without a global lock (in most cases), which makes it hard
to work properly without race condition. Not mentioning its
hardware may be broken.

Thanks,
Feng 
