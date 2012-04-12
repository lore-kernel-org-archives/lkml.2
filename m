Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761894Ab2DLCp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 22:45:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58324 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230Ab2DLCp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 22:45:57 -0400
Date: Thu, 12 Apr 2012 03:45:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kay Sievers <kay@vrfy.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ted Ts'o" <tytso@mit.edu>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Greg Kroah-Hartman <gregkh@linux-foundation.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: RFC: deprecating/removing the legacy mode of devpts
Message-ID: <20120412024548.GK6589@ZenIV.linux.org.uk>
References: <4F80892A.7050104@zytor.com>
 <20120407202056.472d8ad9@pyramind.ukuu.org.uk>
 <da8cd76d-6116-44a9-a7b3-7a501cb3a8a9@email.android.com>
 <20120407212705.GD11295@thunk.org>
 <4F80B9AC.2010103@zytor.com>
 <CAPXgP12Zp7aHev8Sh=3W0zHA-vZoR9TpTW8c7ep9vTQQQScBPg@mail.gmail.com>
 <4F81D254.9090000@zytor.com>
 <CAPXgP10-_kS7VtdWonBhOxKJD2KatB9SznZ_xUUaxBz7-boT2A@mail.gmail.com>
 <20120412010804.GI6589@ZenIV.linux.org.uk>
 <CAPXgP13zqFMTsndaW3YVZEA=aKMGsG-nO+i8k9frmSAzUNyrzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP13zqFMTsndaW3YVZEA=aKMGsG-nO+i8k9frmSAzUNyrzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 04:27:55AM +0200, Kay Sievers wrote:
> On Thu, Apr 12, 2012 at 03:08, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Sun, Apr 08, 2012 at 09:16:22PM +0200, Kay Sievers wrote:
> >
> >> I guess the following:
> >> ?? - remove the 'ptmx' cdev from drivers/tty/pty.c
> >> ?? - add a new devtmpfs_create_link() to drivers/base/devtmpfs.c
> >> ?? - call devtmpfs_create_link() from _init in fs/devpts/inode.c
> >> ?? - change the default of ptxmode=0 to a sane default = 0666
> >> ?? - get rid of the (rather broken) idea of 'legacy' vs 'non-legacy mode'
> >> ?? ?? mount options in the default setup; I don't think userspace should
> >> ?? ?? ever be required to fiddle with such stuff
> >
> > You do realize that there are people with _static_ /dev out there, don't
> > you? ??As well as those of us who are not using your latest and greatest
> > udev and not enabling devtmpfs at all. ??Not all world is Fedora...
> 
> Yeah, and? The dev_t still works from the static /dev/ like it didi 10
> years ago. All good.

Only if you move that cdev to fs/devpts/inode.c instead of removing it,
at which point you get the interesting problems back on other setups...
