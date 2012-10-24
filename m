Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965133Ab2JXHkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 03:40:17 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:57002 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965068Ab2JXHkP (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 24 Oct 2012 03:40:15 -0400
Message-Id: <5087B77A02000078000A3D00@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 24 Oct 2012 08:40:10 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <roger.pau@citrix.com>, "Konrad Rzeszutek Wilk" <konrad@kernel.org>
Cc: "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC] Persistent grant maps for xen blk
 drivers
References: <1350559321-19066-1-git-send-email-roger.pau@citrix.com>
 <20121022134708.GA13832@konrad-lan.dumpdata.com>
 <5086C0C8.5000306@citrix.com> <20121023172008.GB11787@phenom.dumpdata.com>
 <5086DD57.4000206@citrix.com> <20121023185049.GB20350@phenom.dumpdata.com>
In-Reply-To: <20121023185049.GB20350@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 23.10.12 at 20:50, Konrad Rzeszutek Wilk <konrad@kernel.org> wrote:
> On Tue, Oct 23, 2012 at 08:09:27PM +0200, Roger Pau Monné wrote:
>> On 23/10/12 19:20, Konrad Rzeszutek Wilk wrote:
>> >>>> diff --git a/drivers/block/xen-blkback/blkback.c 
> b/drivers/block/xen-blkback/blkback.c
>> >>>> index c6decb9..2b982b2 100644
>> >>>> --- a/drivers/block/xen-blkback/blkback.c
>> >>>> +++ b/drivers/block/xen-blkback/blkback.c
>> >>>> @@ -78,6 +78,7 @@ struct pending_req {
>> >>>>       unsigned short          operation;
>> >>>>       int                     status;
>> >>>>       struct list_head        free_list;
>> >>>> +     unsigned int            unmap_seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
>> 
>> Should I change this to a bool? Since we are only setting it to 0 or 1.
> 
> I would just keep it as 'int'. Eventually we can replace this with a
> bit-map, but that can be done later.

I think this should be a bitmap from the beginning - why would
you want to waste 44 bytes per request for something that fits
in a single unsigned long (and the picture would get worse with
the number-of-segments extension)?

Also - am I taking this work being done here as a silent agreement
to not invest into blkif2 to streamline the various extensions
floating around?

Jan
