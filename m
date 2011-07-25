Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab1GYE7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 00:59:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab1GYE6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 00:58:54 -0400
Date: Mon, 25 Jul 2011 00:58:52 -0400
From: Dave Jones <davej@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdevtmpfs oops since yesterdays vfs merge
Message-ID: <20110725045851.GA11267@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20110724231701.GA1707@redhat.com>
 <20110724232812.GN24703@ZenIV.linux.org.uk>
 <20110724234029.GA4881@redhat.com>
 <20110724235154.GO24703@ZenIV.linux.org.uk>
 <20110725015324.GA7603@redhat.com>
 <20110725015612.GB7603@redhat.com>
 <20110725024444.GP24703@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725024444.GP24703@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 03:44:44AM +0100, Al Viro wrote:

 > > when it triggers the bug_on(), it's that second nodename that is garbage.
 > 
 > Interesting...  The next experiment would be to stick BUG_ON(!req.dev)
 > into devtmpfs_create_node() right after the assigment to that field.

couldn't get that to trigger.

 > We couldn't be hit by the lack of barriers here, could we?  Store to
 > req.dev happens before spin_unlock(&req_lock), so by the time when
 > that request is seen by loop in devtmpfsd() and passed to handle() it
 > should be seen - we have grabbed req_lock, found a pointer to req, dropped
 > req_lock and called handle().  Should've been enough...
 > 
 > Might be interesting to print &req from devtmpfs_create_node(), both on
 > entry and on exit, and print req right before the call of handle()...

Here's latest..

https://s3.amazonaws.com/twitpic/photos/full/355219312.jpg?AWSAccessKeyId=AKIAJF3XCCKACR3QDMOA&Expires=1311570683&Signature=xr3tusulMiV2bIsxux9YNrawUDA%3D
 
apologies for crappy picture, but it's legible at fullsize..

interesting thing here is that the req that causes the oops, I couldn't
find any call to create_handle for that address, so where devtmpfsd got it
is a mystery.  The address is curious too, in that it's way off from all the
reqs created around that time.

I'll add some more printk's to see if I can figure where that's being created.

	Dave

