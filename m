Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab2HZINr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 04:13:47 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46864 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059Ab2HZINj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 04:13:39 -0400
Date: Sun, 26 Aug 2012 12:13:34 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 2/9] procfs: Convert /proc/pid/fdinfo/ handling routines
 to seq-file v2
Message-ID: <20120826081334.GA7428@moon>
References: <20120823104323.040550004@openvz.org>
 <20120823104725.686586462@openvz.org>
 <20120826024653.GY23464@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120826024653.GY23464@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 03:46:53AM +0100, Al Viro wrote:
> On Thu, Aug 23, 2012 at 02:43:25PM +0400, Cyrill Gorcunov wrote:
> > This patch converts /proc/pid/fdinfo/ handling routines to seq-file which
> > is needed to extend seq operations and plug in auxiliary fdinfo provides
> > from subsystems like eventfd/eventpoll/fsnotify.
> > 
> > Note the proc_fd_link no longer call for proc_fd_info, simply because
> > proc_fd_info is converted to seq_fdinfo_open (which is seq-file open()
> > prototype).
> 
> Actually, now that I've looked at it a bit more...  You've just introduced
> an ABI change here.  Look:

Crap, ineed. Thanks, Al! I'll fix it up, sorry.

...

> IMO doing that at open() time is just a headache for no good reason -
> resolving descriptor to struct file * at read() time as we do now
> is much saner.  Better do that in your ->show(), since you are using
> a single-shot iterator anyway...

Oh, thanks for the hint, Al! I'll rework and send an updated version.

	Cyrill
