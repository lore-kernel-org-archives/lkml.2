Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab1GJLQi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 07:16:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61949 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab1GJLQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 07:16:37 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
Date: Sun, 10 Jul 2011 13:16:17 +0200
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, hooanon05@yahoo.co.jp
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu> <201107052154.32606.hpj@urpla.net> <87box52amy.fsf@tucsk.pomaz.szeredi.hu>
In-Reply-To: <87box52amy.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107101316.19014.hpj@urpla.net>
X-Provags-ID: V02:K0:X375DXp9CbmREVBaAm6CB+j/mKfj4uS4QDCvz2k2VEq
 wYvDNhgEcFJTNjoDb5k8xRagghX9og/jEYj4EmxDseaDUB9ztR
 Ubwb0P8ArQfuJN0VxTkWuOM/F+9h2RIJNEIdmAgVxFvy0mxY9y
 nNB4sEoGPi25CRubykOPabLfklRarvHJ0IRe48qFpuUoIzylVO
 GceHfDD8N5zpcsaiT59nEj+2Z+eVRrfaQn28yCZj70=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 July 2011, 14:57:09 Miklos Szeredi wrote:
> "Hans-Peter Jansen" <hpj@urpla.net> writes:
> > All kodos to you, Miklos. While I'm still missing a major feature
> > from overlayfs that is a NFS as upper layer, it provides a fairly
> > good start. A commitment from you, that such an extension is
> > considered for inclusion - given, that it appears one day - is
> > appreciated. Also, since xattr support is available for NFS,
>
> AFAIK development of generic xattr support on NFS stopped some time
> ago.
>
> > it would be nice to outline, what is missing for such an
> > implementation from overlayfs's POV.
>
> Allow using namspace polluting xattr replacements, such as aufs is
> doing.
>
> But why?  Why is it better to do the overlaying on the client instead
> of the server?

Exporting layered filesystems via NFS suffered from many problems 
traditionally, because that permuted NFS export issues of the server FS 
in use (say xfs) with FS layering issues. Since I'm doing diskless 
computing for more then two decades now, I always persued for lowering 
complexity, and/or localize it. Layering on the client is done with the 
latter in mind. While the basic concept of layered FS is sound, 
especially, things like mmapping and splicing cause hard to track down 
and problems, that are even harder to solve properly. 

Do you have experiences with NFS exported overlay FSs already? If that 
proves stable, does scale, and a client is able to survive a server 
reboot, layering on the server is a sexy approach of course (I hate to 
being forced to maintain my own kernel flavors for diskless clients, 
while I love to track the Linux kernel progress in general..).

Does a openSUSE build service kernel project exist with overlayfs 
included? If I read the patch correctly, it's not possible to just bake 
overlayfs as a standalone KMP ATM.

Let's-get-it-in-for-3.1-please'ly yours,
Pete
