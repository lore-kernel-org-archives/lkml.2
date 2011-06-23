Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349Ab1FWNjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 09:39:04 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59785 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab1FWNjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 09:39:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EYkQo2VPoomf8QI/3vlMG0y2kvvGUPxv3OmyVpL0FFkLmaYcapdXad4iniKDuuIVic
         KbuOgYvFtDOLZSH2M7s/ZeNhhIy7s/kblcmXu6L4eXhzvJYNkm4q9d+EwBhSo9PQMKyv
         6t8YU6W5nkJ30x/5Y2PT7X+uECddksiStzc70=
Date: Thu, 23 Jun 2011 15:38:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Menage <menage@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 1/4] cgroups: Allow a cgroup subsys to reject a fork
Message-ID: <20110623133855.GB8058@somewhere.redhat.com>
References: <1308527474-20704-1-git-send-email-fweisbec@gmail.com>
 <1308527474-20704-2-git-send-email-fweisbec@gmail.com>
 <BANLkTikVLnMqtaTqjw94qughBvWPcu4yog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikVLnMqtaTqjw94qughBvWPcu4yog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 10:39:04AM -0700, Paul Menage wrote:
> On Sun, Jun 19, 2011 at 4:51 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > Make the cgroup subsystem fork callback return a value
> > so that subsystems are able to accept or reject a fork
> > completion with a custom error value.
> 
> This is unnecessary complexity in the cgroup subsystem (and seems to
> miss cleanup for subsystems that have previously had their fork()
> method return success).

No it seems only the freezer subsystem had this fork callback implemented.
But indeed it adds complexity because if a subsystem can cancel a fork,
then previous subsystems that called ->fork() would need to have a
kind cancel_fork() callback to call.

I haven't looked very deep but the freezer doesn't seem to need any
rollback. Future subsystems using the fork() callback may need it
though.

> If you want a subsystem to be able to reject a fork, I think it's
> better to have that subsystem be called explicitly from do_fork(), and
> keep that logic out of cgroups.

Ok I can do that.
