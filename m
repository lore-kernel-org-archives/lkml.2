Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab1FIHiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:38:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62210 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab1FIHiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:38:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@lists.ozlabs.org,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 7/7] [v4] drivers/virt: introduce Freescale hypervisor management driver
Date: Thu, 9 Jun 2011 09:38:22 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Timur Tabi <timur@freescale.com>,
        konrad.wilk@oracle.com, kumar.gala@freescale.com,
        linux-kernel@vger.kernel.org, cmetcalf@tilera.com, akpm@kernel.org,
        dsaxena@linaro.org, linux-console@vger.kernel.org, greg@kroah.com,
        alan@lxorguk.ukuu.org.uk
References: <1307573154-15838-1-git-send-email-timur@freescale.com> <20110608161009.7b05d305.randy.dunlap@oracle.com>
In-Reply-To: <20110608161009.7b05d305.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106090938.23027.arnd@arndb.de>
X-Provags-ID: V02:K0:YVe/saxJOtzeiwV33vqG1EifDN/+RZM93CWRtXFD/Sl
 Uz7NbOfdYQDmPepG3jjxU7RqhWAFdaB8KY1uBbijsdCUnhTO9f
 ehx0TWk1BEiOuHrAvfIQJbfEnmUr2JuTh2trt+fti9d3kofVb2
 SORgMuOQ34grfRvJYP+7UTh3ga96VElN4mV0CbNtF4FHuJWlSw
 Cac+FwW2qse1PIVxNOP1w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 June 2011 01:10:09 Randy Dunlap wrote:
> On Wed, 8 Jun 2011 17:45:54 -0500 Timur Tabi wrote:
> 
> > Add the drivers/virt directory, which houses drivers that support
> > virtualization environments, and add the Freescale hypervisor management
> > driver.
> 
> It can't go in linux/virt or linux/virt/fsl instead?  why drivers/ ?
> 
> or maybe linux/virt should be drivers/virt ?

See discussion for v2 of this patch. I suggested that drivers/firmware and virt/
as options, the counterarguments were that drivers/firmware is for passive
firmware as opposed to firmware that acts as a hypervisor, and that virt/ is
for the host side of hypervisors like kvm, not for guests.

The driver in here most closely resembles the xen dom0 model, where a
priviledged guest controls other guests, but unlike xen there is a single
driver file, so there is no need to have drivers/fsl-hv directory just
for this one file. We do have a number of other hypervisors that fit in the
same category, so they can be added here later.

	Arnd
