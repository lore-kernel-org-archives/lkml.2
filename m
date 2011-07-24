Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab1GXXv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 19:51:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59078 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab1GXXvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 19:51:55 -0400
Date: Mon, 25 Jul 2011 00:51:54 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdevtmpfs oops since yesterdays vfs merge
Message-ID: <20110724235154.GO24703@ZenIV.linux.org.uk>
References: <20110724231701.GA1707@redhat.com>
 <20110724232812.GN24703@ZenIV.linux.org.uk>
 <20110724234029.GA4881@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724234029.GA4881@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 07:40:29PM -0400, Dave Jones wrote:
> On Mon, Jul 25, 2011 at 12:28:12AM +0100, Al Viro wrote:
>  > On Sun, Jul 24, 2011 at 07:17:01PM -0400, Dave Jones wrote:
>  > > I see an oops in handle_create when I try to boot current tree..
>  > > 
>  > > full trace:
>  > > https://s3.amazonaws.com/twitpic/photos/large/355006460.jpg?AWSAccessKeyId=AKIAJF3XCCKACR3QDMOA&Expires=1311550232&Signature=IIO%2Bya1uEDJzSXTD0DXh2%2BdZpoU%3D
>  > 
>  > Where in handle_create() is that?  At least dump objdump -d of your
>  > devtmpfs.o someplace readable...
> 
> http://codemonkey.org.uk/devtmpfs.s

Smells like req->dev somehow managing to be NULL at that point, but that
doesn't make any sense - we get to devtmpfs_create_node() only from one
place, it sets req.dev to the argument it got from callers and that caller
would have oopsed itself before getting to that call with dev == NULL...

Could you stick a BUG_ON(!dev) in the beginning of handle_create() to see
if that's what somehow manages to happen?
