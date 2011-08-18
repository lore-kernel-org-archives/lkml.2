Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab1HRWYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 18:24:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989Ab1HRWYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 18:24:13 -0400
Date: Thu, 18 Aug 2011 18:24:10 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Oops in minixfs_statfs
Message-ID: <20110818222409.GT2227@zod.bos.redhat.com>
References: <20110816164809.GE2227@zod.bos.redhat.com>
 <20110817021820.GU2203@ZenIV.linux.org.uk>
 <20110817171829.GG2227@zod.bos.redhat.com>
 <20110818211320.GQ2227@zod.bos.redhat.com>
 <20110818211620.GX2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110818211620.GX2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 10:16:20PM +0100, Al Viro wrote:
> On Thu, Aug 18, 2011 at 05:13:21PM -0400, Josh Boyer wrote:
> 
> > +	if (blocks != blocks_needed)
> > +		blocks = blocks_needed;
> 
> ????

Er.. yeah.  That's a left over from before I moved some verification
into fill_super, and then it got simplified to the point of being
utterly stupid.  It's been a long day.

I guess I could either just reassign sbi->s_[iz]map_blocks right then
and truly ignore the extra block, or just always pass the calculated
blocks_needed to count_free.  Which would you prefer?

josh
