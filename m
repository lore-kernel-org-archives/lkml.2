Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab2A2TgI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 14:36:08 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57002 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab2A2TgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 14:36:06 -0500
Date: Sun, 29 Jan 2012 11:36:01 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
        Suresh Jayaraman <sjayaraman@suse.com>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: Slab corruption in floppy driver module
Message-ID: <20120129193601.GD17211@htj.dyndns.org>
References: <4F1EAFE9.5000306@suse.com>
 <20120124223153.GG17291@redhat.com>
 <20120126150420.GD1891@redhat.com>
 <20120126180532.GA4077@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120126193735.GA11297@redhat.com>
 <giobtq5e46.fsf@mx10.gouders.net>
 <4F223F11.4050307@suse.com>
 <giaa59tmbr.fsf@mx10.gouders.net>
 <20120127195455.GA18068@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127195455.GA18068@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 02:54:55PM -0500, Vivek Goyal wrote:
> floppy: Fix a crash during rmmmod
> 
> floppy driver does not call add_disk() on all the drives hence we don't take
> gendisk reference on request queue for these drives. Don't call put_disk()
> with disk->queue set, otherwise we try to put the reference we never took.
> 
> Reported-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> 
> Signed-off-by: Vivek Goyal<vgoyal@redhat.com>

Ugh... floppy init is ugly.  Thanks for fixing this.

Acked-by: Tejun Heo <tj@kernel.org>

Jens, this one and the previous one are regression fixes and need to
be routed through v3.3-fixes.

-- 
tejun
