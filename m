Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1AEQAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 11:00:50 -0500
Received: from kroah.org ([198.145.64.141]:34894 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab1AEQAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 11:00:47 -0500
Date: Wed, 5 Jan 2011 07:58:16 -0800
From: Greg KH <greg@kroah.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] block: fix accounting bug on cross partition merges
Message-ID: <20110105155816.GD2072@kroah.com>
References: <4D0B68AF.80804@redhat.com>
 <4D0BB4A1.8080305@fusionio.com>
 <4D13664C.3020500@redhat.com>
 <20101223153915.GE9502@redhat.com>
 <4D13810B.8000304@redhat.com>
 <20101224192916.GB2082@redhat.com>
 <4D23423A.60707@redhat.com>
 <4D2342E1.8010405@redhat.com>
 <20110104210011.GB4180@kroah.com>
 <4D247867.9040502@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D247867.9040502@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 02:55:51PM +0100, Jens Axboe wrote:
> On 2011-01-04 22:00, Greg KH wrote:
> > On Tue, Jan 04, 2011 at 04:55:13PM +0100, Jerome Marchand wrote:
> >> Also add a refcount to struct hd_struct to keep the partition in
> >> memory as long as users exist. We use kref_test_and_get() to ensure
> >> we don't add a reference to a partition which is going away.
> > 
> > No, don't do this, use a kref correctly and no such function should be
> > needed.
> > 
> >> +	} else {
> >> +		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
> > 
> > That is the function that should properly increment the reference count
> > on the object.  If the object is "being removed", then it will return
> > NULL and you need to check that.  Do that and you do not need to add:
> 
> It doesn't matter if you do it in there of after the fact, since the
> "lock" (RCU) is being held across the call. See my original suggestion
> here:
> 
> https://lkml.org/lkml/2010/12/17/275

Ok, that's fine, just do it without adding that kref function and I have
no objection :)

thanks,

greg k-h
