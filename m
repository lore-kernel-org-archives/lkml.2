Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1CLCKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 21:10:11 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:57871 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab1CLCKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 21:10:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ld3GjQv5WWigg9fTkeseFjBoUUYTMPsmg7LLKMsIScPHDM6VBiygfiKUF2dpEToIR5
         /ZLWqRTRky91Wb73u30BM5EVMAqzjOXiXdYtY7rkK6nGYCKO/Ozy1T1RQd3JNoZekxCS
         oolUdArogfdyFIvYZz4ltYVmdPCCy4lkmlpQE=
Date: Fri, 11 Mar 2011 20:10:01 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Arnd Bergmann <arnd@arndb.de>, Sage Weil <sage@newdream.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org,
        mtk.manpages@gmail.com, viro@zeniv.linux.org.uk, hch@lst.de,
        l@jasper.es
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Message-ID: <20110312021001.GA16833@elie>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
 <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
 <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
 <201103111255.44979.arnd@arndb.de>
 <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
 <20110311235607.GB15853@elie>
 <9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indan Zupancic wrote:

> I'm not pushing for any official convention, just what seems good taste.

In cases like this, conventions (consistency and best practices) are
very important.

> Less code added, less bloat. Architecture independent, no need to update
> all system call tables everywhere (all archs, libc versions and strace).
> Two files changed, instead of 7 (which only hooks up x86).

Thanks for explaining.  Those do seem like good reasons to use a ioctl
instead of a new syscall.

> In this case it's just a performance improvement over sync(2). It doesn't
> add a new feature. Main argument given for the performance problem seems
> to be "NFS can be slow". Anything else?

Huh?  It is not just the speed of the sync --- unnecessary writeback
will cause wear on your thumbdrive, eat up your laptop battery, and
kill I/O performance in other tasks running at the same time.

I'm afraid I don't understand what you're saying here at all.  Would
you say that fsync is superfluous, too?

Jonathan
