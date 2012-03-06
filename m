Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031183Ab2CFVDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:03:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031067Ab2CFVDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:03:10 -0500
Date: Tue, 6 Mar 2012 22:03:07 +0100
From: Jan Kara <jack@suse.cz>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>,
        viro@ZenIV.linux.org.uk, Wu Fengguang <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: inode->i_wb_list corruption.
Message-ID: <20120306210307.GC8781@quack.suse.cz>
References: <20120306185137.GA15881@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306185137.GA15881@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 06-03-12 13:51:37, Dave Jones wrote:
> We've had three separate reports against 3.2.x recently where the linked list debugging
> is getting tripped up by the prev->next pointer being null instead of pointing
> to the current list entry while walking the i_wb_list
> 
> Call traces are slightly different each time, but all end up walking i_wb_list 
> in dput -> d_kill -> i_put -> evict -> inode_wb_list_del
> 
> What protects that list ? It looks to be just bdi->wb.list_lock ?
> 
> 
> full reports at:
> https://bugzilla.redhat.com/show_bug.cgi?id=784741
> https://bugzilla.redhat.com/show_bug.cgi?id=799229
> https://bugzilla.redhat.com/show_bug.cgi?id=799692
  Hum, interesting! I'd guess this might be caused by f758eeab - adding
Fengguang and Christoph to CC. But I'm really failing to see how this could
happen but interesting thing is that in two of the three cases the files
are on virtual filesystems (once cgroup, once sysfs). These both use
noop_backing_dev_info.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
