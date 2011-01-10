Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1AJLZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 06:25:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab1AJLZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 06:25:11 -0500
Date: Mon, 10 Jan 2011 12:25:05 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-lab-213.englab.brq.redhat.com
To: "Ted Ts'o" <tytso@mit.edu>
cc: Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
        sandeen@redhat.com
Subject: Re: [PATCH] ext4: fix possible overflow in ext4_trim_fs()
In-Reply-To: <20101220123521.GH23626@thunk.org>
Message-ID: <alpine.LFD.2.00.1101101221570.3095@dhcp-lab-213.englab.brq.redhat.com>
References: <1290694277-29462-1-git-send-email-lczerner@redhat.com> <20101220123521.GH23626@thunk.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Dec 2010, Ted Ts'o wrote:

> On Thu, Nov 25, 2010 at 03:11:17PM +0100, Lukas Czerner wrote:
> > When determining last group through ext4_get_group_no_and_offset() the
> > result may be wrong in cases when range->start and range-len are too
> > big, because it may overflow when summing up those two numbers.
> > 
> > Fix that by checking range->len and limit its value to
> > ext4_blocks_count(). This commit was tested by myself with expected
> > result.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> Added to the ext4 patch queue.  Thanks for the ping.
> 
>       	     	  		       	   - Ted
> 

Hi Ted,

Actually the patch is not enough, there is still a possibility for
overflow to happen. Jan Kara notice the same bug in ext3 batched discard
implementation. I am sorry for this, I'll sen updated patch ASAP.

-Lukas
