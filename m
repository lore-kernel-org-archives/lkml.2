Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab1EQGKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 02:10:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:55643 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab1EQGKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 02:10:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,223,1304319600"; 
   d="scan'208";a="643632138"
Subject: Re: Perfromance drop on SCSI hard disk
From: "Alex,Shi" <alex.shi@intel.com>
To: "Li, Shaohua" <shaohua.li@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1305535071.21534.2122.camel@debian>
References: <1305009600.21534.587.camel@debian>
	 <4DCC4340.6000407@fusionio.com>  <1305247704.2373.32.camel@sli10-conroe>
	 <1305255717.2373.38.camel@sli10-conroe>
	 <1305533054.2375.45.camel@sli10-conroe>
	 <1305535071.21534.2122.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 14:09:25 +0800
Message-ID: <1305612565.21534.2177.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 16:37 +0800, Alex,Shi wrote:
> > > what I mean is current sdev (other devices too) can still be added into
> > > starved list, so only does async execute for current q isn't enough,
> > > we'd better put whole __scsi_run_queue into workqueue. something like
> > > below on top of yours, untested. Not sure if there are other recursive
> > > cases.
> > verified the regression can be fully fixed by your patch (with my
> > suggested fix to avoid race). Can we put a formal patch upstream?
> 
> Yes, we tested Jens patch alone and plus Shaohua's patch too. Both of
> them recovered SAS disk performance too. Now I am testing them on SSD
> disk with kbuild and fio cases, In theory, they will both work. 
> 

As expected, both patches has no effect on SSD disks in JBD. 

> > 
> > Thanks,
> > Shaohua
> > 
> 


