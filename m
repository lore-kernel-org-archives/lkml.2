Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab0IVMcC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 08:32:02 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43631 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753722Ab0IVMcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 08:32:00 -0400
Subject: Re: [PATCH] drm/sysfs: Provide per connector control of DRM KMS
 polling
From: Andy Walls <awalls@md.metrocast.net>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Dave Airlie <airlied@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Jon Smirl <jonsmirl@gmail.com>
In-Reply-To: <AANLkTi=h=9mvdLMcZZAtg3_eu7wD2Yj0Dn2iWjhF7BiL@mail.gmail.com>
References: <1284987540.2242.29.camel@morgan.silverblock.net>
	 <AANLkTikj4biBS7wQsRM6o3kEmyaPNMaSUBEktMmmOy89@mail.gmail.com>
	 <1285023750.30856.99.camel@morgan.silverblock.net>
	 <AANLkTi=RCJcQMSWMm6pQgJnJZT9TyfGyFtWmeu8GKHA-@mail.gmail.com>
	 <1285090202.19131.77.camel@morgan.silverblock.net>
	 <AANLkTi=h=9mvdLMcZZAtg3_eu7wD2Yj0Dn2iWjhF7BiL@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 08:31:51 -0400
Message-ID: <1285158711.2731.42.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-22_06:2010-09-22,2010-09-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=3 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1009220060
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 01:30 -0400, Alex Deucher wrote:
> On Tue, Sep 21, 2010 at 1:30 PM, Andy Walls <awalls@md.metrocast.net> wrote:

> > In a larger sense it's about user policy for error reporting by the drm
> > and radeon drivers, and error response by both the drivers and the user.
> >
> > In the face of EDID errors, a user may want to take the following
> > actions:
> >
> >        ignore the errors
> >        supress the errors
> >        continue to monitor the errors for a time
> >        replace cables
> >        replace graphics adapter
> >        replace monitor
> >        report a bug
> >
> > All of those end user actions are possible right now, except the one to
> > supress the errors (and the I2C transactions associated with them).
> >
> > A monitor, cable, and graphics adapter set that is currently
> > experiencing EDID errors, may be otherwise working just fine.
> >
> > "Because we want to ensure people report bugs," does not seem like a
> > good reason to prevent a user from turning off bogus error messages, for
> > an otherwise working monitor that is providing broken EDID data.  What
> > is the resolution of a bug report for a monitor providing bad EDID data
> > going to look like?
> 
> I wasn't talking about the broken EDID messages, I was talking about
> the bogus connector table entries on your board.  Those should be
> properly quirked in the driver in which case, which would avoid the
> problem all together in your case.

The problem with in-kernel quirk databases are

- you'll always end up lagging behind what's being fielded,

- the number of stale entries will grow over the years,

- the scope of the fix for a single quirk entry for the total installed
    user base is small; each quirk table entry itself has little value

- quirks for working around unreliable attributes still need a 
    reliable system identification method (no big deal for PCI)

- fixing by quirk is a reactionary mode for kernel developers
    (it's also job security, so sysadmins are stuck coming back for
     help)

- it increases time to resolve problems for end users.

I don't think it's a good to plan to continually react to manufacturers
that have cycle times of 6 months to a year.  Quirk tables should be a
solution of last resort, when there's nothing else that can be done,
IMO.  


I understood.  A quirk database solves the immediate problem for me and
for owners of that MSI motherboard.

My current problem also highlights undesirable behavior that will occur
with broken EDIDs.  This undesirable behavior will likely resurface in
another bug report.


> >>  or does the board have a bug in the connector table?
> >
> > I have not dug into the BIOS connector table bits and bytes to verify,
> > but I'm assuming the connector table is incorrect.
> >
> 
> It appears to be incorrect.  If you send me a copy of the vbios, I can
> easily add a quirk. I suspect your board oem may offer several boards
> with different output configurations and neglected to update the table
> in some configurations.

Do you have a pointer to a set of steps to follow for extracting that
vbios information?




> >>   What
> >> physical connectors does the board have what does the driver report in
> >> dmesg?
> >
> > The board only has a physical VGA connector.  The graphics adapter is an
> > IGP on an MSI K9A2GM V2/V3 series motherboard (MS-7302).  Here are the
> > PCI IDs on the graphics adapter:
> >
> > 01:05.0 VGA compatible controller [0300]:
> >        ATI Technologies Inc Radeon 2100 [1002:796e] (prog-if 00 [VGA controller])
> >        Subsystem: Micro-Star International Co., Ltd. Device [1462:7302]
> >
> >
> > Below is the dmesg output from the unmodified drm and radeon modules
> > which includes samples of drm module log spam for the first 30 seconds
> > or so after boot.

> > [drm] Radeon Display Connectors
> > [drm] Connector 0:
> > [drm]   VGA
> > [drm]   DDC: 0x7e50 0x7e40 0x7e54 0x7e44 0x7e58 0x7e48 0x7e5c 0x7e4c
> > [drm]   Encoders:
> > [drm]     CRT1: INTERNAL_KLDSCP_DAC1
> > [drm] Connector 1:
> > [drm]   DVI-D
> > [drm]   HPD2
> > [drm]   DDC: 0x7e40 0x7e60 0x7e44 0x7e64 0x7e48 0x7e68 0x7e4c 0x7e6c
> > [drm]   Encoders:
> > [drm]     DFP2: INTERNAL_DDI
> > [drm] Connector 2:
> > [drm]   HDMI-A
> > [drm]   DDC: 0x7e40 0x7e50 0x7e44 0x7e54 0x7e48 0x7e58 0x7e4c 0x7e5c
> > [drm]   Encoders:
> > [drm]     DFP3: INTERNAL_LVTM1
> 
> FWIW, it's actually the HDMI connector that is generating the errors
> due to the lack of a hpd pin assignment.

Are you sure?  My /var/log/messages spam insists it is DVI-D-1 (hex
dumps omitted):

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


Regards,
Andy


