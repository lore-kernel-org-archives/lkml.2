Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab2KMOko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 09:40:44 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:43648 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab2KMOkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 09:40:42 -0500
Date: Tue, 13 Nov 2012 18:40:36 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 3/7] fs, notify: Add file handle entry into
 inotify_inode_mark
Message-ID: <20121113144036.GI7808@moon>
References: <20121112101440.665694060@openvz.org>
 <alpine.DEB.2.00.1211130016240.18379@chino.kir.corp.google.com>
 <20121113082936.GG6511@moon>
 <2910785.4Vm74eFJyi@deuteros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2910785.4Vm74eFJyi@deuteros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 12:37:23PM +0000, Tvrtko Ursulin wrote:
>> Which would give about 26K of additional memory if c/r get used here.
>>  Not a big number i guess?
> 
> I am pretty sure there are desktop file indexing packages which use
> inotify or fanotify which will put a mark on every single directory within
> users home.
> 
> You probably need to test this with default installs of popular desktop
> environments and realistic home directories.

I'm about to shrink the handle down to 40/64 bytes as being proposed in one
of early review cycles (i'll do that with patch on top), which should minimize
the amount of memory needed (look, it's pretty clear that if the system
uses millions of inotify watchers each inotify mark will need the fhandle here
in c/r sake, i simply see no way at moment how to escape this completely,
but if the c/r is turned off, which is by default, no additional memory
needed).

p.s.: could you please don't use the html formatted messages
