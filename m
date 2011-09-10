Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab1IJAnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 20:43:11 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:60908 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755269Ab1IJAm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 20:42:57 -0400
X-Sasl-enc: TJtgdfB0XrEAMOlzraQbTYDDjpmdpOGmsiws+qPtZeR3 1315615376
Date: Fri, 9 Sep 2011 17:42:38 -0700
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] zram: Set initial disksize to some default value
Message-ID: <20110910004238.GB27110@kroah.com>
References: <1315609264-13632-1-git-send-email-ngupta@vflare.org>
 <1315609264-13632-6-git-send-email-ngupta@vflare.org>
 <20110909231209.GB24604@kroah.com>
 <4E6AACF0.2080907@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6AACF0.2080907@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 08:18:56PM -0400, Nitin Gupta wrote:
> On 09/09/2011 07:12 PM, Greg KH wrote:
> 
> > On Fri, Sep 09, 2011 at 07:01:04PM -0400, Nitin Gupta wrote:
> >> Currently, we set initial disksize as 0, which forces
> >> user to write some value to corresponding zram device's
> >> sysfs node, before the device can be used. Now, we avoid
> >> this step by providing some default size initially.
> >>
> >> To change the disksize, user must:
> >>  - Reset disk.
> >> 	Ex: echo 1 > /sys/block/zram0/reset
> >> (NOTE: disksize is set to the default value after reset)
> >>
> >>  - Set new disksize.
> >> 	Ex: echo $((256*1024*1024)) > /sys/block/zram0/disksize
> > 
> > So, what tools just broke with this change?
> > 
> > And where is the sysfs file documentation change that should go along
> > with this?
> > 
> 
> 
> This change does not change any sysfs names or behavior, so does not
> break any scripts that assume the current behavior. I also verified that
> sysfs documentation (ABI/testing/sysfs-block-zram) need not be changed
> and same with drivers/staging/zram/zram.txt.

Huh, you just said the behavior changed as described in your comment
above.  You said the user no longer has to do a step to accomplish
something.  What happens if they do do that after this patch?

confused,

greg k-h
