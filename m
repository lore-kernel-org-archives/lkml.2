Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab2BVKAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 05:00:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:53681 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2BVKAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 05:00:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: myungjoo.ham@gmail.com
Subject: Re: [PATCH v5 4/5] Extcon: support mutually exclusive relation between cables.
Date: Wed, 22 Feb 2012 10:00:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>
References: <1327021317-10222-1-git-send-email-myungjoo.ham@samsung.com> <20120220022729.GJ3194@opensource.wolfsonmicro.com> <CAJ0PZbTRRsyF4tGSYPagVmZQ495bmduYZ+FfPjn=Kp9hhcmhxQ@mail.gmail.com>
In-Reply-To: <CAJ0PZbTRRsyF4tGSYPagVmZQ495bmduYZ+FfPjn=Kp9hhcmhxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202221000.00810.arnd@arndb.de>
X-Provags-ID: V02:K0:n9AZ0OsKwbMvqK/pCRTqxbXVFTi9NMwVpqFwkagen1t
 kS3CDdb7FaPWEyp4cNk9E29O9PqoODws9VewHfyGHKB5D9HAoB
 k3lnfvoAkM5GqQsCD8UEz3Q+hfph7jdT05wqGyH3GVg6FJWj/m
 iiob0Gl4kpzu7pNRLX6D2Rc3M6lckTq83ONcwlfZDW/a83v2dH
 s8unaiCLQF+iAxR5KAr51QKOURPnmyD62gg7+ICR430A5UD6Ns
 cqr1E2TOT8Vz+WX8sEc3GKYrDB3jzp5jHUE6xvw/abJJP9a0zv
 3iR92NfvX3aQITawHShAMFTv1Dp8fXMB9/LhpWsfCDruLpOvwq
 FBx8dKboYCAprE8tWZNw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 February 2012, MyungJoo Ham wrote:
> 
> On Mon, Feb 20, 2012 at 11:27 AM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > On Fri, Feb 10, 2012 at 03:40:37PM +0900, MyungJoo Ham wrote:
> >
> >> +What:                /sys/class/extcon/.../mutually_exclusive
> >> +Date:                December 2011
> >> +Contact:     MyungJoo Ham <myungjoo.ham@samsung.com>
> >> +Description:
> >> +             Shows the relations of mutually exclusiveness. For example,
> >> +             if the mutually_exclusive array of extcon_dev is
> >> +             {0x3, 0x5, 0xC, 0x0}, the, the output is:
> >> +             # cat mutually_exclusive
> >> +             0x3
> >> +             0x5
> >> +             0xC
> >> +             #
> >
> > sysfs really isn't supposed to have more than one value per file so this
> > should be something like a directory with one array element per file.
> > It'd kind of be cheating but the values could be used as the filenames,
> > though serial numbers would be more idiomatic.
> 
> Hmm.. I'll either use multiple files with a sub-directory or bin-attr
> to inhabit the values. Or I'll search for any other convinient way to
> express such an array thru sysfs.

How about having one file for each cable and list the ones that it
cannot coexist with. In the above example, that would become

mutually_exclusive/0: "0x6"
mutually_exclusive/1: "0x1"
mutually_exclusive/2: "0x9"
mutually_exclusive/3: "0x4"

The information here is a bit redundant, but this would be much easier
to understand for human readers. I also wouldn't mind having a list
of exclusive cable names in each file, while would make it slightly
harder to parse but very easy for humans:

mutually_exclusive/Video-in: "VGA"
mutually_exclusive/Video-out: "VGA"
mutually_exclusive/VGA: "Video-out Video-in"

	Arnd
