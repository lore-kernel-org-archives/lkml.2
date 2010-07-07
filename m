Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab0GGUCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 16:02:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848Ab0GGUCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 16:02:46 -0400
Message-ID: <4C34DD1B.3010601@redhat.com>
Date: Wed, 07 Jul 2010 16:01:31 -0400
From: Don Dutile <ddutile@redhat.com>
Reply-To: ddutile@redhat.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081113)
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "stefano@stabellini.net" <stefano@stabellini.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "sheng@linux.intel.com" <sheng@linux.intel.com>,
       "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [PATCH 12/13] Unplug emulated disks and nics
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop> <1277136847-13266-12-git-send-email-stefano@stabellini.net> <4C2CEF56.4050008@redhat.com> <alpine.DEB.2.00.1007051255310.29110@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1007051255310.29110@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefano Stabellini wrote:
> On Thu, 1 Jul 2010, Don Dutile wrote:
>> The problem with this check/enable is that if you run
>> this on an older qemu-xen that doesn't have unplug support,
>> it fails pv-hvm configuration.
>>
>> But, all that means is that you can't use an xvd as the boot device,
>> and you have to use an emulated IDE device as boot device.
>> There are a couple ways to configure the vnif correctly (in guest
>> or in xen guest config file).
>>
>> So, on an older (say, rhel5) xen, I don't have this check;
>> the boot device is required to be spec'd as hda, not vda, and
>> xen-blkfront is not allowed to configure blk major nums
>> for IDE (& SCSI) (to avoid 2 drivers twiddling w/same phys backend... not good!).
>>
> 
> Who is requiring that the boot device is spec'd as hda and not xvda?
> I don't think there is such limitation in xend or libxl at the moment.
> 

If you take a previous xen HVM guest spec & just run it on a guest
that has pv-hvm added to it, then one has hda spec'd as boot device (by default,
by not editing the guest config spec/file).

Ideally, both config specs should/would work.

- Don

