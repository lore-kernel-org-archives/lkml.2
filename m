Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab2C0WeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:34:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47333 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab2C0WeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:34:24 -0400
Date: Wed, 28 Mar 2012 02:34:20 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [rfc] fcntl: Add F_GETOWNER_UIDS option
Message-ID: <20120327223420.GB9669@moon>
References: <20120326150924.GG19395@moon>
 <20120326164347.GA24394@redhat.com>
 <20120326183330.GM19395@moon>
 <20120327152534.GA18478@redhat.com>
 <20120327165853.GH11875@moon>
 <20120327222923.GA31692@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120327222923.GA31692@mail.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 10:29:23PM +0000, Serge E. Hallyn wrote:
> Quoting Cyrill Gorcunov (gorcunov@openvz.org):
> > On Tue, Mar 27, 2012 at 05:25:34PM +0200, Oleg Nesterov wrote:
> > > user_ns_map_uid() should translate uid_t from one namespace to another,
> > > in this case the namespace is the same.
> > > 
> > > user_ns_map_uid(cred->user_ns, cred) must be the identical mapping,
> > > no matter how we change the implementation.
> > > 
> > > What I think you need is
> > > user_ns_map_uid(current_user_ns(), filp->f_owner.cred), the only
> > > problem is that f_owner.cred doesn't exist.
> > > 
> > 
> > Hmm, I was confused by likely() in user_ns_map_uid. But indeed, I think
> > you're so right. Is there some reason why we can't carry f_owner.cred
> > pointer?
> 
> We would need that for this, yes.  However, Eric is working on a new
> patchset which changes the cross-userns uid mappings.  I think it's
> worth simply leaving a comment that this will need to be addressed,
> and leave in the unconverted uid.

Hi Serge, thanks for info. But if it will be unconverted uid, can't
be there some security problem with that which I missed?

	Cyrill
