Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab0H0ELN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 00:11:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab0H0ELM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 00:11:12 -0400
Date: Fri, 27 Aug 2010 14:11:00 +1000
From: Neil Brown <neilb@suse.de>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, vaurora@redhat.com,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
Subject: Re: [PATCH 2/5] vfs: make i_op->permission take a dentry instead of
 an inode
Message-ID: <20100827141100.45feae88@notabene>
In-Reply-To: <1282854242.16993.6.camel@moss-terrapins.epoch.ncsc.mil>
References: <20100826183340.027591901@szeredi.hu>
	<20100826183501.528625301@szeredi.hu>
	<1282854242.16993.6.camel@moss-terrapins.epoch.ncsc.mil>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 16:24:02 -0400
"David P. Quigley" <dpquigl@tycho.nsa.gov> wrote:

> I may be missing something but I looked at your patch series and I see
> no good reason for this patch at all. You just churned a lot of code for
> something that you don't even have a need for in the patch set. Your
> only two new callers of this function could just as easily have used the
> inode since it isn't doing anything special with the dentry. It actually
> pulls the inode out of it and uses it in generic_permission and
> security_inode_permission. If you are going to change this you should
> also change generic_permission as well. Honestly I'd rather see the
> dentry requirement removed from inode operations instead but
> unfortunately this isn't possible as I found out with my attempts to
> remove the dentry requirement for get/setxattr


union_permission needs the dentry to get access to d_fsdata, which caches the
upperpath and lowerpath which were found at lookup time.

Is that what you missed?

NeilBrown
