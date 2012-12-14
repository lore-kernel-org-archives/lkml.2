Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab2LNCBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 21:01:21 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37784 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab2LNCBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 21:01:19 -0500
MIME-Version: 1.0
In-Reply-To: <1355415792.2229.7.camel@ul30vt.home>
References: <CANmqhJAuLoi_Y2Hsz+UnddHXYd9TCW-7qxp3fybDayfh33Y3Zg@mail.gmail.com>
	<1355415792.2229.7.camel@ul30vt.home>
Date: Fri, 14 Dec 2012 10:01:16 +0800
Message-ID: <CANmqhJBAxzVa5Ds0gojnYDDku5UbXGwfCNC=+z3XmVonF-_j2w@mail.gmail.com>
Subject: Re: DMAR and DRHD errors[DMAR:[fault reason 06] PTE Read access is
 not set] Vt-d & intel_iommu
From: Jason Gao <pkill.2012@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 12:23 AM, Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> Device 03:00.0 is your raid controller:
>
> 03:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 1078 (rev 04)
>
> For some reason it's trying to read from ffe65000, ffe8a000, ffe89000,
> ffe86000, ffe87000, ffe84000.  Those are in reserved memory regions, so
> it's not reading an OS allocated buffer, which probably means it's some
> kind of side-band communication with a management controller.  I'd guess
> it's a BIOS bug and there should be an RMRR covering those accesses.
> Thanks,

First of all ,I want to known whether I can ignore these errors on the
production server,and do these error may affect the system?

By the way,when I removed the "intel_iommu=on" from /etc/grub.conf,no
DMAR related errors occur

It's a strange thing,other three Dell R710 servers with the same bios
version v. 6.3.0, same kernel 2.6.32-279.14.1 on RHEL6u3(Centos 6u3)
,but these errors don't appear on these tree servers

Anyone have any idea for this ?

thanks
