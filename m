Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab2H1RvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 13:51:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957Ab2H1RvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 13:51:08 -0400
Date: Tue, 28 Aug 2012 19:51:01 +0200
From: Jan Kara <jack@suse.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Miller <davem@davemloft.net>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        Dmitry Monakhov <dmonakhov@openvz.org>, Abhijith Das <adas@redhat.com>
Subject: Re: [PATCH] userns: Add basic quota support v2
Message-ID: <20120828175101.GF5146@quack.suse.cz>
References: <87lih2h6i4.fsf@xmission.com>
 <87harqecvk.fsf@xmission.com>
 <20120827085034.GA8998@quack.suse.cz>
 <87wr0j7u3j.fsf_-_@xmission.com>
 <20120828090544.GC5146@quack.suse.cz>
 <87a9xe7wfn.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9xe7wfn.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 28-08-12 10:34:04, Eric W. Biederman wrote:
> Jan Kara <jack@suse.cz> writes:
> >> +		return -EINVAL;
> >> +	ret = sb->s_qcop->get_dqblk(sb, qown, &fdq);
> >>  	if (ret)
> >>  		return ret;
> >>  	copy_to_if_dqblk(&idq, &fdq);
> > ...
> >> +static inline u32 from_qown(struct user_namespace *user_ns, struct qown qown)
> >> +{
> >> +	switch (qown.type) {
> >> +	case USRQUOTA:
> >> +		return from_kuid(user_ns, qown.uid);
> >> +	case GRPQUOTA:
> >> +		return from_kgid(user_ns, qown.gid);
> >> +	case XQM_PRJQUOTA:
> >> +		return (user_ns == &init_user_ns) ? qown.prj : -1;
> >> +	default:
> >> +		BUG();
> >> +	}
> >> +}
> >   I would like a bit more if the function somehow expressed in its name
> > that it returns id. id_from_qown() might be a bit too long given how often
> > it is used. qown2id() would be OK but it would be inconsistent with how
> > names of other functions you've added are formed. So I'm somewhat
> > undecided...
> 
> The qown vs id distinction bothers me a little bit.
> 
> I almost want to name it struct kid, and the functions make_kid,
> from_kid etc.  Where the emphasis is that we are transforming in and out
> of the kernel internal form.  I don't really like make_kid because id as
> a base name seems to generic and it barely tells you it is.  Perhaps
> make_kqid.  Where we call the quota ids and qid for short?
> 
> I am a little uncomfortable calling them kqids because the userspace
> code also places format_ids in a plain qid_t.  But make_kqid and
> from_kqid seems the best alternate set of names I can come up with.
  OK, these would seem reasonable to me.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
