Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab0DFWKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 18:10:37 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58003 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778Ab0DFWKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 18:10:30 -0400
To: Yinghai Lu <yinghai@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
       Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joro@8bytes.org>,
       Bernhard Walle <bernhard@bwalle.de>, nhorman@redhat.com,
       nhorman@tuxdriver.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 3/4] Revert "x86: disable IOMMUs on kernel crash"
References: <20100403012820.229410717@sous-sol.org>
	<m1vdc8juju.fsf@fess.ebiederm.org> <4BB83EAE.5090609@bwalle.de>
	<20100404085338.GU24846@8bytes.org> <m17hond01n.fsf@fess.ebiederm.org>
	<20100404100101.GW24846@8bytes.org>
	<20100406174257.GG29241@sequoia.sous-sol.org>
	<20100406175106.GH28166@amd.com> <20100406203956.GI3029@redhat.com>
	<20100406211315.GJ3029@redhat.com>
	<z2w86802c441004061445q5a05832fmaece2723436f803f@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 06 Apr 2010 15:10:14 -0700
In-Reply-To: <z2w86802c441004061445q5a05832fmaece2723436f803f@mail.gmail.com> (Yinghai Lu's message of "Tue\, 6 Apr 2010 14\:45\:51 -0700")
Message-ID: <m1y6h0qlkp.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: yinghai@kernel.org, iommu@lists.linux-foundation.org, hbabu@us.ibm.com, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, nhorman@tuxdriver.com, nhorman@redhat.com, bernhard@bwalle.de, joro@8bytes.org, chrisw@sous-sol.org, joerg.roedel@amd.com, vgoyal@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yinghai@kernel.org> writes:

> not sure if it is related:

I don't think it is.

> for crashing kernel, it could do early_memtest to check if some device
> are still do dma operation.

Devices doing DMA in general are not a problem in the kdump kernel
because we are using an area of memory that has been reserved since
the beginning of time and no DMA's should be targeting it.  The challenge
is how to regain control of the IOMMU.

> When I use kexec to start second kernel, if enable the early_memtest
> in second kernel, it will find some pages RAM are BAD,
> and it will mark them and not use them.  memtest=1 should be good enough.
> Fresh restart will not report there is any BAD ram in the same system.

I assume you are not talking kdump here.

On-going DMA in the case of kexec indicates some device driver isn't shutting
itself down when it's shutdown method is called.

Odds are it is a network controller that doesn't stop DMA when it is brought
down or it is, possibly a really weird disk driver.

If you are seeing this with the kdump kernel this may indeed indicate an
IOMMU reinitialization problem.

Eric
