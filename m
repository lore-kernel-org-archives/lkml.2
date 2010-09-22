Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291Ab0IVQgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 12:36:17 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:60575 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764Ab0IVQgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 12:36:16 -0400
Subject: Re: [PATCH v2 2/2] Doc/ABI: sysfs-drm initial document; "polled"
 entry
From: Andy Walls <awalls@md.metrocast.net>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        Jon Smirl <jonsmirl@gmail.com>
In-Reply-To: <20100922150603.GB26401@kroah.com>
References: <1284987540.2242.29.camel@morgan.silverblock.net>
	 <AANLkTikj4biBS7wQsRM6o3kEmyaPNMaSUBEktMmmOy89@mail.gmail.com>
	 <1285023750.30856.99.camel@morgan.silverblock.net>
	 <1285125622.2518.21.camel@morgan.silverblock.net>
	 <20100922150603.GB26401@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 12:36:06 -0400
Message-ID: <1285173366.3121.16.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-22_08:2010-09-22,2010-09-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1009220124
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 08:06 -0700, Greg KH wrote:
> On Tue, Sep 21, 2010 at 11:20:22PM -0400, Andy Walls wrote:
> > +Where:		/sys/devices/<...>/drm/cardN/cardN-C-M/polled
> > +		For N a decimal system graphics adapter number: 0, 1, 2, ...
> > +		For C a connector type name (including spaces) from the set:
> 
> Spaces?  Really?  Yeah, I know it will work just fine, but why go out of
> your way to make it hard for people?

Not my fault.
It was like that when I got here.


$ ls -d /sys/devices/pci0000\:00/0000\:00\:01.0/0000\:01\:05.0/drm//card0/card0*
/sys/devices/pci0000:00/0000:00:01.0/0000:01:05.0/drm//card0/card0-DVI-D-1
/sys/devices/pci0000:00/0000:00:01.0/0000:01:05.0/drm//card0/card0-HDMI Type A-1
/sys/devices/pci0000:00/0000:00:01.0/0000:01:05.0/drm//card0/card0-VGA-1

I only added one entry, "polled", in those existing directories.

BTW, Jon Smirl, IBM Corp, and you have Copyright credit in the
drm_sysfs.c file that creates those directories with spaces.  ;)


I'll also gripe that PCI's colons are pretty annoying on the command
line too, since they have to be escaped as well.


> > +			HDMI Type A
> > +			HDMI Type B
> > +			TV
> > +			Embedded DisplayPort
> 
> You could always just use a '_' instead of a space for those that need
> it.

A trivial patch here would do that:

http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=blob;f=drivers/gpu/drm/drm_crtc.c;h=37e0b4fa482a810afc9eded6fda136a90bcc5cc0;hb=refs/heads/drm-fixes#l146

but I have no idea what that might break.

Regards,
Andy


