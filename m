Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab1AKBaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 20:30:39 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:45101
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754005Ab1AKBae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 20:30:34 -0500
Date: Tue, 11 Jan 2011 01:31:52 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Bastian Blank <bastian@waldi.eu.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <kees.cook@canonical.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 4/7] allow killing tasks in your own or child userns
Message-ID: <20110111013152.GA23860@mail.hallyn.com>
References: <20110110211135.GA22446@mail.hallyn.com>
 <20110110211334.GD22564@mail.hallyn.com>
 <20110110215240.GA21351@wavehammer.waldi.eu.org>
 <20110110225151.GA18944@localhost>
 <20110110232335.GA27029@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110232335.GA27029@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Bastian Blank (bastian@waldi.eu.org):
> On Mon, Jan 10, 2011 at 04:51:51PM -0600, Serge Hallyn wrote:
> > Quoting Bastian Blank (bastian@waldi.eu.org):
> > > Isn't that equal to this?
> > > 
> > > 	if (ns_capable(tcred->user->user_ns, CAP_KILL))
> > > 		return 1;
> > > 
> > > 	if (cred->user->user_ns == tcred->user->user_ns &&
> > > 	    (cred->euid == tcred->suid ||
> > > 	     cred->euid == tcred->uid ||
> > > 	     cred->uid == tcred->suid ||
> > > 	     cred->uid == tcred->uid))
> > > 		return 1;
> > > 
> > > 	return 0;
> > > 
> > > I would consider this much easier to read.
> > 
> > Unfortunately, it's actually not equivalent.  when capable()
> > returns success, then it sets the current->flags |= PF_SUPERPRIV.
> > If permission is granted based on userids and the capability
> > isn't needed, then we don't want to needlessly set PF_SUPERPRIV.
> 
> Well, then switch the two if-clauses.

hup, will do, much nicer, thanks.

> What is this flag used for anyway? I only see it used in the accounting
> stuff, and if every user can get it, it is not longer useful.

hm, I'm not sure...  maybe noone is using it!
