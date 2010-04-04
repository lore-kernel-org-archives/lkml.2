Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab0DDJor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 05:44:47 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45632 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab0DDJom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 05:44:42 -0400
To: Joerg Roedel <joro@8bytes.org>
Cc: Bernhard Walle <bernhard@bwalle.de>, nhorman@redhat.com,
       nhorman@tuxdriver.com, Joerg Roedel <joerg.roedel@amd.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org, vgoyal@redhat.com
Subject: Re: [PATCH 3/4] Revert "x86: disable IOMMUs on kernel crash"
References: <20100403012751.834020949@sous-sol.org>
	<20100403012820.229410717@sous-sol.org>
	<20100403174128.GQ24846@8bytes.org> <m1vdc8juju.fsf@fess.ebiederm.org>
	<4BB83EAE.5090609@bwalle.de> <20100404085338.GU24846@8bytes.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 04 Apr 2010 02:44:36 -0700
In-Reply-To: <20100404085338.GU24846@8bytes.org> (Joerg Roedel's message of "Sun\, 4 Apr 2010 10\:53\:38 +0200")
Message-ID: <m17hond01n.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: joro@8bytes.org, vgoyal@redhat.com, iommu@lists.linux-foundation.org, hbabu@us.ibm.com, chrisw@sous-sol.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, joerg.roedel@amd.com, nhorman@tuxdriver.com, nhorman@redhat.com, bernhard@bwalle.de
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel <joro@8bytes.org> writes:

> On Sun, Apr 04, 2010 at 09:24:30AM +0200, Bernhard Walle wrote:
>> Am 03.04.10 19:49, schrieb Eric W. Biederman:
>> > Not a problem.  We require a lot of things of the kdump kernel,
>> > and it is immediately apparent in a basic sanity test.
>> 
>> Also, in most cases (for example: distribution kernels), the kdump
>> kernel nowadays is identical to the running kernel. So, if the running
>> kernel has IOMMU support, the kdump kernel also has.
>
> Yes, I know. But is that a requirement for kexec?

For normal kexec no.  That path is expected to do a clean hardware
shutdown.

For kexec on panic aka kdump the requirement is that your your crash
kernel be able to initialize your hardware from any state it can be
put in.

Currently we have no kernels that properly recover and amd-iommu and
it is not a requirement that we cater to broken kernels.

> If not we still
> potentially have this problem. It is a smaller problem than
> data-corruption caused by in-flight dma because most
> people^Wdistributions indeed use the same kernel for normal boot and
> kexec, thats true.

There are exceptions made for practical reality.  The fact that
typically the kdump kernel is the same as the running kernel mean that
we don't even need to consider one of those exceptions.

Eric
