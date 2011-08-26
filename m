Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1HZMuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 08:50:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56636 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab1HZMuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 08:50:19 -0400
MIME-Version: 1.0
In-Reply-To: <1314337927-17210-1-git-send-email-jarkko.sakkinen@intel.com>
References: <1314337927-17210-1-git-send-email-jarkko.sakkinen@intel.com>
Date: Fri, 26 Aug 2011 08:50:17 -0400
Message-ID: <CACLa4pvbaWM8jRJvBW2NvN2OLK8x4wP44pfdUQ9He1fZwWYcfA@mail.gmail.com>
Subject: Re: [PATCH] Smack: SMACK_IOCLOADACCESS
From: Eric Paris <eparis@parisplace.org>
To: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 1:52 AM, Jarkko Sakkinen
<jarkko.sakkinen@intel.com> wrote:
> IOCTL call for /smack/load that takes access rule in
> the same format as they are written into /smack/load.
> Sets errno to zero if access is allowed and to EACCES
> if not.
>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>

[SELinux maintainer here, but Casey knew to already take what I say
with a grain of salt]

I'm not telling you to do anything differently, just telling you what
SELinux does, and why we do it.  SELinux has a file in selinuxfs
called 'access.'  The file can be opened and one can write a rule into
the file.  One then calls read and gets back a structure which
contains all of the permissions information allowed for the
source/target/class.  In SELinux we calculate all of the permissions
for the tuple at once so providing all of the information at once can
make a lot of sense.  libselinux provides libraries that will cache
these decisions in the userspace program and quickly answer the same
(or similar) questions later.

http://userspace.selinuxproject.org/trac/browser/libselinux/src/compute_av.c

Shows the userspace side of out "access" interface.  Your interface is
good in that it only takes 1 syscall and ours takes 2.  Your interface
is bad in that it is ioctl and we are told since birth that we must
hate them no matter what (not that read/write is really any
different).  It isn't the same method the only other LSM I know about
uses.  It can only every return one value (ok, I know ioctl can be
made to do anything at all)

Anyway, just food for thought....

-Eric
