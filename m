Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab2HYRkH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 13:40:07 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51393 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2HYRkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 13:40:03 -0400
Date: Sat, 25 Aug 2012 21:39:58 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 1/9] procfs: Move /proc/pid/fd[info] handling code to
 fd.[ch]
Message-ID: <20120825173958.GC19184@moon>
References: <20120823104323.040550004@openvz.org>
 <20120823104725.592602491@openvz.org>
 <20120825171605.GT23464@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120825171605.GT23464@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 06:16:05PM +0100, Al Viro wrote:
> On Thu, Aug 23, 2012 at 02:43:24PM +0400, Cyrill Gorcunov wrote:
> > This patch prepares the ground for further extension of
> > /proc/pid/fd[info] handling code by moving fdinfo handling
> > code into fs/proc/fd.c.
> > 
> > I think such move makes both fs/proc/base.c and fs/proc/fd.c
> > easier to read.
> 
> BTW, looking at the other stuff in fs/proc/base.c, why the hell is
> struct file * grabbed in proc_map_files_readdir()?  All we do with
> it is passing it to proc_fill_cache(), which passes it to
> proc_map_files_instantiate(), which looks at two sodding bits
> in file->f_mode.  Then we go and fput() all those struct file
> references we'd been putting into the array...  What for?

Well, this could be simplified indeed, if I understand you correctly
you propose just save f_mode in flexible array and use it instead
of struct file, right? (which will require to rewrite code a bit)

	Cyrill
