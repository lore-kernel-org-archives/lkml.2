Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0DSWZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 18:25:18 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:49926 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab0DSWZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 18:25:15 -0400
Date: Mon, 19 Apr 2010 17:25:13 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
Subject: Re: [PATCH 0/3] Taming execve, setuid, and LSMs
Message-ID: <20100419222513.GA25851@us.ibm.com>
References: <cover.1269610458.git.luto@mit.edu>
 <20100419172639.GA15800@us.ibm.com>
 <n2ycb0375e11004191432g855540c0jab7989d75b32200d@mail.gmail.com>
 <20100419213952.GA28494@hallyn.com>
 <g2xcb0375e11004191502h7ab186d2nc692ff749a4a2c99@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <g2xcb0375e11004191502h7ab186d2nc692ff749a4a2c99@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Lutomirski (luto@mit.edu):
> On Mon, Apr 19, 2010 at 5:39 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> > Quoting Andrew Lutomirski (luto@mit.edu):
> >> >
> >> > ( I did like using new securebits as in [2], but I prefer the
> >> > automatic not-raising-privs of [1] to simply -EPERM on uid/gid
> >> > change and lack kof checking for privs raising of [2]. )
> >> >
> >> > Really the trick will be finding a balance to satisfy those wanting
> >> > this as a separate LSM, without traipsing into LSM stacking territory.
> >>
> >> I think that making this an LSM is absurd.  Containers (and anything
> >> else people want to do with namespaces or with other new features that
> >> interact badly with setuid) are features that people should be able to
> >
> > Yes, but that's a reason to aim for targeted caps.  Exec_nopriv or
> > whatever is more a sandbox than a namespace feature.
> >
> >> use easily, and system's choice of LSM shouldn't have anything to do
> >> with them.  Not to mention that we're trying to *add* rights (e.g.
> >> unprivileged unshare), and LSM is about *removing* rights.
> 
> Is a targeted cap something like "process A can call setdomainname,
> but only on one particular UTS namespace?"

Right, only to the UTS ns in which you live.  See for instance
http://thread.gmane.org/gmane.linux.kernel.containers/15934 .  It's
how we express for instance that root in a child user_namespace has
CAP_DAC_OVERRIDE over files in the container, but not over the host.

-serge
