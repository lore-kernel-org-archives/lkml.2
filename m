Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab2DCQv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 12:51:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846Ab2DCQv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 12:51:27 -0400
Date: Tue, 3 Apr 2012 12:50:55 -0400
From: Dave Jones <davej@redhat.com>
To: David Sterba <dsterba@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org, jeffm@suse.com
Subject: Re: btrfs io errors on 3.4rc1
Message-ID: <20120403165055.GA10975@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Sterba <dsterba@suse.cz>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, jeffm@suse.com
References: <20120402214051.GB2487@redhat.com>
 <20120402222802.GA18000@shiny.nikko.sjc.wayport.net>
 <20120402223350.GA16907@redhat.com>
 <20120402223919.GB18000@shiny.nikko.sjc.wayport.net>
 <20120402225131.GB16907@redhat.com>
 <20120402235021.GA20070@shiny.msi.event>
 <20120403014722.GA618@redhat.com>
 <20120403142607.GA14083@ds.suse.cz>
 <20120403162023.GA7227@redhat.com>
 <20120403163343.GD14083@ds.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120403163343.GD14083@ds.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 06:33:43PM +0200, David Sterba wrote:
 > On Tue, Apr 03, 2012 at 12:20:23PM -0400, Dave Jones wrote:
 > > I see a lot of these ..
 > > 
 > > btrfs: __btrfs_end_transaction -EIO abored=1802201963 (no super error)
 > 
 > 1802201963 == 0x6b6b6b6b
 > 
 > #define POISON_FREE     0x6b    /* for use-after-free poisoning */
 > 
 > hmm

wait, what...

 535         memset(trans, 0, sizeof(*trans));
 536         kmem_cache_free(btrfs_trans_handle_cachep, trans);
 537 
 538         if (throttle)
 539                 btrfs_run_delayed_iputs(root);
 540 
 541         if (trans->aborted ||
 542             root->fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR) {
 543                 return -EIO;
 544         }

that looks like a pretty clear use-after-free.

	Dave

