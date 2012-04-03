Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab2DCTgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 15:36:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:25860 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab2DCTgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 15:36:47 -0400
Date: Tue, 3 Apr 2012 15:35:53 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Dave Jones <davej@redhat.com>, David Sterba <dsterba@suse.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org, jeffm@suse.com
Subject: Re: btrfs io errors on 3.4rc1
Message-ID: <20120403193553.GB30032@shiny.us.oracle.com>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Dave Jones <davej@redhat.com>, David Sterba <dsterba@suse.cz>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, jeffm@suse.com
References: <20120402223919.GB18000@shiny.nikko.sjc.wayport.net>
 <20120402225131.GB16907@redhat.com>
 <20120402235021.GA20070@shiny.msi.event>
 <20120403014722.GA618@redhat.com>
 <20120403142607.GA14083@ds.suse.cz>
 <20120403162023.GA7227@redhat.com>
 <20120403163343.GD14083@ds.suse.cz>
 <20120403165055.GA10975@redhat.com>
 <20120403170750.GB10975@redhat.com>
 <20120403171632.GA25334@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120403171632.GA25334@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090207.4F7B511E.008A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 01:16:33PM -0400, Dave Jones wrote:
> On Tue, Apr 03, 2012 at 01:07:50PM -0400, Dave Jones wrote:
> 
>  >  > wait, what...
>  >  > 
>  >  >  535         memset(trans, 0, sizeof(*trans));
>  >  >  536         kmem_cache_free(btrfs_trans_handle_cachep, trans);
>  >  >  537 
>  >  >  538         if (throttle)
>  >  >  539                 btrfs_run_delayed_iputs(root);
>  >  >  540 
>  >  >  541         if (trans->aborted ||
>  >  >  542             root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
>  >  >  543                 return -EIO;
>  >  >  544         }
>  >  > 
>  >  > that looks like a pretty clear use-after-free.
>  > 
>  > Ok, trying this..
> 
> Yep that fixes it.  Chris I'll mail it to you again with a proper sign-off.
> 
> thanks for the help chasing this down David.

Awesome, many thanks guys.

-chris

