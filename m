Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab0IVVHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 17:07:35 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:63632 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751678Ab0IVVHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 17:07:34 -0400
Subject: Re: [PATCH] drm/sysfs: Provide per connector control of DRM KMS
 polling
From: Andy Walls <awalls@md.metrocast.net>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Alex Deucher <alexdeucher@gmail.com>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Dave Airlie <airlied@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <AANLkTi=2E4LqbFKd6fq+dn3q+fau1Zt+-4nuigv7VA45@mail.gmail.com>
References: <1284987540.2242.29.camel@morgan.silverblock.net>
	 <AANLkTikj4biBS7wQsRM6o3kEmyaPNMaSUBEktMmmOy89@mail.gmail.com>
	 <1285023750.30856.99.camel@morgan.silverblock.net>
	 <AANLkTi=RCJcQMSWMm6pQgJnJZT9TyfGyFtWmeu8GKHA-@mail.gmail.com>
	 <1285090202.19131.77.camel@morgan.silverblock.net>
	 <AANLkTi=h=9mvdLMcZZAtg3_eu7wD2Yj0Dn2iWjhF7BiL@mail.gmail.com>
	 <AANLkTi=2E4LqbFKd6fq+dn3q+fau1Zt+-4nuigv7VA45@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 17:07:25 -0400
Message-ID: <1285189645.14364.55.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-22_10:2010-09-22,2010-09-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1009220198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 09:33 -0400, Jon Smirl wrote:
> On Wed, Sep 22, 2010 at 1:30 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
> > On Tue, Sep 21, 2010 at 1:30 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> >> On Tue, 2010-09-21 at 00:26 -0400, Alex Deucher wrote:
> >>> 2010/9/20 Andy Walls <awalls@md.metrocast.net>:
> >>> > On Mon, 2010-09-20 at 20:29 +0200, Rafał Miłecki wrote:
> >>> >> 2010/9/20 Andy Walls <awalls@md.metrocast.net>:

> >> The real problem to me is that the radeon and drm modules have a single,
> >> standard way of dealing with EDID errors.  However, EDID errors can
> >> happen due to a number of different causes, some of which are external
> >> (i.e. in the LCD or CRT monitor).  Given that, there really is no "right
> >> thing" the drivers can do without input from the user on what the policy
> >> should be when a bad EDID is detected.
> 
> Andy, this sure looks like a broken VBIOS to me.

Well sure.

But that problem causes other problems in error handling code paths to
surface.  It also brings to light that there are some cases that are
undecidable, or not worth the effort, for the error handling code paths
on what the proper action should be.


>  First thing would be
> to update your VBIOS if possible to get a correct table for your
> hardware.

Um, no.

I will not risk taking an operational machine down due to flash write
failure, however small the probability, due to the high impact.
The reward of shutting up kernel error messages, is not worth the risk.


>  Second would be to add a quirk in the kernel.

I have expressed my thoughts on quirks in a previous post.


> There are lots of cases where the kernel does odd things when the BIOS
> feeds it bad information. Do we really want hundreds of switches in
> sysfs allowing adjustments for broken BIOS features?

I see very little downside in giving the user more control over his
system.  A thousand knobs and switches are worth it for the user, for
the one switch that is there when the user needs it to solve a problem.

To dump my VBIOS ROM for Alex, I could have hacked up the radeon driver
to dump the ROM.  That would have consumed a lot of time.  Luckily for
me, there was a switch to turn on the ROM and dump it:

	# echo 1 > /sys/class/drm/card0/device/rom
	# dd if=/sys/class/drm/card0/device/rom of=msi7302igprom.bin
	# echo 0 > /sys/class/drm/card0/device/rom

I never used it before and will likely never use it again.  But when I
had a problem I needed to solve, its availability made the solution
simple and efficient.  Time to accomplish tasks is my scarcest resource;
time efficiency is very important to me.


The only downside to hundreds of switches and control knobs I can really
think of is possibly complexity for the end user.  But it turns out,
that ignoring the available controls, or ignoring large subsets of the
available controls, is how people are going to deal with that
complexity.  Heck, I ignore most of sysfs almost all the time.  I also
ignore almost every module option available.  My system runs fine
without me caring about a majority of the existing switches.


BTW, we already have thousands of switches and controls for kernel
internals in linux without sysfs and ioctl()'s:

$ find /lib/modules/`uname -r` -name "*.ko" -exec modinfo {} \; | grep '^parm:' | wc -l
3387

Why do we have that many?  They are low cost in complexity, as they can
easily be ignored.  They are high value in utility, as they give the
user control over his system to deal with unusual circumstances.

</rant>




>  We already have
> the quirk scheme for addressing this.
> 
> A simpler solution for reducing the log spam would be to only report
> the error once, instead of every 10 seconds. The driver could remember
> it has made the error report and then log another message later if the
> error was cleared.

My sysfs implementation was only 69 changed lines in one file:

	drivers/gpu/drm/drm_sysfs.c         |   69 +++++++++++

I doubt a solution to add logic to the error paths, to try and divine
all the sources of EDID errors by saving state and applying rules to
take the correct action, is going to be less change than that.  I know
more than one file will have to change.

Regards,
Andy

