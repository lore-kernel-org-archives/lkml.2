Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab0DTOfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 10:35:55 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59953 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab0DTOfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:35:53 -0400
Date: Tue, 20 Apr 2010 09:35:45 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
Subject: Re: [PATCH 0/3] Taming execve, setuid, and LSMs
Message-ID: <20100420143545.GA19513@us.ibm.com>
References: <cover.1269610458.git.luto@mit.edu>
 <20100419172639.GA15800@us.ibm.com>
 <n2ycb0375e11004191432g855540c0jab7989d75b32200d@mail.gmail.com>
 <20100419213952.GA28494@hallyn.com>
 <1271767039.30027.50.camel@moss-pluto.epoch.ncsc.mil>
 <v2qcb0375e11004200723w776f806elb1be2c3aa30f1671@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <v2qcb0375e11004200723w776f806elb1be2c3aa30f1671@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Lutomirski (luto@mit.edu):
> On Tue, Apr 20, 2010 at 8:37 AM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > On Mon, 2010-04-19 at 16:39 -0500, Serge E. Hallyn wrote:
> >> Quoting Andrew Lutomirski (luto@mit.edu):
> 
> >> > and LSM  transitions.  I
> >> > think this is a terrible idea for two reasons:
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
> >
> 
> True,  but I think it's still asking for trouble -- other LSMs could
> (and almost certainly will, especially the out-of-tree ones) do
> something, and I think that any action at all that an LSM takes in the
> bprm_set_creds hook for a nosuid (or whatever it's called) process is
> wrong or at best misguided.

I could be wrong, but I think the point is that your reasoning is
correct, and that the same reasoning must apply if we're just
executing a file out of an fs which has been mounted with '-o nosuid'.

> Can you think of anything that an LSM should do (or even should be
> able to do) when a nosuid process calls exec, other than denying the
> request outright?  With my patch, LSMs can still reject the open_exec
> call.
> 
> --Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
