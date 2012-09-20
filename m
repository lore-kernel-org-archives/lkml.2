Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab2ITIv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 04:51:58 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:32554 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2ITIv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 04:51:56 -0400
X-IronPort-AV: E=Sophos;i="4.80,453,1344211200"; 
   d="scan'208";a="14648494"
Message-ID: <1348131088.24539.2.camel@oliverchick-Precision-WorkStation-T3400>
Subject: Re: [Xen-devel] [PATCH] Persistent grant maps for xen blk drivers
From: Oliver Chick <oliver.chick@citrix.com>
To: Jan Beulich <JBeulich@suse.com>
CC: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 20 Sep 2012 09:51:28 +0100
In-Reply-To: <5059D0C8020000780009C4CF@nat28.tlf.novell.com>
References: <1348051887-21885-1-git-send-email-oliver.chick@citrix.com>
	 <5059D0C8020000780009C4CF@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah yes, you're right - rings can accomodate 64 requests. ijc, and myself
got muddled. It also explains the comment in my summary that we only use
the first 60-ish persistent grants!

With multipage rings, this will probably become a function, rather than
a constant. Does that sound sensible?

On Wed, 2012-09-19 at 13:03 +0100, Jan Beulich wrote:
> >>> On 19.09.12 at 12:51, Oliver Chick <oliver.chick@citrix.com> wrote:
> > +/*
> > + * Maximum number of persistent grants that can be mapped by Dom0 for each
> > + * interface. This is set to be the size of the ring, as this is a limit on
> > + * the number of requests that can be inflight at any one time. 256 imposes
> > + * an overhead of 11MB of mapped kernel space per interface.
> > + */
> > +#define BLKIF_MAX_PERS_REQUESTS_PER_DEV 256
> 
> How can this be a fixed number, especially in the context of ring
> size extensions? Iirc, single page rings can accommodate 64
> requests, so I'd guess the number above was observed with a
> 4-page (order 2) ring...
> 
> Jan
> 


