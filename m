Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab0HDRkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 13:40:31 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:57679 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab0HDRk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 13:40:27 -0400
Subject: Re: [RFC PATCH 0/5] Btrfs: Add hot data tracking functionality
From: Mingming Cao <cmm@us.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Christian Stroetmann <stroetmann@ontolinux.com>, bchociej@gmail.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20100729121729.GK655@dastard>
References: <1280268023-18408-1-git-send-email-bchociej@gmail.com>
	 <4C4F6DF2.6090905@ontolinux.com> <1280354448.7694.4.camel@mingming-laptop>
	 <20100729121729.GK655@dastard>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 10:40:20 -0700
Message-ID: <1280943620.4676.65.camel@mingming-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-29 at 22:17 +1000, Dave Chinner wrote:
> On Wed, Jul 28, 2010 at 03:00:48PM -0700, Mingming Cao wrote:
> > On Wed, 2010-07-28 at 01:38 +0200, Christian Stroetmann wrote:
> > > At the 28.07.2010 00:00, Ben Chociej wrote:
> > > Wouldn't this feature be useful for other file systems as well, so that 
> > > a more general and not an only Btrfs related solution is preferable?
> > > 
> > 
> > Would certainly nice to add this feature to all filesystem, but right
> > now btrfs is the only fs which have multiple device support in itself.
> 
> Why does it even need multiple devices in the filesystem? All the
> filesystem needs to know is the relative speed of regions of it's
> block address space and to be provided allocation hints. everything
> else is just movement of data. You could keep the speed information
> in the device mapper table and add an interface for filesystems to
> query it, and then you've got infrastructure  that all filesystems
> could hook into.
> 
> The tracking features dont' appear to have anything btrfs specific
> in them, so t iseems wrong to implement it there just because you're
> only looking at btrfs' method of tracking multiple block devices
> and moving blocks....
> 


I agree hot data tracking could be done at vfs layer. The current hot
data temperature calculation and indexing code is very self-contained,
and could be reuse to other fs or move up to vfs. We could define a
common interface to export to hot data tempreture out. The relocation
eventually has to be filesystem specific. btrfs does cow and knows where
is the data on/off SSD directly makes the relocation to and from very
straightforward.

Mingming


