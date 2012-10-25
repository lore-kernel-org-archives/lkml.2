Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040Ab2JYMmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 08:42:05 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:45506 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756900Ab2JYMmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 08:42:04 -0400
Date: Thu, 25 Oct 2012 08:40:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: roger.pau@citrix.com, Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC] Persistent grant maps for xen blk drivers
Message-ID: <20121025124013.GB25640@localhost.localdomain>
References: <1350559321-19066-1-git-send-email-roger.pau@citrix.com>
 <20121022134708.GA13832@konrad-lan.dumpdata.com>
 <5086C0C8.5000306@citrix.com>
 <20121023172008.GB11787@phenom.dumpdata.com>
 <5086DD57.4000206@citrix.com>
 <20121023185049.GB20350@phenom.dumpdata.com>
 <5087B77A02000078000A3D00@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5087B77A02000078000A3D00@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 08:40:10AM +0100, Jan Beulich wrote:
> >>> On 23.10.12 at 20:50, Konrad Rzeszutek Wilk <konrad@kernel.org> wrote:
> > On Tue, Oct 23, 2012 at 08:09:27PM +0200, Roger Pau Monné wrote:
> >> On 23/10/12 19:20, Konrad Rzeszutek Wilk wrote:
> >> >>>> diff --git a/drivers/block/xen-blkback/blkback.c 
> > b/drivers/block/xen-blkback/blkback.c
> >> >>>> index c6decb9..2b982b2 100644
> >> >>>> --- a/drivers/block/xen-blkback/blkback.c
> >> >>>> +++ b/drivers/block/xen-blkback/blkback.c
> >> >>>> @@ -78,6 +78,7 @@ struct pending_req {
> >> >>>>       unsigned short          operation;
> >> >>>>       int                     status;
> >> >>>>       struct list_head        free_list;
> >> >>>> +     unsigned int            unmap_seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
> >> 
> >> Should I change this to a bool? Since we are only setting it to 0 or 1.
> > 
> > I would just keep it as 'int'. Eventually we can replace this with a
> > bit-map, but that can be done later.
> 
> I think this should be a bitmap from the beginning - why would
> you want to waste 44 bytes per request for something that fits
> in a single unsigned long (and the picture would get worse with
> the number-of-segments extension)?
> 
> Also - am I taking this work being done here as a silent agreement
> to not invest into blkif2 to streamline the various extensions
> floating around?

I haven't been able (time-wise) to look at making blkif2 a possibility
and I don't want to hinder this work - which provides great
performance benefits.
