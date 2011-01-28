Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab1A1TiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 14:38:20 -0500
Received: from adelie.canonical.com ([91.189.90.139]:41224 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab1A1TiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 14:38:17 -0500
Date: Fri, 28 Jan 2011 13:38:09 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Eric Paris <eparis@redhat.com>, "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] System Wide Capability Bounding Set
Message-ID: <20110128193809.GB8854@localhost>
References: <1294266337.3237.45.camel@localhost.localdomain>
 <201101270942.07689.sgrubb@redhat.com>
 <20110128184901.GA5134@localhost>
 <201101281410.29794.sgrubb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101281410.29794.sgrubb@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Steve Grubb (sgrubb@redhat.com):
> On Friday, January 28, 2011 01:49:01 pm Serge E. Hallyn wrote:
> > > Using a wrapper program is a NOGO because the admin renting the machine
> > > would be able  to overwrite the wrapper and then they have arbitrary
> > > code running with full privs and
> > 
> > Not sure I've got this.  Wrapper program in the VM he can over-write,
> > but then he can overwrite the kernel too.
> 
> No, because the kernel is only read in at boot. After that, /boot can disapear and it 

And you can set it up so userspace cannot remount it, I assume?

> won't matter. It can be replaced with something and that won't matter because that's 
> not the real boot partition.
> 
> > But what we are worried about is the host, so you must mean that.  But if the
> > wrapper program is of type noone_may_write_this_t, then wouldn't finding a way to
> > replace that be as hard as overwriting the host kernel? 
> 
> No, because we aren't taking away the ability to mount or unmount. Not to mention that 
> root can replace his selinux policy so that next boot it doesn't define 
> noone_may_write_this_t. He might even put selinux in his VM in permissive.
> 
> > Which, of course, still remains as a viable attack vector for the guest admin,
> > whether you have this bounding set or not.
> 
> No, with the bounding set, any external call the kernel makes has the bounding set 
> applied. This means we don't have to further restrict root in unnatural ways.
> 
> > In other words, we have to accept that the TCB is always not just the
> > kernel, but some user-space too.  And yes, the wrapper program here
> > would be part of the TCB.
> 
> If you give someone root access in the VM, they probably want to set things up their 
> way. So, we really would like it if all the security mechanism were inside where they 
> can't be easily tampered with.

That's cool  :)

Thanks for the elaboration, that's very interesting and helpful.

-serge
