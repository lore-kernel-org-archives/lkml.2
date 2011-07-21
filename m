Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195Ab1GUNkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 09:40:35 -0400
Received: from adelie.canonical.com ([91.189.90.139]:39701 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1GUNkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 09:40:33 -0400
Date: Thu, 21 Jul 2011 08:40:25 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-kernel@vger.kernel.org, Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: 3.0: user namespace problem with capabilities
Message-ID: <20110721134025.GA7353@mail.hallyn.com>
References: <201107211422.23861.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107211422.23861.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Arkadiusz Miskiewicz (a.miskiewicz@gmail.com):
> 
> Hi,
> 
> linux-vserver guys think that there is a problem with user namespace in 
> upcoming 3.0
> 
> "this is a mainline/upstream bug, which basically happens
> when unsharing the USER namespace. what happens is that
> all capabilities are dropped, and as result, the userspace
> tool cannot issue Linux-VServer syscall commands anymore
> (because of missing CAP_CONTEXT)"
> 
> "this can be verified on vanilla linux-3.0 kernels with
> http://vserver.13thfloor.at/Stuff/clone_newuser.c
> in the following way:
> 
> gcc -o clone_newuser clone_newuser.c
> ./clone_newuser ls /root/
> 
> assuming that /root does not have any right for 'other'
> this will result in a permission denied (when the USER
> namespace is compiled into the kernel)"
> 
> Whole post:
> 
> http://list.linux-vserver.org/archive?msp:5151:ekldgndhkgmehnehiegi
> 
> What's maintainers opinion on this?

See http://wiki.ubuntu.com/UserNamespace for details on what's
going on.  See the recent patchset at https://lkml.org/lkml/2011/7/12/377
to see (and help speed up) the next steps.  After that patchset, I
need to address passing userids in siginfos and other uid comparisons,
and then, at least, comes VFS support.  The speed with which it can be
completed depends in part upon my time, and largely on the amount
of time reviewers have.  This stuff is obviously highly critical
security-relevant code, and needs to be very well reviewed and tested
at each step.

(See also http://forum.openvz.org/index.php?t=msg&th=9374&goto=41543&#msg_41543
for the email I sent to containers@, libvirt@, and other lists before
beginning to solicit NACKs in advance)

-serge
