Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab0FBGM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 02:12:56 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44467 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab0FBGMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 02:12:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=SwZqLtC0NEBnx76UMChgeskV3vxO0E3PN/46SNrtH9v80LCKY5IZlPS3S3KYzeUcx2
         CH32oKL3y0jfxfxfKjp78UzeCtTtJD/1ibfNLCJwaqpOTjMqA9gYbtjZbo50iM7LmLn5
         mN++jd9oANKoE1PSqtMkaepNWiypekgV2OfLc=
MIME-Version: 1.0
In-Reply-To: <EA929A9653AAE14F841771FB1DE5A1365FF3EC130E@rrsmsx501.amr.corp.intel.com>
References: <AANLkTimTm57fvumRXo9pegOY2M78mduBsClwYlmAOzpo@mail.gmail.com> 
	<20100601183920.GB19955@kroah.com> <EA929A9653AAE14F841771FB1DE5A1365FF3EC130E@rrsmsx501.amr.corp.intel.com>
From: Frank Pan <frankpzh@gmail.com>
Date: Wed, 2 Jun 2010 14:12:33 +0800
Message-ID: <AANLkTinmxW5gQUOYJgK67Dc1FdakeXSmuu1hExKKL1qk@mail.gmail.com>
Subject: Re: Add a helper function in PCI IOV to get VF device
To: "Williams, Mitch A" <mitch.a.williams@intel.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Yu Zhao <yu.zhao@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David S. Miller" <davem@davemloft.net>,
       Matt Carlson <mcarlson@broadcom.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Furthermore, the links are already there in sysfs, created by the PCI subsystem.
>
> /sys/class/net/ethX/device links to the PCI device entry for the PF device, which itself has symlinks to each of the VF devices.
>
> This patch just isn't necessary.

I'm not talking about PF's pci device, because PF
driver knows it. I'm talking about VF's.
The root cause is PF cannot get VF's bdf, so it has
no idea where VF is. IMO it's abnormal.

Make symlinks is just a use case. When a userspace
app only knows VF's bdf, it has no idea how to get
into the VF's interface-like directories.
(/sys/class/net/ethX/vf[1-7])
Because of:
1. Userspace app cannot get PF's bdf from VF's bdf
2. Userspace app cannot guess the interface name of
pf(ethX)
So a symlink from /sys/bus/pci/devices/xxxxx to
/sys/class/net/ethX/vf[1-7] is useful.
This is a real issue.

Thanks for reply.

-- 
Frank Pan

Computer Science and Technology
Tsinghua University
