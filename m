Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab1GLQOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 12:14:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36257 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab1GLQOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 12:14:12 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Hans-Peter Jansen" <hpj@urpla.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, hooanon05@yahoo.co.jp
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
	<201107052154.32606.hpj@urpla.net>
	<87box52amy.fsf@tucsk.pomaz.szeredi.hu>
	<201107101316.19014.hpj@urpla.net>
Date: Tue, 12 Jul 2011 18:15:03 +0200
In-Reply-To: <201107101316.19014.hpj@urpla.net> (Hans-Peter Jansen's message
	of "Sun, 10 Jul 2011 13:16:17 +0200")
Message-ID: <877h7n5vco.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Hans-Peter Jansen" <hpj@urpla.net> writes:

> On Friday 08 July 2011, 14:57:09 Miklos Szeredi wrote:
>> Allow using namspace polluting xattr replacements, such as aufs is
>> doing.
>>
>> But why?  Why is it better to do the overlaying on the client instead
>> of the server?
>
> Exporting layered filesystems via NFS suffered from many problems 
> traditionally, because that permuted NFS export issues of the server FS 
> in use (say xfs) with FS layering issues. Since I'm doing diskless 
> computing for more then two decades now, I always persued for lowering 
> complexity, and/or localize it. Layering on the client is done with the 
> latter in mind. While the basic concept of layered FS is sound, 
> especially, things like mmapping and splicing cause hard to track down 
> and problems, that are even harder to solve properly. 
>
> Do you have experiences with NFS exported overlay FSs already? If that 
> proves stable, does scale, and a client is able to survive a server 
> reboot, layering on the server is a sexy approach of course (I hate to 
> being forced to maintain my own kernel flavors for diskless clients, 
> while I love to track the Linux kernel progress in general..).

Well, you are right, exporting an overlay has its own complexities.

Abstracting the whiteout/opaque flags behind an implementation that can
use xattr or plain files sounds pretty easy to do in comparison.  I'll
look into that.  But this is again a feature that needs to go in a
later.

> Does a openSUSE build service kernel project exist with overlayfs 
> included? If I read the patch correctly, it's not possible to just bake 
> overlayfs as a standalone KMP ATM.

No, it needs small VFS modifications, so a standalone module doesn't
work.

Thanks,
Miklos
