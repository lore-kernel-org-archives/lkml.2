Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094Ab2JLSoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:44:55 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:40242 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758111Ab2JLSoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:44:54 -0400
Message-ID: <1350067490.4627.8.camel@lorien2>
Subject: Re: [PATCH -stable] amd_iommu: attach device fails on the last pci
 device
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: joerg.roedel@amd.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Greg KH <gregkh@linuxfoundation.org>, iommu@lists.linux-foundation.org,
        stable@vger.kernel.org, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Date: Fri, 12 Oct 2012 12:44:50 -0600
In-Reply-To: <20121012183828.GA16453@elie.Belkin>
References: <1350059367.2643.17.camel@lorien2>
	 <20121012183828.GA16453@elie.Belkin>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 11:38 -0700, Jonathan Nieder wrote:
> Shuah Khan wrote:
> 
> > This bug is in linux-2.6.32 and an equivalent fix in linux-2.6.33 and has been
> > carried forward to later kernels and is in the upstream kernel. This equivalent
> > fix includes restructuring and consolidating device checks into a routine
> > check_device(). Instead of back-porting all of that work, spot-fixed the bug in
> > amd_iommu_attach_device() for linux-2.6.32.
> 
> To save Willy time: am I correct in guessing the upstream commit you
> are referring to is 98fc5a693bbdda498a556654c70d1e31a186c988
> (x86/amd-iommu: Use get_device_id and check_device where appropriate,
> 2009-11-24)?

Yes that is one. I looked that up again and it has the change to
amd_iommu_attach_device() to use check_device() and removes the check 

-	if (devid >= amd_iommu_last_bdf ||
-			devid != amd_iommu_alias_table[devid])
-		return -EINVAL;
+	devid = get_device_id(dev);

Ref: http://www.spinics.net/lists/linux-tip-commits/msg06129.html


Thanks,
-- Shuah


