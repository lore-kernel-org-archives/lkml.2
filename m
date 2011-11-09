Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab1KIOyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 09:54:21 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:49723 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab1KIOyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 09:54:19 -0500
Date: Wed, 9 Nov 2011 09:49:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Paul Durrant <Paul.Durrant@citrix.com>
Cc: "annie.li@oracle.com" <annie.li@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Subject: Re: [PATCH 1/3] Introducing grant table V2 stucture
Message-ID: <20111109144922.GC8410@phenom.dumpdata.com>
References: <4EBA35D3.3020506@oracle.com>
 <1320826490-29362-1-git-send-email-annie.li@oracle.com>
 <291EDFCB1E9E224A99088639C4762022B4543AB1BD@LONPMAILBOX01.citrite.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <291EDFCB1E9E224A99088639C4762022B4543AB1BD@LONPMAILBOX01.citrite.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4EBA9417.013B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 11:11:22AM +0000, Paul Durrant wrote:
> Annie,
> 
>   Comments inline below...
> 
> > -----Original Message-----
> [snip]
> > -static struct grant_entry *shared;
> > +static union {
> > +	struct grant_entry_v1 *v1;
> > +	void *ring_addr;
> > +} shared;
> > +
> 
> 'ring_addr' seems like the wrong name here; how about 'raw'?

Or 'ring'. I asked Annie to change it from 'raw' to something else and the first
thing that came in my mind was 'ring_addr'. But this does not point to a ring, so
the 'ring' part is wrong.

Point here is to make it descriptive. 'raw' does not carry meaning of _what_
it is suppose to do. 
