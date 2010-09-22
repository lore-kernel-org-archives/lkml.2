Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0IVMty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 08:49:54 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:62039 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752805Ab0IVMtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 08:49:53 -0400
Subject: Re: [PATCH] drm/sysfs: Provide per connector control of DRM KMS
 polling
From: Andy Walls <awalls@md.metrocast.net>
To: Florian Mickler <florian@mickler.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>,
        Jon Smirl <jonsmirl@gmail.com>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20100922114419.7f9766c5@schatten.dmk.lab>
References: <1284987540.2242.29.camel@morgan.silverblock.net>
	 <20100920185232.GA29263@kroah.com>
	 <1285017108.30856.7.camel@morgan.silverblock.net>
	 <20100922114419.7f9766c5@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 08:49:41 -0400
Message-ID: <1285159781.2731.59.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-22_06:2010-09-22,2010-09-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1009220067
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 11:44 +0200, Florian Mickler wrote:
> [cc'd chris wilson]

Oops.  Thanks!

> Hi Andy!
> 
> On Mon, 20 Sep 2010 19:02:30 -0400
> Andy Walls <awalls@md.metrocast.net> wrote:
> 
> > BTW, I found that Chris Wilson recently committed a change to inhibit
> > all drm connector polling globally for a different reason:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commit;h=e58f637bb96d5a0ae0919b9998b891d1ba7e47c9
> > 
> > That commit message shows a case where the driver decides polling needs
> > to happen, but the human knows differently and manual control over
> > connector polling mitigates the problem.
> 
> 
> On Mon, 20 Sep 2010 17:11:48 -0400
> Andy Walls <awalls@md.metrocast.net> wrote:
> 
> > On Mon, 2010-09-20 at 11:52 -0700, Greg KH wrote:
> > > On Mon, Sep 20, 2010 at 08:59:00AM -0400, Andy Walls wrote:
> >  
> > > > This change allows the root user to disable (and re-enable) DRM KMS
> > > > connector polling on a per connector basis via sysfs, like so:
> > > > 
> > > >         # cat /sys/class/drm/card0/card0-DVI-D-1/polled
> > > >         [hotplug_detectable] connect disconnect
> > 
> > > You are adding a sysfs file, yet you forgot to add a file in
> > > Documentation/ABI.  Please fix that and resend the patch.
> > 
> > Oops, process failure, sorry.
> > Will do.
> > 
> > Regards,
> > Andy
> > 
> 
> I thought sysfs files should be one thing per file... so, maybe
> card0-DVI-D-1/link_status and card0-DVI-D-1/hotplug_detectable with 0/1
> content would be easier to manipulate and parse? 

If precedent matters, the sysfs nodes for setting

	the IO scheduler
	the active trigger function on an LED
	the active IR remote control protocols

all use the same sort of paradigm as I did.

The IO scheduler and LED trigger ones allow the user to set 1 of N
choices.  The IR protocol one allows the user to set M of N choices.
They all uses brackets to differentiate [set] vs unset.


> I have to defer to the drm maintainers for the usecases. But how is
> having a monitor with a broken edid handled right now? While the output
> is connected and used, it probably just stops polling?

Not from what I can see.  I could very well be wrong on that, so please
someone double check me.

This error message sequence, and from what I saw in the code, indicates
to me that the gripe for a constantly bad EDID will never end:

Sep 22 07:46:13 morgan kernel: [drm:drm_edid_is_valid] *ERROR* Raw EDID:
Sep 22 07:46:13 morgan kernel: [drm:drm_edid_is_valid] *ERROR* Raw EDID:
Sep 22 07:46:13 morgan kernel: [drm:drm_edid_is_valid] *ERROR* Raw EDID:
Sep 22 07:46:13 morgan kernel: [drm:drm_edid_is_valid] *ERROR* Raw EDID:
Sep 22 07:46:13 morgan kernel: radeon 0000:01:05.0: DVI-D-1: EDID invalid.
Sep 22 07:46:13 morgan kernel: [drm:radeon_dvi_detect] *ERROR* DVI-D-1: probed a monitor but no|invalid EDID
Sep 22 07:46:13 morgan kernel: [drm:drm_edid_is_valid] *ERROR* Raw EDID:
Sep 22 07:46:13 morgan kernel: [drm:drm_edid_is_valid] *ERROR* Raw EDID:
Sep 22 07:46:13 morgan kernel: [drm:drm_edid_is_valid] *ERROR* Raw EDID:
Sep 22 07:46:13 morgan kernel: [drm:drm_edid_is_valid] *ERROR* Raw EDID:
Sep 22 07:46:13 morgan kernel: radeon 0000:01:05.0: DVI-D-1: EDID invalid.
Sep 22 07:46:13 morgan kernel: [drm:radeon_dvi_detect] *ERROR* DVI-D-1: probed a monitor but no|invalid EDID

This time around we 

	"probed a monitor but no|invalid EDID"

so lets do it again later, and maybe we'll get a different result.

That's legitimate to do once or twice because of transient conditions:
one may get a bad EDID due to monitor power on/off or cable
connect/disconnect.

To keep doing it for persistent error conditions, when the user fully
understands the source of the error and has assessed the impact as
inconsequential, is annoying.

By now, I guess everyone can tell at least I'm annoyed by it. :) 

Regards,
Andy


