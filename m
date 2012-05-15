Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965289Ab2EOPev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:34:51 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45366 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965021Ab2EOPeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:34:50 -0400
Date: Tue, 15 May 2012 16:37:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] block: add a flag to identify PM request
Message-ID: <20120515163734.332f3e08@pyramind.ukuu.org.uk>
In-Reply-To: <1337095985.3515.1.camel@chief-river-32>
References: <Pine.LNX.4.44L0.1205151028020.1796-100000@iolanthe.rowland.org>
	<1337095985.3515.1.camel@chief-river-32>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012 23:33:05 +0800
Lin Ming <ming.m.lin@intel.com> wrote:

> On Tue, 2012-05-15 at 10:35 -0400, Alan Stern wrote:
> > On Tue, 15 May 2012, Lin Ming wrote:
> > 
> > > Add a flag REQ_PM to identify the request is PM related.
> > > As an example, modify scsi code to use this flag.
> > 
> > There already is such a flag; you don't need to add one.  In fact, 
> > there already are _two_ such flags, and it would be best to remove one 
> > of them.  In include/linux/blkdev.h:
> > 
> > 	REQ_TYPE_PM_SUSPEND,		/* suspend request */
> > 	REQ_TYPE_PM_RESUME,		/* resume request */
> > 
> > Apparently they had been used by the old ide driver, but they don't
> > seem to be used anywhere now.
> 
> IDE code still uses both types and they are used for system
> suspend/resume. See generic_ide_suspend and generic_ide_resume.

drivers/ide is obsolete code though so we shouldn't be forcing its needs
on the future
