Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab1LWWee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 17:34:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39334 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab1LWWed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 17:34:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] sunrpc/nfs: don't allow TASK_KILLABLE sleeps to block the freezer
Date: Fri, 23 Dec 2011 23:37:40 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-pm@vger.kernel.org, tj@kernel.org, john@calva.com,
        trond.myklebust@netapp.com, marek.belisko@gmail.com,
        awilliam@redhat.com
References: <1322775223-19115-1-git-send-email-jlayton@redhat.com> <201112012252.13568.rjw@sisk.pl> <20111223081149.7fdbcaa1@tlielax.poochiereds.net>
In-Reply-To: <20111223081149.7fdbcaa1@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112232337.40363.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 23, 2011, Jeff Layton wrote:
> On Thu, 1 Dec 2011 22:52:13 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Thursday, December 01, 2011, Jeff Layton wrote:
> > > Allow the freezer to skip wait_on_bit_killable sleeps in the sunrpc
> > > layer. This should allow suspend and hibernate events to proceed, even
> > > when there are RPC's pending on the wire.
> > > 
> > > Also, wrap the TASK_KILLABLE sleeps in NFS layer in freezer_do_not_count
> > > and freezer_count calls. This allows the freezer to skip tasks that are
> > > sleeping while looping on EJUKEBOX or NFS4ERR_DELAY sorts of errors.
> > > 
> > > Rafael, I've gone ahead and combined the two patches into one here
> > > and rebased this on top of the pm-freezer branch. Let me know if you'd
> > > prefer to keep it as two patches.
> > 
> > One patch is just fine for me, applied to linux-pm/linux-next.
> > 
> > Thanks,
> > Rafael
> > 
> > 
> 
> -------------------[snip]----------------
> 
> > > +
> > > +/* Like schedule_timeout_killable(), but should not block the freezer. */
> > > +#define freezable_schedule_timeout_killable(timeout)			\
> > > +({									\
> > > +	freezer_do_not_count();						\
> > > +	schedule_timeout_killable(timeout);				\
> > > +	freezer_count();						\
> > > +})
> > > +
> 
> 
> Whoops...I just noticed a problem with this patch.
> 
> freezable_schedule_timeout_killable does not return the return code
> from schedule_timeout_killable. Would you prefer for me to respin this
> patch, or send a new patch on top of this one that just fixes that bug?

Please send a new fix patch on top of it.

Thanks,
Rafael
