Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab2GTU6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 16:58:12 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37722 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780Ab2GTU6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 16:58:10 -0400
X-Sasl-enc: PGvIWBEDfQuCh8BJNArVI/PkSkeTVtChn3htlRJmbSz5 1342817889
Date: Fri, 20 Jul 2012 13:58:07 -0700
From: Greg KH <greg@kroah.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Jim Cromie <jim.cromie@gmail.com>, kay@vrfy.com,
        linux-kernel@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH 0/3] dyndbg: dev_dbg bugfix + 2 trivials
Message-ID: <20120720205807.GA23849@kroah.com>
References: <1342727183-4520-1-git-send-email-jim.cromie@gmail.com>
 <20120720203857.GD13835@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120720203857.GD13835@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 04:38:58PM -0400, Jason Baron wrote:
> On Thu, Jul 19, 2012 at 01:46:19PM -0600, Jim Cromie wrote:
> > 3 patches here, 1st is bugfix, others are trivial.
> > 
> > 1- fix __dev_printk, which broke dev_dbg() prefix under CONFIG_DYNAMIC_DEBUG.
> > 
> 
> Patch looks good, and would be really nice to get into 3.5. Kay, are you
> ok with this patch? 

It's too late for 3.5, but I can take it for 3.6-rc1 and backport it to
3.5.1 if needed.

I just need you ack :)

> > 2- change dyndbg prefix interfield separator from ':' to '.'
> > 
> > for example (output from test-code, not submitted):
> > r8169 0000:02:00.0: r8169.rtl_init_one: set-drvdata pdev:ffff880223041000 dev:ffff880220d6a000
> > hwmon hwmon1: k10temp.k10temp_probe.180: set-drvdata pdev:ffff88022303d000 dev:ffff8801dfd2a000
> > 
> > This improves usability of cut -d: <logfile> for pr_debug() messages,
> > as field position is less volatile with various uses of dyndbg flags.
> > Its not perfect:
> > - dev_dbg on net-devices adds several more colons,
> >   but this doesnt vary with dyndbg flags. 
> > - dyndbg=+pfmlt still adds a field vs dyndbg==p (ie no prefix)
> > - pr_fmt() commonly adds another colon (unchanged with this patch)
> 
> As you suggest in the patch, changing the delimiter to a non-colon
> character such as ',' would resolve these cases? 
> 
> >   
> > 3- trivial var name change in lib/dynamic_debug.c
> > 
> > 
> > Please drop or apply 2,3 as you prefer.
> 
> 2,3 are nice, but as you suggest I think we want to separate them from
> patch 1, which is a bugfix for 3.5.

I agree.

thanks,

greg k-h
