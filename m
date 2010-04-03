Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab0DCTlg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 15:41:36 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:39331 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab0DCTl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 15:41:29 -0400
To: Joerg Roedel <joro@8bytes.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joerg.roedel@amd.com>,
       nhorman@redhat.com, nhorman@tuxdriver.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org, vgoyal@redhat.com
Subject: Re: [PATCH 3/4] Revert "x86: disable IOMMUs on kernel crash"
References: <20100403012751.834020949@sous-sol.org>
	<20100403012820.229410717@sous-sol.org>
	<20100403174128.GQ24846@8bytes.org> <m1vdc8juju.fsf@fess.ebiederm.org>
	<20100403191314.GR24846@8bytes.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 03 Apr 2010 12:41:21 -0700
In-Reply-To: <20100403191314.GR24846@8bytes.org> (Joerg Roedel's message of "Sat\, 3 Apr 2010 21\:13\:14 +0200")
Message-ID: <m1vdc8iase.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: joro@8bytes.org, vgoyal@redhat.com, iommu@lists.linux-foundation.org, hbabu@us.ibm.com, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, nhorman@tuxdriver.com, nhorman@redhat.com, joerg.roedel@amd.com, chrisw@sous-sol.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel <joro@8bytes.org> writes:

> On Sat, Apr 03, 2010 at 10:49:09AM -0700, Eric W. Biederman wrote:
>> Joerg Roedel <joro@8bytes.org> writes:
>
>> > Another problem: This also breaks if the kdump kernel has no
>> > iommu-support.
>> 
>> Not a problem.  We require a lot of things of the kdump kernel,
>> and it is immediately apparent in a basic sanity test.
>
> Only if the sanity test is done on an iommu machine which I don't want
> to rely on.

That makes no sense.

The requirements on the kdump kernel has always been that it somehow
figure out to recover a machine that is in a random hardware state.
That requires drivers for the hardware, that is critical to the
machines operation.

The easy test for sysadmins is to do:
echo > /proc/sysrq-trigger

Anyone who thinks the result from one piece of hardware applies to
another is deluded.

We have been down the path of doing lots of things in the crashing
kernel with lkcd, in practice it was worthless in the event of real
world crashes.

kexec on panic isn't perfect but it at least is an architecture that
works often enough to be usable.  It does require testing to make certain
the basic code paths don't regress, but even so it is a lot easier
to maintain and keep useful than any alternative I know of.

Eric
