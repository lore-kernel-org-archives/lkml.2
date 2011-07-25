Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab1GYB4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 21:56:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab1GYB4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 21:56:13 -0400
Date: Sun, 24 Jul 2011 21:56:12 -0400
From: Dave Jones <davej@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdevtmpfs oops since yesterdays vfs merge
Message-ID: <20110725015612.GB7603@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20110724231701.GA1707@redhat.com>
 <20110724232812.GN24703@ZenIV.linux.org.uk>
 <20110724234029.GA4881@redhat.com>
 <20110724235154.GO24703@ZenIV.linux.org.uk>
 <20110725015324.GA7603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725015324.GA7603@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 09:53:24PM -0400, Dave Jones wrote:
 > On Mon, Jul 25, 2011 at 12:51:54AM +0100, Al Viro wrote:
 >  > On Sun, Jul 24, 2011 at 07:40:29PM -0400, Dave Jones wrote:
 >  > > On Mon, Jul 25, 2011 at 12:28:12AM +0100, Al Viro wrote:
 >  > >  > On Sun, Jul 24, 2011 at 07:17:01PM -0400, Dave Jones wrote:
 >  > >  > > I see an oops in handle_create when I try to boot current tree..
 >  > >  > > 
 >  > >  > > full trace:
 >  > >  > > https://s3.amazonaws.com/twitpic/photos/large/355006460.jpg?AWSAccessKeyId=AKIAJF3XCCKACR3QDMOA&Expires=1311550232&Signature=IIO%2Bya1uEDJzSXTD0DXh2%2BdZpoU%3D
 >  > >  > 
 >  > >  > Where in handle_create() is that?  At least dump objdump -d of your
 >  > >  > devtmpfs.o someplace readable...
 >  > > 
 >  > > http://codemonkey.org.uk/devtmpfs.s
 >  > 
 >  > Smells like req->dev somehow managing to be NULL at that point, but that
 >  > doesn't make any sense - we get to devtmpfs_create_node() only from one
 >  > place, it sets req.dev to the argument it got from callers and that caller
 >  > would have oopsed itself before getting to that call with dev == NULL...
 >  > 
 >  > Could you stick a BUG_ON(!dev) in the beginning of handle_create() to see
 >  > if that's what somehow manages to happen?
 > 
 > So I built a kernel with this, and then couldn't reproduce it.
 > Made a clean kernel again, and still nothing..  After a number of reboots,
 > it finally triggered again, with that BUG_ON(). fwiw 'nodename' is pointing
 > at garbage when that happens too.
 > 
 > Either it only triggers occasionally, or it's dependent on how quickly
 > I type my luks password in.

one more datapoint. On a succesful boot, I see ..

[    7.760774] dracut: luksOpen /dev/sda2 luks-b5a1fb36-5672-4191-a260-e3f389eb0bb6
[   14.787158] nodename: dm-0
[   15.082391] nodename: dm-0


when it triggers the bug_on(), it's that second nodename that is garbage.

	Dave

