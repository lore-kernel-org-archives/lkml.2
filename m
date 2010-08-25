Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0HYXGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 19:06:02 -0400
Received: from smtp-out.google.com ([74.125.121.35]:41989 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab0HYXF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 19:05:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=LaTYCZIHg1KrfTt0MdOftjY5ZVQ5bBBkHOAmvlDaJWJDXnPSH1jx1bOs4pUIYEIaV
	ptb8kWgJbOgVaZiH8eQLQ==
Date: Wed, 25 Aug 2010 16:05:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Peter Zijlstra <peterz@infradead.org>, Dave Chinner <david@fromorbit.com>,
        "Ted Ts'o" <tytso@mit.edu>, Jens Axboe <jaxboe@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Alasdair G Kergon <agk@redhat.com>,
        Chris Mason <chris.mason@oracle.com>,
        Steven Whitehouse <swhiteho@redhat.com>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
In-Reply-To: <alpine.DEB.2.00.1008251630270.25660@router.home>
Message-ID: <alpine.DEB.2.00.1008251604540.31521@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <1282656558.2605.2742.camel@laptop> <4C73CA24.3060707@fusionio.com> <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com> <20100825112433.GB4453@thunk.org>
 <1282736132.2605.3563.camel@laptop> <20100825115709.GD4453@thunk.org> <1282740516.2605.3644.camel@laptop> <20100825132417.GQ31488@dastard> <1282743342.2605.3707.camel@laptop> <alpine.DEB.2.00.1008251347550.16484@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1008251604120.24931@router.home> <alpine.DEB.2.00.1008251418590.20253@chino.kir.corp.google.com> <alpine.DEB.2.00.1008251630270.25660@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010, Christoph Lameter wrote:

> If the higher order fails in slub then an order 0 alloc is attempted
> without __GFP_NORETRY. In both cases the nofail behavior of the page
> allocator determines the outcode.
> 

Right, I thought you said the slab layer passes __GFP_NOFAIL when there's 
no objects available.
