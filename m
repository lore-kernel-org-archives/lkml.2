Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935422Ab1ETI5C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:57:02 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59913 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933897Ab1ETI47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=OCFZ30Abr/s7UGKCtQWK8ipOYH+kljOePXrY0MUA+jqqksMKUuyFvDWuZmB5nGWnM6
         1F/PCHuYHkFPITcYXE21Ro9nIuQlhBUKOVmiFfFso9XIslFKaVNos8V5bmpTLa57lWeH
         Vl+Ze/WL25b92tVNpXmX8+ybM+f3zyVdgMbA4=
MIME-Version: 1.0
In-Reply-To: <20110519163709.GH3702@shadowen.org>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu> <20110519163709.GH3702@shadowen.org>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Fri, 20 May 2011 10:56:38 +0200
X-Google-Sender-Auth: Fnld_s5UBDk99ouut3ptIt-Z6SI
Message-ID: <BANLkTikeZmS=xX0hBizwQ49k8uTOQh3BAA@mail.gmail.com>
Subject: Re: [PATCH 0/7] overlay filesystem v9
To: Andy Whitcroft <apw@canonical.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, nbd@openwrt.org, neilb@suse.de,
        jordipujolp@gmail.com, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

On 19 May 2011 18:37, Andy Whitcroft <apw@canonical.com> wrote:
> On Tue, May 17, 2011 at 02:30:45PM +0200, Miklos Szeredi wrote:
>
>> Here's an updated version of the overlay filesystem.
>>
>> Git tree is here:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v9
>
> Ok I pulled this into the Ubuntu kernel and made an Ubuntu Live CD
> for testing.  Overall it worked pretty well, no hangs, no crashes,
> performance seemed reasonable.  We hit one issue with hard links which
> fail to be possible on overlayfs mounts when the Yama LSM (out of tree)
> is enabled.  This module applies more aggressive checks on hard-links
> preventing links to files you cannot read.
>
> The bug seems to be related to the way we handle user and group owners for
> the overlayfs inodes, which we do not initialise (and they remain as 0,0).
> While these ownerships are never exposed to userspace they are exposed
> to the LSM layer, and the LSM module checks the wrong owner and fails
> to allow the links.
>
> From what I can see it is completly reasonable to initialise the ownership
> fields in the overlayfs inode from the underlying inode, or for new files
> ones initialise it in the normal way based on the containing directory.

If the ownership recorded in the inode is not user visible then the
ownership must be taken elsewhere (the lower filesystem?) . Since
deconstructing, modifying and reconstructing the overlay is supported
initializing the inode to some default gives you two possibly
inconsistent ownerships - one seen by LSM, the other by userspace.

So in general LSM should check whatever userspace would I guess.

Thanks

Michal
