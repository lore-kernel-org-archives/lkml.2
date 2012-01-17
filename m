Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab2AQTtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:49:33 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:49879 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028Ab2AQTtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:49:32 -0500
X-Greylist: delayed 620 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jan 2012 14:49:32 EST
Date: Tue, 17 Jan 2012 20:39:10 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsprintf: Prevent NULL dereference using %pNF
Message-ID: <20120117193910.GA17092@rere.qmqm.pl>
References: <1326825433.17202.6.camel@joe2Laptop>
 <20120117.134640.1673981737109339596.davem@davemloft.net>
 <1326826273.17202.11.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1326826273.17202.11.camel@joe2Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 10:51:13AM -0800, Joe Perches wrote:
> On Tue, 2012-01-17 at 13:46 -0500, David Miller wrote:
> > From: Joe Perches <joe@perches.com>
> > Date: Tue, 17 Jan 2012 10:37:13 -0800
> > > Passing NULL to %pNF is done in skb_gso_segment
> > > which could be dereferenced.
> > skb_gso_segment() should be fixed instead.
> Maybe.  Dereferencing NULL is bad form.
> Micha³ Miros³aw should fix that as it's his patch.

Will do. This is in WARN() and easily fixed.

> noinline_for_stack should be added anyway.

Why? There are no local variables there and inlining this function would
actually save stack space as no stack frame would be created for the call.

Best Regards,
Micha³ Miros³aw
