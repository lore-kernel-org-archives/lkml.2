Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab2GCHxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 03:53:33 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:44566 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab2GCHxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 03:53:31 -0400
Message-ID: <1341302003.17396.20.camel@mengcong>
Subject: Re: [PATCH] SCSI: Add SG_GET_SG_MAX_SEGMENT_SIZE ioctl to sg device
From: Cong Meng <mc@linux.vnet.ibm.com>
Reply-To: mc@linux.vnet.ibm.com
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: stefanha@linux.vnet.ibm.com, linuxram@us.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        senwang@linux.vnet.ibm.com
Date: Tue, 03 Jul 2012 15:53:23 +0800
In-Reply-To: <1341227897.2987.15.camel@dabdike.int.hansenpartnership.com>
References: <1341220857-1205-1-git-send-email-mc@linux.vnet.ibm.com>
	 <1341227897.2987.15.camel@dabdike.int.hansenpartnership.com>
Organization: LTC, IBM
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12070221-1396-0000-0000-0000017F2474
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 12:18 +0100, James Bottomley wrote:
> On Mon, 2012-07-02 at 17:20 +0800, Cong Meng wrote:
> > Add a new ioctl cmd to get the max segment size. It's useful in
> > virtualization environment for guest to know the queue limits, so
> > that the guest kicks off legal scsi command to a sg device.
> 
> What's wrong with simply looking in the /sys for this? Plus, if you can

Adding this ioctl is a big convenience for the programs, qemu 
in my case, to which parameter that likes '/dev/sgX' is given. 
With this ioctl, those programs only need to issue an ioctl to 
get the queue limit. Otherwise, 'dev/sgX' is needed to convert 
to /sys path, then open and read it. 
In addition, the potential variation and exceptional situation 
of sys FS, EX mount path, are needed to consider as well.
Is my justification acceptable? 

> come up with a justifiable reason, this needs to be in block as well so
> we can send it to all SCSI devices regardless of what ULD people use.
I can do it.

Thanks.
Cong.
> 
> James
> 
> 


