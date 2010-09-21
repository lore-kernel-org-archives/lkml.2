Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab0IUPF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 11:05:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749Ab0IUPFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 11:05:25 -0400
Date: Tue, 21 Sep 2010 11:04:26 -0400
From: Jason Baron <jbaron@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Subject: Re: [PATCH 03/10] jump label v11: base patch
Message-ID: <20100921150426.GB2873@redhat.com>
References: <cover.1284733808.git.jbaron@redhat.com> <ee8b3595967989fdaf84e698dc7447d315ce972a.1284733808.git.jbaron@redhat.com> <20100921131232.GA3024@one.firstfloor.org> <20100921143555.GA2873@redhat.com> <0e1f6b339e72a449fed0df7b801da607.squirrel@www.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e1f6b339e72a449fed0df7b801da607.squirrel@www.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 04:41:19PM +0200, Andi Kleen wrote:
> > So there are ~150 tracepoints, but this code is also being proposed for
> > use with 'dynamic debug' of which there are > 1000, and I'm hoping for
> > more users moving forward.
> 
> Even 1000 is fine to walk, but if it was sorted a binary search
> would be much faster anyways. That is then you would still
> need to search for each module, but that is a relatively small
> number (< 100)
> 

yes, but then for each module, I need to again search through the table
to find the correct entires. Although there wouldn't be a 150
tracepoints to search for in each module there are a number of
tracepoints that are used by most modules, such as kmalloc, kfree...plus
any other users of this infrastructure.

> > Also, I think the hash table deals nicely with modules.
> 
> Maybe but it's also a lot of code. And it seems to me
> that it is optimizing the wrong thing. Simpler is nicer.
> 
> -Andi
> 

its right to realize that the enable/disable paths are not at the heart
of this optimization. in fact, the initial few postings of this
patchset, didn't include the hash table, but the added support for
modules lead me to the current design.

thanks,

-Jason
