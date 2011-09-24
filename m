Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1IXCOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 22:14:25 -0400
Received: from home.kolivas.org ([59.167.196.135]:41088 "EHLO mine.kolivas.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753111Ab1IXCOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 22:14:24 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: BFS cpu scheduler and skip list implementation
Date: Sat, 24 Sep 2011 12:14:21 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.38.4-ck1; KDE/4.6.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201109240945.58879.kernel@kolivas.org> <m28vpeka65.fsf@firstfloor.org>
In-Reply-To: <m28vpeka65.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109241214.21458.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Sep 2011 11:21:06 Andi Kleen wrote:
> Con Kolivas <kernel@kolivas.org> writes:
> > +struct nodeStructure {
> > +	int level;	/* Levels in this structure */
> > +	keyType key;
> > +	valueType value;
> > +	skiplist_node *next[16];
> > +	skiplist_node *prev[16];
> > +};
> 
> That's 128 byte / 2 cache lines, not too bad, but it limits
> the maximum number of tasks that can be efficiently handled
> (my guess to around 64k with maxlevel == 16, but someone may
> correct me on that)

Thanks very much for your informed comments. Do you mean once 64k of tasks are 
queued concurrently, or after 64k of entries have gone in +/- been removed?

Con

-- 
-ck
