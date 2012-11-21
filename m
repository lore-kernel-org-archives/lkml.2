Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab2KUTvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 14:51:24 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44970 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab2KUTvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 14:51:22 -0500
Date: Wed, 21 Nov 2012 11:51:15 -0800
From: Joel Becker <jlbec@evilplan.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH RFC 09/12] userns: Convert ocfs2 to use kuid and kgid
 where appropriate
Message-ID: <20121121195114.GM2822@localhost>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	linux-fsdevel@vger.kernel.org,
	Linux Containers <containers@lists.linux-foundation.org>,
	linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
	Mark Fasheh <mfasheh@suse.com>
References: <87pq38wimv.fsf@xmission.com>
 <1353415420-5457-1-git-send-email-ebiederm@xmission.com>
 <1353415420-5457-9-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353415420-5457-9-git-send-email-ebiederm@xmission.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 04:43:37AM -0800, Eric W. Biederman wrote:
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -1116,7 +1116,8 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
>  			    dentry->d_name.len, dentry->d_name.name,
>  			    attr->ia_valid, attr->ia_mode,
> -			    attr->ia_uid, attr->ia_gid);
> +			    from_kuid(&init_user_ns, attr->ia_uid),
> +			    from_kgid(&init_user_ns, attr->ia_gid));

Dear Eric,
	I have a similar question about init_user_ns to Dave.  As far as
I can tell, using init_user_ns here means we'll never get translations
based on the current process namespace.  It just so happens that
include/linux/user_namespace.h doesn't allow new namespaces yet, but I
can't see why we would propagate that knowledge elsewhere.
	Is there some magic about when init_user_ns should be used
regardless?

Joel

-- 

 Brain: I shall pollute the water supply with this DNAdefibuliser,
        turning everyone into mindless slaves.
 Pinky: What about the people who drink bottled water?
 Brain: Pinky, people who pay 5 dollars for a bottle of water are
        already mindless slaves.

			http://www.jlbec.org/
			jlbec@evilplan.org
