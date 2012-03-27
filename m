Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab2C0WqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:46:24 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:47353 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005Ab2C0WqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:46:22 -0400
Date: Tue, 27 Mar 2012 22:46:40 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [rfc] fcntl: Add F_GETOWNER_UIDS option
Message-ID: <20120327224640.GA5328@mail.hallyn.com>
References: <20120326150924.GG19395@moon>
 <20120326164347.GA24394@redhat.com>
 <20120326183330.GM19395@moon>
 <20120327152534.GA18478@redhat.com>
 <20120327165853.GH11875@moon>
 <20120327222923.GA31692@mail.hallyn.com>
 <20120327223420.GB9669@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120327223420.GB9669@moon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Cyrill Gorcunov (gorcunov@openvz.org):
> On Tue, Mar 27, 2012 at 10:29:23PM +0000, Serge E. Hallyn wrote:
> > Quoting Cyrill Gorcunov (gorcunov@openvz.org):
> > > On Tue, Mar 27, 2012 at 05:25:34PM +0200, Oleg Nesterov wrote:
> > > > user_ns_map_uid() should translate uid_t from one namespace to another,
> > > > in this case the namespace is the same.
> > > > 
> > > > user_ns_map_uid(cred->user_ns, cred) must be the identical mapping,
> > > > no matter how we change the implementation.
> > > > 
> > > > What I think you need is
> > > > user_ns_map_uid(current_user_ns(), filp->f_owner.cred), the only
> > > > problem is that f_owner.cred doesn't exist.
> > > > 
> > > 
> > > Hmm, I was confused by likely() in user_ns_map_uid. But indeed, I think
> > > you're so right. Is there some reason why we can't carry f_owner.cred
> > > pointer?
> > 
> > We would need that for this, yes.  However, Eric is working on a new
> > patchset which changes the cross-userns uid mappings.  I think it's
> > worth simply leaving a comment that this will need to be addressed,
> > and leave in the unconverted uid.
> 
> Hi Serge, thanks for info. But if it will be unconverted uid, can't
> be there some security problem with that which I missed?

Noone is really using the user namespaces right now, but rather than
adding the cred (and refcounting concerns), my suggestion for now
would be to hardcode a check in modown() that current_user_ns() ==
&init_user_ns.

I *did* have a patch in the past which added the cred to fown, but
no idea where it is right now...

-serge
