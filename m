Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab1LLS2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:28:13 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:59355 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab1LLS2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:28:12 -0500
Date: Mon, 12 Dec 2011 19:28:07 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 6/6] xen/xenbus-backend: Only register
 device if communication ring is local
Message-ID: <20111212182807.GB14966@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
References: <1323541791-18006-1-git-send-email-waldi@debian.org>
 <1323541791-18006-7-git-send-email-waldi@debian.org>
 <20111212154227.GB21558@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111212154227.GB21558@phenom.dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 10:42:27AM -0500, Konrad Rzeszutek Wilk wrote:
> On Sat, Dec 10, 2011 at 07:29:51PM +0100, Bastian Blank wrote:
> > -module_init(xenbus_backend_init);
> > -module_exit(xenbus_backend_exit);
> 
> Why are we removing the module functionality?
> Can't this [the purpose of this patch] be done while still maintaining the module functionality?

Not really. The purpose is to register the device only if the ring is
local. This information is not available to modules.

However we could just move the whole xenbus ring setup into a "module".
Or is there any reason for this to be in a postcore_initcall, even if it
is only operational after a userspace process works?

> >  int xenstored_ready;
> >  
> > +/* A flag to determine if xenstored is 'local' */
> > +#ifdef CONFIG_XEN_BACKEND
> > +static int xenstored_local;
> 
> bool?

Well. The other flags are int also.

> > +			BUG();
> No way. A WARN, sure - but BUG() is way too intense for this.

Okay.

Bastian

-- 
The sight of death frightens them [Earthers].
		-- Kras the Klingon, "Friday's Child", stardate 3497.2
