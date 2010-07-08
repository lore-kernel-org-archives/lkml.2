Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab0GHQOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 12:14:47 -0400
Received: from mx4.sophos.com ([74.202.89.161]:58070 "EHLO mx4.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758112Ab0GHQOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 12:14:44 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Greg KH <greg@kroah.com>
Subject: Re: BUG: Securityfs and bind mounts (2.6.34)
Date: Thu, 8 Jul 2010 17:14:40 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>
References: <201007081112.41252.tvrtko.ursulin@sophos.com> <201007081632.42069.tvrtko.ursulin@sophos.com> <20100708154648.GA13923@kroah.com>
In-Reply-To: <20100708154648.GA13923@kroah.com>
MIME-Version: 1.0
Message-ID: <201007081714.40724.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 08/07/2010 17:14:41,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 08/07/2010 17:14:41,
	Serialize complete at 08/07/2010 17:14:41
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 Jul 2010 16:46:48 Greg KH wrote:
> On Thu, Jul 08, 2010 at 04:32:42PM +0100, Tvrtko Ursulin wrote:
> > On Thursday 08 Jul 2010 16:20:59 Greg KH wrote:
> > > > :) Well I do not know, but, it kind of smelled like a bug in the
> > > > : vfs/mount
> > > >
> > > > handling/securityfs area so I thought to let experts know. I _think_
> > > > I did nothing that much wrong. Just used the exposed API
> > > > (securityfs_remove) and some bind mount shuffling from userspace.
> > >
> > > securitfs just uses libfs underneath it, and really doesn't have any
> > > bindings for module ownerships, so I wouldn't recommend doing what you
> > > just did.
> >
> > Just do double check what you are saying, securityfs is not safe for use
> > from modules? If so I would then recommend removing the exports otherwise
> > it is an invitation to shoot yourself into the foot.
>
> Hm, did you properly set the module owner of the file_operations that
> you passed to securityfs?  That should protect if you have an open file,

I do not have it set (did not think it is strictly needed for filesystems
(before mention TPM also does not set it)), but I am also pretty sure no one
had a file open there at the time. I will try to repeat the test with it set
and get back to you.

> but I doubt anyone thought you would do crazy things like bind mounts on
> top of a ramfs and then think it was safe to unload a lower module :)
>
> > Also, in-three TPM driver can be built as a module so how does that
> > work?
>
> You have to be root to unload modules, and if you are that, you can do
> worse things than this.

That is beside the point, but I will let you off hook :) until I test the
situation with the owner field set. Thanks for the discussion so far!

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
