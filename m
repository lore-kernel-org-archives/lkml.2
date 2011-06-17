Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405Ab1FQWnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 18:43:13 -0400
Received: from smtp-out.google.com ([74.125.121.67]:27408 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab1FQWnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 18:43:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=sIS416ZyZ/rBdmxGiVtQ3Ae0jLKWJ3sxxZAbcT8WAsmh9TKB78Sf01wrAAhQxUTrSl
         Tr0E0AWwnw60pm8gqskQ==
Date: Fri, 17 Jun 2011 15:43:05 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: should CONFIG_TMPFS_POSIX_ACL be so easily deselectable?
In-Reply-To: <alpine.DEB.2.02.1106171756470.4381@localhost6.localdomain6>
Message-ID: <alpine.LSU.2.00.1106171534530.20805@sister.anvils>
References: <alpine.DEB.2.02.1106171756470.4381@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011, Robert P. J. Day wrote:
> 
>   long story short:  in updating to a slightly newer hand-rolled
> kernel (2.6.39-rc7 -> 3.0.0-rc3) on my ubuntu system, i somehow (no
> idea how) managed to deselect CONFIG_TMPFS_POSIX_ACL without realizing
> it.  the consequences of this were that sound suddenly disappeared
> under the new kernel, for a fairly obvious reason -- ALSA needs ACLs
> under /dev to give R/W access to the user to the device files under
> /dev/snd/.
> 
>   as i said, i have no idea how i managed to do this but i eventually
> tracked it down, re-selected that option, rebuilt and i have sound
> again.  but i noticed that in fs/Kconfig, that option is independently
> selectable from TMPFS, so it's (as i learned) deviously easy to
> deselect, with annoying consequences.
> 
>   more to the point, given the apparent necessity of ACLs under /dev
> for proper sound operation, the help info for that option seems a bit
> misleading:
> 
> config TMPFS_POSIX_ACL
>         bool "Tmpfs POSIX Access Control Lists"
>         depends on TMPFS
>         select TMPFS_XATTR
>         select GENERIC_ACL
>         help
>           ... snip ...
>           If you don't know what Access Control Lists are, say N.
> 
>   yeah, i think that help line might not want to dismiss tmpfs ACLs
> quite so quickly.  thoughts?
> 
> rday
> 
> p.s.  i do notice a fairly recent change to that config file related
> to this:

Yes, we were originally losing the oldconfig value of TMPFS_POSIX_ACL.

It would be easy to ack a patch from you which changes that wording
"If you don't know what Access Control Lists are, say N" to something
more informative about what the sound userspace wants.

It would be harder to justify having SOUND select TMPFS, or changing
the TMPFS_POSIX_ACL default to Y.  It's been N forever, and that is
how we prefer to add features.

Hugh

> 
> commit 4db70f73e56961b9bcdfd0c36c62847a18b7dbb5
> Author: Eric Paris <eparis@redhat.com>
> Date:   Wed May 25 19:49:18 2011 -0700
> 
>     tmpfs: fix XATTR N overriding POSIX_ACL Y
> 
>     Choosing TMPFS_XATTR default N was switching off TMPFS_POSIX_ACL,
>     even if it had been Y in oldconfig; and Linus reports that PulseAudio
>     goes subtly wrong unless it can use ACLs on /dev/shm.
> 
>     Make TMPFS_POSIX_ACL select TMPFS_XATTR (and depend upon TMPFS),
>     and move the TMPFS_POSIX_ACL entry before the TMPFS_XATTR entry,
>     to avoid asking unnecessary questions then ignoring their answers.
> 
> 
> -- 
