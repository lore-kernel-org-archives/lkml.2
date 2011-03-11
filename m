Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1CKSXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 13:23:36 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:45591 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752949Ab1CKSXc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 13:23:32 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=XNiEJYwymIperRmJ1tB2GP1d+EhhCzwD4a7zinps/zsuoiKcauJF33sduYAJJheaRdcPv/ej4/ch9w61yCHOm9uPlzAKdPPSasbam/0xZ1pKbCHfkC+ruZV+8pCIJ/jZ;
Date: Fri, 11 Mar 2011 10:23:28 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Paul Menage <menage@google.com>
Cc: Eric B Munson <emunson@mgebm.net>, linux-doc@vger.kernel.org,
        containers@lists.linux-foundation.org, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org, kirill@shutemov.name, mike@librato.com
Subject: Re: [PATCH V2] Documentation: cgroups: Add notes on removing PIDs
 from tasks and cgroups requiring setup
Message-Id: <20110311102328.19aa7c32.rdunlap@xenotime.net>
In-Reply-To: <AANLkTimRDfqm4wCRP1rw8FVbY81=by+V8p5jVEhCLL2G@mail.gmail.com>
References: <1299776862-6931-1-git-send-email-emunson@mgebm.net>
	<AANLkTimRDfqm4wCRP1rw8FVbY81=by+V8p5jVEhCLL2G@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011 19:00:09 -0800 Paul Menage wrote:

> On Thu, Mar 10, 2011 at 9:07 AM, Eric B Munson <emunson@mgebm.net> wrote:
> > The cgroup documentation does not specify how a process can be removed from a
> > particular group.  This patch adds a note at the end of the simple example
> > about how this is done.  Also, some cgroups (like cpusets) require user input
> > before a new group can be used.  This is noted in the patch as well.
> >
> > Signed-off-by: Eric B Munson <emunson@mgebm.net>
> 
> Acked-by: Paul Menage <menage@google.com>

Applied to my documentation patch queue.  Thanks.


> > ---
> > Changes from V1:
> >  Rework the note about removing a process from a cgroup
> >  Add note about ns cgroup causing failure when moving processes between groups
> >
> >  Documentation/cgroups/cgroups.txt |   12 ++++++++++++
> >  1 files changed, 12 insertions(+), 0 deletions(-)
> >
> > diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
> > index 44b8b7a..cbdfb7d 100644
> > --- a/Documentation/cgroups/cgroups.txt
> > +++ b/Documentation/cgroups/cgroups.txt
> > @@ -349,6 +349,10 @@ To mount a cgroup hierarchy with all available subsystems, type:
> >  The "xxx" is not interpreted by the cgroup code, but will appear in
> >  /proc/mounts so may be any useful identifying string that you like.
> >
> > +Note: Some subsystems do not work without some user input first.  For instance,
> > +if cpusets are enabled the user will have to populate the cpus and mems files
> > +for each new cgroup created before that group can be used.
> > +
> >  To mount a cgroup hierarchy with just the cpuset and memory
> >  subsystems, type:
> >  # mount -t cgroup -o cpuset,memory hier1 /dev/cgroup
> > @@ -426,6 +430,14 @@ You can attach the current shell task by echoing 0:
> >
> >  # echo 0 > tasks
> >
> > +Note: Since every task is always a member of exactly one cgroup in each
> > +mounted hierarchy, to remove a task from its current cgroup you must
> > +move it into a new cgroup (possibly the root cgroup) by writing to the
> > +new cgroup's tasks file.
> > +
> > +Note: If the ns cgroup is active, moving a process to another cgroup can
> > +fail.
> > +
> >  2.3 Mounting hierarchies by name
> >  --------------------------------
> >
> > --
> > 1.7.1


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
