Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313Ab0GVMwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 08:52:16 -0400
Received: from mail1.SerNet.de ([193.175.80.2]:49320 "EHLO mail.SerNet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548Ab0GVMwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 08:52:13 -0400
X-Greylist: delayed 2046 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jul 2010 08:52:13 EDT
Date: Thu, 22 Jul 2010 14:17:50 +0200
Date: Thu, 22 Jul 2010 14:17:50 +0200
From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
To: David Howells <dhowells@redhat.com>
Cc: Jan Engelhardt <jengelh@medozas.de>, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make
 extended file stats available [ver #6]
Reply-To: Volker.Lendecke@SerNet.DE
References: <alpine.LSU.2.01.1007221228260.6115@obet.zrqbmnf.qr>
 <20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
 <20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
 <30448.1279800887@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30448.1279800887@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Message-Id: <E1Obuiy-00C9jr-Al@intern.SerNet.DE>
Organization: SerNet GmbH, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 01:14:47PM +0100, David Howells wrote:
> Jan Engelhardt <jengelh@medozas.de> wrote:
> 
> > Linux already has a creation time field, it's called otime (there is no "b"
> > in "creation"), and you will find scattered fragments of that all over the
> > kernel (foremost, fs/jfs/, now btrfs, and I also notice sysvipc having
> > something with that name).
> 
> It is?  It's called crtime in Ext4.  st_btime, however, would be compatible
> with BSD's stat, and Samba would just use it by way of autoconf magic if it
> appeared.

Samba has the following check:

# recent FreeBSD, NetBSD have creation timestamps called birthtime:             
AC_CHECK_MEMBERS([struct stat.st_birthtimespec.tv_nsec])
AC_CHECK_MEMBERS([struct stat.st_birthtime], AC_CHECK_MEMBERS([struct stat.st_birthtimensec]))

and the supporting code around that. "birth" might also be
where the "b" comes from :-)

Volker
