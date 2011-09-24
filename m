Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab1IXHf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 03:35:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38523 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1IXHfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 03:35:25 -0400
Date: Sat, 24 Sep 2011 09:35:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Con Kolivas <kernel@kolivas.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS cpu scheduler and skip list implementation
Message-ID: <20110924073522.GV7761@one.firstfloor.org>
References: <201109240945.58879.kernel@kolivas.org> <m28vpeka65.fsf@firstfloor.org> <201109241214.21458.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109241214.21458.kernel@kolivas.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 24, 2011 at 12:14:21PM +1000, Con Kolivas wrote:
> On Sat, 24 Sep 2011 11:21:06 Andi Kleen wrote:
> > Con Kolivas <kernel@kolivas.org> writes:
> > > +struct nodeStructure {
> > > +	int level;	/* Levels in this structure */
> > > +	keyType key;
> > > +	valueType value;
> > > +	skiplist_node *next[16];
> > > +	skiplist_node *prev[16];
> > > +};
> > 
> > That's 128 byte / 2 cache lines, not too bad, but it limits
> > the maximum number of tasks that can be efficiently handled
> > (my guess to around 64k with maxlevel == 16, but someone may
> > correct me on that)
> 
> Thanks very much for your informed comments. Do you mean once 64k of tasks are 
> queued concurrently, or after 64k of entries have gone in +/- been removed?

queued concurrently I believe.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
