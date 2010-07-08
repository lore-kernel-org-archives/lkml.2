Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab0GHPFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 11:05:12 -0400
Received: from mx6.sophos.com ([213.31.172.36]:39107 "EHLO mx6.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab0GHPFK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 11:05:10 -0400
X-Greylist: delayed 607 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2010 11:05:10 EDT
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Greg KH <greg@kroah.com>
Subject: Re: BUG: Securityfs and bind mounts (2.6.34)
Date: Thu, 8 Jul 2010 15:55:01 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
References: <201007081112.41252.tvrtko.ursulin@sophos.com> <20100708144317.GA2364@kroah.com>
In-Reply-To: <20100708144317.GA2364@kroah.com>
MIME-Version: 1.0
Message-ID: <201007081555.01242.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 08/07/2010 15:55:01,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 08/07/2010 15:55:02,
	Serialize complete at 08/07/2010 15:55:02
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 Jul 2010 15:43:17 Greg KH wrote:
> On Thu, Jul 08, 2010 at 11:12:41AM +0100, Tvrtko Ursulin wrote:
> > Hi guys,
> >
> > If I overlay a file in securityfs using mount --bind with a file from
> > a regular filesystem, should I be allowed to rmmod the module which
> > registered the overlaid securityfs file?
>
> Why would you want to overlay securityfs in the first place?

For testing, more precisely faking some data exposed in securityfs module in
order to provoke userspace reaction. It was convenient to leave the majority
of real data and just overlay one file.

> And you might be able to rmmod the module, but I didn't think that
> security modules were able to be unloaded anymore.

Perhaps it is not a security module in the way you think about it, just a
module which happens to register some directories and files under securityfs.

> > I was able to do that, then I
> > unmounted the bind mount, and then when attempting to unmount
> > securityfs hit a BUG at
> > fs/dcache.c:676 (see below). It would have made more sense to first
> > umount the overlay file and then remove the module which registered
> > with securityfs, nevertheless should kernel crash in this case?
>
> Probably not, but then again, you did something that you shouldn't have,
> so perhaps it is telling you not to do such a thing in the future :)

:) Well I do not know, but, it kind of smelled like a bug in the vfs/mount
handling/securityfs area so I thought to let experts know. I _think_ I did
nothing that much wrong. Just used the exposed API (securityfs_remove) and
some bind mount shuffling from userspace.

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
