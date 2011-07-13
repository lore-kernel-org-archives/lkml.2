Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821Ab1GMRUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 13:20:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932403Ab1GMRUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 13:20:12 -0400
Date: Wed, 13 Jul 2011 13:19:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110713171930.GF4426@redhat.com>
References: <20110704170922.976299676@linux.vnet.ibm.com>
 <20110705202615.GJ24348@redhat.com>
 <1309944287.3937.39.camel@br98xy6r>
 <20110707193321.GE28850@redhat.com>
 <20110708110121.5acfc3c9@mschwide>
 <20110711144255.GE30674@redhat.com>
 <20110711175626.121dcc58@mschwide>
 <20110713160239.GE4426@redhat.com>
 <20110713184611.6dcb09b4@mschwide>
 <1310576390.2864.9.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310576390.2864.9.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 06:59:50PM +0200, Michael Holzheu wrote:
> On Wed, 2011-07-13 at 18:46 +0200, Martin Schwidefsky wrote:
> > On Wed, 13 Jul 2011 12:02:39 -0400
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > > So in case of stand alone dump, you save the calculated checksum of
> > > kdump kernel at disk and not in memory? And then calculate the checksum
> > > of memory image of kdump kernel and decide whether kdump kenrel is 
> > > corrupted or not?
> > > 
> > > If yes, this sounds more reliable as checksum of kernel is stored on
> > > some disk/tape.
> > 
> > No, the checksum for the purgatory code is stored in memory. If the purgatory
> > code is corrupted you would have to corrupt the checksum in a very specific
> > way as well to make it fail. 
> 
> Currently we store the checksums for the loaded *kexec segments* in
> memory at the end of kexec_load(). The stand-alone dump tools also
> calculate the checksums for all segments and compare them with the
> stored checksums. The dump tools can do that because we have meminfos
> for all segments. A meminfo element contains:
> * address of memory chunk
> * size of memory chunk
> * checksum of memory chunk (calculated at the end of kexec_load()

So this does not seem to be very different from what kexec and purgatory
is doing on x86. So why not simply reuse that and if checksum fails
jump to stand alone kernel. Why to duplicate all the checksum logic
in stand alone dump tools.

Thanks
Vivek
