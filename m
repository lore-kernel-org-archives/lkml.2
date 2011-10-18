Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1JRWON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 18:14:13 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59725 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754416Ab1JRWOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 18:14:11 -0400
Message-ID: <1318976049.2273.7.camel@Joe-Laptop>
Subject: Re: [PATCH 9/9] make net/core/scm.c uid comparisons user namespace
 aware
From: Joe Perches <joe@perches.com>
To: Serge Hallyn <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        akpm@linux-foundation.org, oleg@redhat.com, richard@nod.at,
        mikevs@xs4all.net, segoon@openwall.com, gregkh@suse.de,
        dhowells@redhat.com, eparis@redhat.com,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>, netdev@vger.kernel.org
Date: Tue, 18 Oct 2011 15:14:09 -0700
In-Reply-To: <1318974898-21431-10-git-send-email-serge@hallyn.com>
References: <1318974898-21431-1-git-send-email-serge@hallyn.com>
	 <1318974898-21431-10-git-send-email-serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 21:54 +0000, Serge Hallyn wrote:
> From: "Serge E. Hallyn" <serge.hallyn@canonical.com>

Hi Serge.

Just some trivial style notes.

> Currently uids are compared without regard for the user namespace.
> Fix that to prevent tasks in a different user namespace from
> wrongly matching on SCM_CREDENTIALS.
[]
> diff --git a/net/core/scm.c b/net/core/scm.c

> -static __inline__ int scm_check_creds(struct ucred *creds)
> +static __inline__ bool uidequiv(const struct cred *src, struct ucred *tgt,
> +			       struct user_namespace *ns)

Perhaps inline is better than __inline__ and do these
functions really need to be marked inline at all?

> +{
> +	if (src->user_ns != ns)
> +		goto check_capable;
> +	if (src->uid == tgt->uid || src->euid == tgt->uid ||
> +	    src->suid == tgt->uid)

Perhaps this is less prone to typo errors and are a bit
more readable as:

	if (tgt->uid == src->uid ||
	    tgt->uid == src->euid ||
	    tgt->uid == src->suid)


