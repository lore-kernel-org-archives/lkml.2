Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab2KLSDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 13:03:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:52569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab2KLSDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 13:03:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,764,1344236400"; 
   d="scan'208";a="240820207"
Date: Mon, 12 Nov 2012 10:03:37 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Julius Werner <jwerner@google.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Julius Werner <jwerner@chromium.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH] xhci: fix null-pointer dereference when destroying
 half-built segment rings
Message-ID: <20121112180337.GB6217@xanatos>
References: <20121101175217.GJ29270@xanatos>
 <1351799279-23824-1-git-send-email-jwerner@chromium.org>
 <CAHp75VfqYNMxxDKKvHOVOdtf0+ZkC_N3Zfy0Ahb0nNdG4Xh9xA@mail.gmail.com>
 <20121101201552.GA9472@xanatos>
 <95F2AD07-450E-422C-AB0B-9DFC4734CA1C@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <95F2AD07-450E-422C-AB0B-9DFC4734CA1C@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 01:28:46PM -0700, Julius Werner wrote:
> >> Is it just
> >> for (prev = *first; prev; prev = prev->next)
> >>    xhci_segment_free(xhci, prev);
> >> 
> >> ?
> > 
> > Yeah, that seems cleaner.
> > 
> > Sarah Sharp
> 
> I can submit it that way if you want, but I would advise against it. This way you access the prev pointer after it has been freed already… that's probably not a problem in the current kernel, but it depends on how the underlying memory is managed and is generally just not a good idea in my opinion.

Yep, you're right.  I'll take the second patch you submitted, thanks.

Sarah Sharp
