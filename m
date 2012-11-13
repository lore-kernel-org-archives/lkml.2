Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab2KMITa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:19:30 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:50217 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab2KMIT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:19:28 -0500
Date: Tue, 13 Nov 2012 00:19:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cyrill Gorcunov <gorcunov@openvz.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 3/7] fs, notify: Add file handle entry into
 inotify_inode_mark
In-Reply-To: <20121113080032.GF6511@moon>
Message-ID: <alpine.DEB.2.00.1211130016240.18379@chino.kir.corp.google.com>
References: <20121112101440.665694060@openvz.org> <20121112101845.839702715@openvz.org> <20121112165540.2ec39f50.akpm@linux-foundation.org> <20121113072057.GC6511@moon> <20121112234001.009b2ae3.akpm@linux-foundation.org> <20121113080032.GF6511@moon>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012, Cyrill Gorcunov wrote:

> > The question is, how many `struct inotify_inode_mark's are instantiated
> > system-wide?  Could be millions?
> 
> Well, hard to tell, to be fair. On my testing machine only apache has been
> using inotify system as far as I remember, but for sure nothing except memory
> limit the number of inotify. But I think if one running machine with millions
> of inotify it's rather powerful machine with enough memory.
> 

Seems easy to determine if you boot with slub_nomerge on the command line 
and then read /sys/kernel/slab/inotify_inode_mark/objects.  On my system, 
that happens to be 210, but I'm sure you could come up with a realistic 
synthetic workload to make it much higher.
