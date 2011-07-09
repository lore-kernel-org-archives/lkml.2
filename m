Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab1GINMM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 09:12:12 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42167 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab1GINML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 09:12:11 -0400
Date: Sat, 9 Jul 2011 09:11:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joe Jin <joe.jin@oracle.com>
Cc: Daniel Stodden <daniel.stodden@citrix.com>,
        Jens Axboe <jaxboe@fusionio.com>, annie.li@oracle.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: xen-blkfront: Don't send closing  notification to backend in
 blkfront_closing()
Message-ID: <20110709131153.GA25916@dumpdata.com>
References: <4E16AE55.50500@oracle.com>
 <20110708160414.GA30120@dumpdata.com>
 <4E17A01F.8060505@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E17A01F.8060505@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E1853A3.0092:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> 5. umount the partition/disk in guest, command hung. exactly at here, any
> >>    IO request to the partition/disk will hang.
> > 
> > I get that with the patch and without it:
> > 
> > sh-4.1#
> > sh-4.1# [  519.814048] block xvda: device/vbd/51712 was hot-unplugged, 1 stale handles
> > 
> > sh-4.1# df -h
> > Filesystem            Size  Used Avail Use% Mounted on
> > none                  490M  120K  490M   1% /dev
> > none                  490M  131M  359M  27% /lib/modules/3.0.0-rc6-00052-g3edce4b-dirty
> > shm                    10M     0   10M   0% /dev/shm
> > var_tmp                10M     0   10M   0% /var/tmp
> > /dev/xvda              20G  173M   19G   1% /test
> > sh-4.1# umount /test
> > 
> > Any ideas?
> 
> This caused by backend kthread stopped, any IO request to the real device will hang, that
> is the patch intend to resolving.

I get this hang with the patch (and without). Is there a corresponding patch to the backend?
(The backend is the same exact version as DomU - 3.0-rc6 + #stable/for-jens).
