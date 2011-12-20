Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab1LTJXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 04:23:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab1LTJXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 04:23:11 -0500
Message-ID: <4EF053FA.2020009@redhat.com>
Date: Tue, 20 Dec 2011 11:23:06 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Subject: Re: [PATCH 0/2] kvm: Lock down device assignment
References: <20111220030826.11829.9141.stgit@bling.home>
In-Reply-To: <20111220030826.11829.9141.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 05:19 AM, Alex Williamson wrote:
> Two patches to try to better secure the device assignment ioctl.
> This firt patch makes KVM_DEV_ASSIGN_ENABLE_IOMMU a mandatory
> option when assigning a device.  I don't believe we have any
> users of this option, so I think we can skip any deprecation
> period, especially since it's existence is rather dangerous.
>
> The second patch introduces some file permission checking that Avi
> suggested.  If a user has been granted read/write permission to
> the PCI sysfs BAR resource files, this is a good indication that
> they have access to the device.  We can't call sys_faccessat
> directly (not exported), but the important bits are self contained
> enough to include directly.  This still works with sudo and libvirt
> usage, the latter already grants qemu permission to these files.
> Thanks,
>
>

Looks good, but please update the API documentation.

-- 
error compiling committee.c: too many arguments to function

