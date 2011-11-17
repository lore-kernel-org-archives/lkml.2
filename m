Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab1KQJue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 04:50:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60875 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab1KQJuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 04:50:32 -0500
Date: Thu, 17 Nov 2011 01:50:21 -0800
From: Joel Becker <jlbec@evilplan.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        Steven Whitehouse <swhiteho@redhat.com>,
        Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [PATCH] ocfs2: send correct UUID to cleancache initialization
Message-ID: <20111117095019.GE7319@noexit.corp.google.com>
Mail-Followup-To: Dan Magenheimer <dan.magenheimer@oracle.com>,
	ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
	Steven Whitehouse <swhiteho@redhat.com>,
	Sunil Mushran <sunil.mushran@oracle.com>
References: <dd238ce4-fe92-4dc0-a4b6-7f273c386366@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd238ce4-fe92-4dc0-a4b6-7f273c386366@default>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 04:47:17PM -0700, Dan Magenheimer wrote:
> ocfs2: Fix cleancache initialization call to correctly pass uuid
> 
> As reported by Steven Whitehouse in https://lkml.org/lkml/2011/5/27/221 
> the ocfs2 volume UUID is incorrectly passed to cleancache.
> As a result, shared-ephemeral tmem pools will not actually
> be created; instead they will be private (unshared) which
> misses out on a major benefit of tmem.
> 
> Reported-by: Steven Whitehouse <swhiteho@redhat.com>
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

	This patch is now in the 'fixes' branch of ocfs2.git.

Joel

> 
> diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
> --- a/fs/ocfs2/super.c
> +++ b/fs/ocfs2/super.c
> @@ -2374,7 +2374,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
>  		mlog_errno(status);
>  		goto bail;
>  	}
> -	cleancache_init_shared_fs((char *)&uuid_net_key, sb);
> +	cleancache_init_shared_fs((char *)&di->id2.i_super.s_uuid, sb);
>  
>  bail:
>  	return status;

-- 

"Well-timed silence hath more eloquence than speech."  
         - Martin Fraquhar Tupper

			http://www.jlbec.org/
			jlbec@evilplan.org
