Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab0DUCZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 22:25:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:49751 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab0DUCZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 22:25:48 -0400
Date: Tue, 20 Apr 2010 21:25:46 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
Subject: Re: [PATCH 0/3] Taming execve, setuid, and LSMs
Message-ID: <20100421022546.GA23877@us.ibm.com>
References: <cover.1269610458.git.luto@mit.edu>
 <20100419172639.GA15800@us.ibm.com>
 <n2ycb0375e11004191432g855540c0jab7989d75b32200d@mail.gmail.com>
 <20100419213952.GA28494@hallyn.com>
 <1271767039.30027.50.camel@moss-pluto.epoch.ncsc.mil>
 <v2ocb0375e11004201837ib470c98dj9fea78d2d75799df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <v2ocb0375e11004201837ib470c98dj9fea78d2d75799df@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Lutomirski (luto@mit.edu):
> On Tue, Apr 20, 2010 at 8:37 AM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > On Mon, 2010-04-19 at 16:39 -0500, Serge E. Hallyn wrote:
> >> Quoting Andrew Lutomirski (luto@mit.edu):
> >> >   1. LSM transitions already scare me enough, and if anyone relies on
> >> > them working in concert with setuid, then the mere act of separating
> >> > them might break things, even if the "privileged" (by LSM) app in
> >> > question is well-written.
> >>
> >> hmm...
> >>
> >> A good point.
> >
> > At least in the case of SELinux, context transitions upon execve are
> > already disabled in the nosuid case, and Eric's patch updated the
> > SELinux test accordingly.
> 
> I don't see that code in current -linus, nor do I see where SELinux
> affects dumpability.  What's supposed to happen?  I'm writing a patch
> right now to clean this stuff up.

check out security/selinux/hooks.c:selinux_bprm_set_creds()

	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
		new_tsec->sid = old_tsec->sid;

I assume that's it?

-serge
