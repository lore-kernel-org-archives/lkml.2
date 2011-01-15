Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab1AOOM3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 09:12:29 -0500
Received: from adelie.canonical.com ([91.189.90.139]:39104 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1AOOM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 09:12:27 -0500
Date: Sat, 15 Jan 2011 08:12:20 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Bastian Blank <bastian@waldi.eu.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 4/7] allow killing tasks in your own or child userns
Message-ID: <20110115141220.GA2252@localhost>
References: <20110110211135.GA22446@mail.hallyn.com>
 <20110110211334.GD22564@mail.hallyn.com>
 <20110110215240.GA21351@wavehammer.waldi.eu.org>
 <20110110225151.GA18944@localhost>
 <20110110232335.GA27029@wavehammer.waldi.eu.org>
 <20110111013152.GA23860@mail.hallyn.com>
 <20110114145001.GB20945@wavehammer.waldi.eu.org>
 <20110115003114.GA24569@mail.hallyn.com>
 <20110115113025.GB18682@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110115113025.GB18682@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Bastian Blank (bastian@waldi.eu.org):
> On Sat, Jan 15, 2011 at 12:31:14AM +0000, Serge E. Hallyn wrote:
> > Quoting Bastian Blank (bastian@waldi.eu.org):
> > > On Tue, Jan 11, 2011 at 01:31:52AM +0000, Serge E. Hallyn wrote:
> > > > Quoting Bastian Blank (bastian@waldi.eu.org):
> > > > > What is this flag used for anyway? I only see it used in the accounting
> > > > > stuff, and if every user can get it, it is not longer useful.
> > > > hm, I'm not sure...  maybe noone is using it!
> > > However with your patches (or at least the goal), everyone is super-user
> > > in derived namespaces.
> > 
> > No, a task just sitting in a derived ns won't necessarily need/use
> > super-user privileges...  (and, if we ever get far enough along, it
> > won't even necessarily have CAP_SYS_ADMIN/etc targeted to the parent
> > userns, bc it won't need those to do the unshares).
> 
> The goal, as I understand it, is that everyone can create derived user
> namespaces. However the creator have automatically all the capabilities
> in the derived namespace.

Yes.  While he is root in that namespace.  But then he can drop
privileges and spawn new tasks, which have no capabilities in any
namespace.

Even if he didn't do that, the PF_SUPERPRIV flag doesn't say that
you have capabilities, but that you used them.  So if I star a task
as root which never does anything but ls /root, then the flag should
not be set.

> So he can use them to gain this super-user
> flag. Even killing a tasks in the derived namespace needs the capability
> already.

-serge
