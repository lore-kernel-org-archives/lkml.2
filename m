Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab2JIKZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 06:25:26 -0400
Received: from twin.jikos.cz ([89.185.236.188]:46838 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab2JIKZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 06:25:24 -0400
Date: Tue, 9 Oct 2012 12:25:04 +0200
From: David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Ext4 <linux-ext4@vger.kernel.org>,
        viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: Re: [PATCH 1/2 RESEND] vfs: re-implement
 writeback_inodes_sb(_nr)_if_idle() and rename them
Message-ID: <20121009102504.GM4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Miao Xie <miaox@cn.fujitsu.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>,
	viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Kamal Mostafa <kamal@canonical.com>
References: <503DB3E8.1000308@cn.fujitsu.com>
 <20120905155403.GL17430@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905155403.GL17430@twin.jikos.cz>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 05:54:04PM +0200, David Sterba wrote:
> > Many users who use btrfs met the deadlock problem caused by writeback_inodes_sb(_nr)_if_idle(),
> > so I send this patch again and hope it will be received as soon as possible if nobody objects.
> 
> Yes please, this makes testing of the 'autodefrag' mount option hard as
> the deadlock occurs frequently upon umount (when there's a background
> snapshot cleanup in progress).

We have another report of the deadlock and it's without 'autodefrag'
mount, triggered by snapshot cleaning under low space conditions.

I have added the patch to SLES kernel some time ago and haven't observed
the deadlock since.

Please queue the patch for 3.7, we cannot fix it locally within btrfs.

Thanks,
david
