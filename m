Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab1JCQiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:38:25 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:65135 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab1JCQiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:38:18 -0400
Date: Mon, 3 Oct 2011 12:37:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [Xen-devel] [PATCH 9/9] xen/p2m/debugfs: Fix potential pointer
 exception.
Message-ID: <20111003163757.GH17108@phenom.oracle.com>
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
 <1317325971-21603-10-git-send-email-konrad.wilk@oracle.com>
 <1317370697.26672.230.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317370697.26672.230.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet24.oracle.com [156.151.31.67]
X-CT-RefId: str=0001.0A090204.4E89E4F6.004F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 09:18:17AM +0100, Ian Campbell wrote:
> On Thu, 2011-09-29 at 20:52 +0100, Konrad Rzeszutek Wilk wrote:
> > We could be referencing the last + 1 element of level_name[]
> > array which would cause a pointer exception.
> 
> If we end up accessing it does that not mean something, i.e. should it
> not be a real string here and not NULL? Otherwise isn't it a bug in the
> lookup code that we end up looking there?

Yup. I altereted it per your recommendation to be "error".

> 
> I think this lookup correspond to the initialisation of lvl=4 and
> falling through the subsequent list of checks without matching one. In
> which case I think level_name[4] should be "unknown" or even "error".

Picked "error"
> 
> I don't think you can hit type_name[4] in the same way, type and
> prev_type are always one of the TYPE_* defines, which have values 0..3
> inclusive. You could make this more obvious and defend against future
> changes breaking this with:
> 	... type_name[] = {
> 		[TYPE_IDENTITY] = "identity",
> 		[TYPE_MISSING] = "missing"
> 		...
> 	};

Oooh, pretty. OK, queued another patch with that.
