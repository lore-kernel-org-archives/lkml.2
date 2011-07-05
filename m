Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab1GETyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:54:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50700 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab1GETyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:54:52 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
Date: Tue, 5 Jul 2011 21:54:30 +0200
User-Agent: KMail/1.9.10
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, mszeredi@suse.cz, hooanon05@yahoo.co.jp
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu> <20110608153208.dc705cda.akpm@linux-foundation.org>
In-Reply-To: <20110608153208.dc705cda.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107052154.32606.hpj@urpla.net>
X-Provags-ID: V02:K0:FERN3KAtBEBOO+shXMREw2lc1Gk+YiwbMzYf0hbikEg
 0HzSLePr8INls+fRRQxYbg87ATguLiZ+y/a1awdVM1XbvTy8hA
 WlI3lH+WI2hIcq2XeP+pCb4twW+C6PhtARZsTfFXN5FYEr2qaa
 lruZIyEXCdXk0falI70qVOt9UVWOMzk/dt/BTgK39n32oSXvlM
 rDLolSjsdjOt8F72hF0idaVDu9x4l0v5FGxWSKsNYQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andrew, dear kernel developers,

I'm sorry for chiming in that late, but I had a motorbike accident that 
resulted in a 3 week stay in a hospital, and I still depend on a 
wheelchair for the next few weeks..

On Thursday 09 June 2011, 00:32:08 Andrew Morton wrote:
> On Wed,  1 Jun 2011 14:46:13 +0200
>
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> > I'd like to ask for overlayfs to be merged into 3.1.

All kodos to you, Miklos. While I'm still missing a major feature from 
overlayfs that is a NFS as upper layer, it provides a fairly good 
start. A commitment from you, that such an extension is considered for 
inclusion - given, that it appears one day - is appreciated. Also, 
since xattr support is available for NFS, it would be nice to outline, 
what is missing for such an implementation from overlayfs's POV.

> Dumb questions:
>
> I've never really understood the need for fs overlaying.  Who wants
> it? What are the use-cases?

I do use it for diskless NFS installations in production environments.
Please note, that this isn't the usual thin client approach, that runs 
on specialized expensive, but dump hardware, and scales bad on the 
server side (you find this setup typically in the medical center next 
door..).

Let's call it fat diskless client approach. I'm up to 3 * 24" heads on 
fairly capable hardware for some clients. Besides the usual office 
stuff, those systems mostly run a VMware based XP setup unfortunately, 
diskless due to its very nature, but at acceptable speed, BTW.

Thanks to aufs, the setup of the linux diskless clients boils down to 
install a distribution into a single folder, add a bit of boot mimic (I 
use pxelinux and kiwi), and get it to mount NFS root with aufs in 
initrd and an empty upper layer. Now you have a simple, but handy 
persistent setup, that can be used from a hundred systems easily.

NFS on switched gigabit ethernet is fast enough (even without playing 
SSD games on the server) to be nearly on eye level with single local 
disks, but the advantage of a single installation instance for all 
clients is paying off manifoldly.

Let me put it this way: administration effort for ONE XP instance (even 
for the emulation driven one) is greater than for ALL linux clients 
combined (although the number of applications used under XP is limited 
to the absolute minimum necessary to get the work done).

Specializing some systems is pretty easy in this setup, backup is a 
piece of cake, and moving systems around is a child's play.

And this is a fairly trivial way of using stacked file systems. There 
are many creative use cases, that are unexploited due to its been 
missing in the standard kernel. People will start using this feature, 
when it is available without additional effort. Want to see, what files  
in what ways an arbitrary application changes? Sure, you can trace it 
down to its bones, or run it on top of a layered filesystem, and 
diff/cmp/whatever the files between the upper and lower FS.

My favorite use case are build farms, where several basic setups for all 
kind of usual distribution versions are maintained as lower layers of 
stackable file systems. The builder checks for typical packages and 
selects the matching layer, e.g. "kernel module", where the layer has 
all kernel-devel packages installed. With similar layers 
for "x11", "kde" and "gnome", I expect a typical build farm to speed up 
by factor 10-20. 

When the first wheels where invented, their use cases where pretty 
limited, but today... Okay, stacked, unioned, layered, or overlayed 
filesystems might not as universally useful as wheels in the end, but I 
bet, that your linux based smartphone will use it by the end of next 
year, if it gets merged in 3.1.

Pete
