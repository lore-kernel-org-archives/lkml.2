Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab1A1WZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 17:25:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab1A1WZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 17:25:10 -0500
Subject: Re: [PATCH] System Wide Capability Bounding Set
From: Eric Paris <eparis@redhat.com>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: Steve Grubb <sgrubb@redhat.com>, "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Date: Fri, 28 Jan 2011 17:24:52 -0500
In-Reply-To: <20110128193809.GB8854@localhost>
References: <1294266337.3237.45.camel@localhost.localdomain>
	 <201101270942.07689.sgrubb@redhat.com> <20110128184901.GA5134@localhost>
	 <201101281410.29794.sgrubb@redhat.com> <20110128193809.GB8854@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1296253494.2567.35.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 13:38 -0600, Serge E. Hallyn wrote:
> Quoting Steve Grubb (sgrubb@redhat.com):
> > On Friday, January 28, 2011 01:49:01 pm Serge E. Hallyn wrote:
> > > > Using a wrapper program is a NOGO because the admin renting the machine
> > > > would be able  to overwrite the wrapper and then they have arbitrary
> > > > code running with full privs and
> > > 
> > > Not sure I've got this.  Wrapper program in the VM he can over-write,
> > > but then he can overwrite the kernel too.
> > 
> > No, because the kernel is only read in at boot. After that, /boot can disapear and it 
> 
> And you can set it up so userspace cannot remount it, I assume?

Undecided at this time.  There are 2 possibilities.  We will either
expose a small partition to the VM which the hypervisor enforces RO
access which contains the kernel, initrd, and bootloader (so basically
a /boot).  This is what I have been thinking.  Or we may just directly
launch a kernel and initrd from the hypervisor and those files need
never be exposed to the VM at all.  In an case, there will be no
possibility that root in the VM will be able to modify their kernel or
initrd.  The plan is to implement capability restrictions inside the
initrd.

> > > In other words, we have to accept that the TCB is always not just the
> > > kernel, but some user-space too.  And yes, the wrapper program here
> > > would be part of the TCB.

That's correct, the TCB is going to be the kernel+initrd.  We must
accomplish all lockdowns inside the initrd before control is passed to
the root admin.

The helper script idea doesn't appear to meet the goal since the admin
would have control over the complete filesystem namespace and would be
able bypass it altogether (sgrubb mentioned bind mounting on top of it,
even if they couldn't overwrite it)

