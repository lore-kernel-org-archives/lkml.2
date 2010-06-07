Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab0FGGxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 02:53:31 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:56972 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab0FGGxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 02:53:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=VpWV56vXO0yqvmLs3BpvbGXdv30v0J8FLOXVHozbKmg0JVmbM1fKnhNineJPK9Qbts
         yuOEYqgkKZoHL0Tl/lNPhiB4HnTm/XI3b3SkfxYfa5nB3DJBIWOKdlk3XuAgphuggI3T
         qCTo068mFZKPzKtDdezLqkSFzBN29lZwkYKCI=
Date: Sun, 6 Jun 2010 23:53:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg Thelen <gthelen@google.com>, Michal Marek <mmarek@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Running make install over sshfs is painful now
Message-ID: <20100607065324.GA25590@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With the following commit running "make modules_install install" over
sshfs (and I suppose nfs) is extremely painful:

commit fb994ecc2b1c214951366c2ba5d8b121f0010d1f
Author: Greg Thelen <gthelen@google.com>
Date:   Wed May 5 10:41:44 2010 -0700

    kbuild: Fix checking of scm-identifier variable
    
    I'm looking Makefile in the -mm branch (dated 2010-04-28-16-53) and
    seeing what looks like a bug in the checking of scm-identifier.  The
    "ifneq ($scm-identifier)" seems to always execute "ifeq
    ($(LOCALVERSION,)) ...".  This patch fixes the checking of
    scm-identifier.
    
    Signed-off-by: Greg Thelen <gthelen@google.com>
    Acked-by: David Rientjes <rientjes@google.com>
    Signed-off-by: Michal Marek <mmarek@suse.cz>

I compile my kernel on my workstation and then mount working tree over
sshfs and install on my laptop over wireless. It worked well for the
last few years but the latest changeset slows this process down to a
crawl - traversing git repository over the network is not the fastest
process out there. Any cfhance we could generate the tag at compile time
as opposed to install time?

Thanks.

-- 
Dmitry
