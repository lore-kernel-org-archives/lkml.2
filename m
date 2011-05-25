Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab1EYViI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:38:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49094 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab1EYViG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:38:06 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=wom5GMh1gUkA:10 a=MYVtav3ApcgA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=g3F5VGk0NOMZWSIEWMgijA==:17 a=PtDNVHqPAAAA:8 a=Fk3pABn6A3vE_KARLGkA:9 a=K2ifmjo8YF-BvWVY1ocA:7 a=CjuIK1q_8ugA:10 a=wYE_KDyynt4A:10 a=g3F5VGk0NOMZWSIEWMgijA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.123.158.191
Date: Wed, 25 May 2011 16:38:06 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: C Anthony Risinger <anthony@xtfx.me>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Namespace file descriptors for 2.6.40
Message-ID: <20110525213806.GA4590@mail.hallyn.com>
References: <m1wrhh3z62.fsf@fess.ebiederm.org>
 <BANLkTikW4vJbC8kcLSKuemUBbu36SO6hwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikW4vJbC8kcLSKuemUBbu36SO6hwg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting C Anthony Risinger (anthony@xtfx.me):
> On Mon, May 23, 2011 at 4:05 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
> >
> > This tree adds the files /proc/<pid>/ns/net, /proc/<pid>/ns/ipc,
> > /proc/<pid>/ns/uts that can be opened to refer to the namespaces of a
> > process at the time those files are opened, and can be bind mounted to
> > keep the specified namespace alive without a process.
> >
> > This tree adds the setns system call that can be used to change the
> > specified namespace of a process to the namespace specified by a system
> > call.
> 
> i just have a quick question regarding these, apologies if wrong place
> to respond -- i trimmed to lists only.
> 
> if i understand correctly, mount namespaces (for example), allow one
> to build such constructs as "private /tmp" and similar that even
> `root` cannot access ... and there are many reasons `root` does not
> deserve to completely know/interact with user processes (FUSE makes a
> good example ... just because i [user] have SSH access to a machine,
> why should `root`?)
> 
> would these /proc additions break such guarantees?  IOW, would it now
> become possible for `root` to inject stuff into my private namespaces,
> and/or has these guarantees never existed and i am mistaken?  is there
> any kind of ACL mechanism that endows the origin process (or similar)
> with the ability to dictate who can hold and/or interact with these
> references?

If for instance you have a file open in your private /tmp, then root
in another mounts ns can open the file through /proc/$$/fd/N anyway.
If it's a directory, he can now traverse the whole fs.

-serge
