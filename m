Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030196Ab2GCIBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 04:01:18 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60038 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914Ab2GCIBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 04:01:17 -0400
Message-ID: <1341302472.3319.26.camel@dabdike>
Subject: Re: [PATCH] SCSI: Add SG_GET_SG_MAX_SEGMENT_SIZE ioctl to sg device
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: mc@linux.vnet.ibm.com
Cc: stefanha@linux.vnet.ibm.com, linuxram@us.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        senwang@linux.vnet.ibm.com
Date: Tue, 03 Jul 2012 12:01:12 +0400
In-Reply-To: <1341302003.17396.20.camel@mengcong>
References: <1341220857-1205-1-git-send-email-mc@linux.vnet.ibm.com>
	 <1341227897.2987.15.camel@dabdike.int.hansenpartnership.com>
	 <1341302003.17396.20.camel@mengcong>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 15:53 +0800, Cong Meng wrote:
> On Mon, 2012-07-02 at 12:18 +0100, James Bottomley wrote:
> > On Mon, 2012-07-02 at 17:20 +0800, Cong Meng wrote:
> > > Add a new ioctl cmd to get the max segment size. It's useful in
> > > virtualization environment for guest to know the queue limits, so
> > > that the guest kicks off legal scsi command to a sg device.
> > 
> > What's wrong with simply looking in the /sys for this? Plus, if you can
> 
> Adding this ioctl is a big convenience for the programs, qemu 
> in my case, to which parameter that likes '/dev/sgX' is given. 
> With this ioctl, those programs only need to issue an ioctl to 
> get the queue limit.

I don't need to know why you need the information, I accept that it's
useful

>  Otherwise, 'dev/sgX' is needed to convert 
> to /sys path, then open and read it. 

Well, yes, what's the problem?

> In addition, the potential variation and exceptional situation 
> of sys FS, EX mount path, are needed to consider as well.
> Is my justification acceptable? 

No. I need to know why you can't get it out of sysfs.  We put a whole
lot of stuff into sysfs to avoid the need to add extra ioctls.  There
need to be a really good reason why /sys doesn't work.

James

> > come up with a justifiable reason, this needs to be in block as well so
> > we can send it to all SCSI devices regardless of what ULD people use.
> I can do it.
> 
> Thanks.
> Cong.
> > 
> > James
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


