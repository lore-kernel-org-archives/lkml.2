Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675Ab0DPRMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 13:12:43 -0400
Received: from mail.deksai.com ([66.103.254.248]:53881 "EHLO mail.deksai.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab0DPRMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 13:12:41 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Apr 2010 13:12:41 EDT
Date: Fri, 16 Apr 2010 13:06:44 -0400
From: Chris <lists@deksai.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: CFQ read performance regression
Message-ID: <20100416170639.GA6753@chris-laptop.a2hosting.com>
Mail-Followup-To: linux-kernel <linux-kernel@vger.kernel.org>
References: <1271420878.24780.145.camel@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271420878.24780.145.camel@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 02:27:58PM +0200, Miklos Szeredi wrote:
> Hi Jens,
> 
> I'm chasing a performance bottleneck identified by tiobench that seems
> to be caused by CFQ.  On a SLES10-SP3 kernel (2.6.16, with some patches
> moving cfq closer to 2.6.17) tiobench with 8 threads gets about 260MB/s
> sequential read throughput.  On a recent kernels (including vanilla
> 2.6.34-rc) it makes about 145MB/s, a regression of 45%.  The queue and
> readahead parameters are the same.

I've also just noticed this using the most recent Redhat kernels.  Writes don't
seem to be affected at all.  If the latest Redhat kernels mean anything here, I
might as well show you what I've got, in case there is something common.

./disktest  -B 4k -h 1 -I BD -K 32 -p l -P T -T 300  -r /dev/sdf

With cfq we get this:
 STAT  | 17260 | v1.4.2 | /dev/sdf | Heartbeat read throughput: 15032320.0B/s (14.34MB/s), IOPS 3670.0/s
And with noop we get this:
  STAT  | 17260 | v1.4.2 | /dev/sdf | Heartbeat read throughput: 111759360.0B/s (106.58MB/s), IOPS 27285.0/s.

Setting some very large and busy web servers to noop just out of curiousity
also reduced the average io time and dropped the load.

Chris
