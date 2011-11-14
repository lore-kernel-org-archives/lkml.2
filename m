Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab1KNOkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 09:40:42 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:53025 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752159Ab1KNOkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 09:40:41 -0500
Message-ID: <1321281640.2004.6.camel@Joe-Laptop>
Subject: Re: Printk mulitple line message support
From: Joe Perches <joe@perches.com>
To: Huang Ying <ying.huang@intel.com>
Cc: William Douglas <william.r.douglas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 Nov 2011 06:40:40 -0800
In-Reply-To: <1321253936.13860.35.camel@yhuang-dev>
References: <1321253936.13860.35.camel@yhuang-dev>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-14 at 14:58 +0800, Huang Ying wrote:
> Hi,
> 
> In most cases, printk only guarantees messages from different printk
> calling will not be interleaved between each other.  But many printk
> users uses multiple line to form a complete message and call printk
> for each line.  So the following situation is possible for two printk
> users running on two CPUs.
> 
> line 1 of message from printk user1
> line 1 of message from printk user2
> line 2 of message from printk user1
> line 2 of message from printk user2
> 
> This makes kernel log hard to read.  One possible solution to this
> issue is to give a sequence number (or ID) to each complete message.
> So the above lines will be:
> 
> {1}line 1 of message from printk user1
> {2}line 1 of message from printk user2
> {1}line 2 of message from printk user1
> {2}line 2 of message from printk user2
> 
> Then some simple script can be used to group lines together according
> to sequence number in lines.
> 
> What do you think about that?

This makes the typical multi-part but non-interleaved
output difficult to read.

How about determining if there is interleaving and
emitting sequence # only in those cases?

Perhaps test the atomic for the last sequence #.


