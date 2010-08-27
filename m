Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab0H0Sjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:39:35 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.65.39]:48443 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab0H0Sjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:39:32 -0400
Subject: Re: [PATCH 2/5] vfs: make i_op->permission take a dentry instead
 of an inode
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Neil Brown <neilb@suse.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, vaurora@redhat.com,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
In-Reply-To: <20100827141100.45feae88@notabene>
References: <20100826183340.027591901@szeredi.hu>
	 <20100826183501.528625301@szeredi.hu>
	 <1282854242.16993.6.camel@moss-terrapins.epoch.ncsc.mil>
	 <20100827141100.45feae88@notabene>
Content-Type: text/plain
Date: Fri, 27 Aug 2010 14:31:20 -0400
Message-Id: <1282933880.24418.16.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that your reply to [0/5] has the description that I was asking
for in my last response.

On Fri, 2010-08-27 at 14:11 +1000, Neil Brown wrote:
> On Thu, 26 Aug 2010 16:24:02 -0400
> "David P. Quigley" <dpquigl@tycho.nsa.gov> wrote:
> 
> > I may be missing something but I looked at your patch series and I see
> > no good reason for this patch at all. You just churned a lot of code for
> > something that you don't even have a need for in the patch set. Your
> > only two new callers of this function could just as easily have used the
> > inode since it isn't doing anything special with the dentry. It actually
> > pulls the inode out of it and uses it in generic_permission and
> > security_inode_permission. If you are going to change this you should
> > also change generic_permission as well. Honestly I'd rather see the
> > dentry requirement removed from inode operations instead but
> > unfortunately this isn't possible as I found out with my attempts to
> > remove the dentry requirement for get/setxattr
> 
> 
> union_permission needs the dentry to get access to d_fsdata, which caches the
> upperpath and lowerpath which were found at lookup time.
> 
> Is that what you missed?
> 
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

