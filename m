Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab0ECTRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 15:17:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38259 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068Ab0ECTRQ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 3 May 2010 15:17:16 -0400
Date: Mon, 3 May 2010 15:16:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, x86@kernel.org,
       clalance@redhat.com, drjones@redhat.com
Subject: Re: [LKML] [PATCH] Fix NULL pointer for Xen guests
Message-ID: <20100503191634.GA19699@phenom.dumpdata.com>
References: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com> <20100427165816.GA24707@phenom.dumpdata.com> <4BD71A2D.6050309@redhat.com> <20100427183428.GA15385@phenom.dumpdata.com> <4BD73134.1030308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD73134.1030308@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090204.4BDF212C.0094:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> OK, so your control domain is RHEL5. Mine is the Jeremy's xen/next one
>> (2.6.32). Let me try to compile RHEL5 under FC11 - any tricks necessary
>> to do that?
>>    
>
> I haven't tried it -- it might work :)
>
> Also, did you try booting with maxvcpus > vcpus as drjones suggested ?

Yes. No luck reproducing the crash/panic. I am just not seeing the failure you
guys are seeing.

Let me build once more 2.6.33 vanilla + CONFIG_DEBUG_MARK_RODATA=n) and check
this. And also install a vanilla RHEL5 dom0 as it looks impossible to
compile a 2.6.18-era kernel under FC11.

The Xen I am using is xen-unstable - so 4.0.1. I know that the IRQ balance
code in the Xen hypervisor was fixed in 4.0 (it used to run out of
context - now it runs in the IRQ context). Maybe this bug you are seeing
(and have the fix for) is just a red-heering?
