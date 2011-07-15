Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab1GON4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 09:56:33 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:45031 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1GON4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 09:56:31 -0400
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
In-Reply-To: <20110714175532.GE6672@redhat.com>
References: <20110705202615.GJ24348@redhat.com>
	 <1309944287.3937.39.camel@br98xy6r> <20110707193321.GE28850@redhat.com>
	 <20110708110121.5acfc3c9@mschwide> <20110711144255.GE30674@redhat.com>
	 <20110711175626.121dcc58@mschwide> <20110713160239.GE4426@redhat.com>
	 <20110713184611.6dcb09b4@mschwide> <20110713200004.GG4426@redhat.com>
	 <20110714091800.720da848@mschwide>  <20110714175532.GE6672@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 15 Jul 2011 15:56:21 +0200
Message-ID: <1310738181.10789.16.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivec,

On Thu, 2011-07-14 at 13:55 -0400, Vivek Goyal wrote:

[snip]

> > The first thing we want to do is to check if
> > the purgatory is still fine, that is do a checksum. If we have the
> > infrastructure in place to do one checksum then we can easily do the
> > other checksums as well.
> 
> Some piece of code you have to assume is fine. Are you not already
> assuming that IPL code you have in first 64K bytes is fine and no
> body has overwritten it.

We can assume that the IPL dump code is fine, because it is freshly
loaded into memory. Only when the disk is somehow corrupted we have a
problem.

> Are you not assuming that hook in panic()
> (I think you are calling it shutdown trigger) is fine so that it
> can help you jump to right place.

Yes, that is correct for automatic dump in case of panic(). The panic()
path can fail.

But there are two other options where really *no* code that was in
memory, when the system crashed, is used for the dump process or
verification of kdump:
1) Manual IPL/boot of stand-alone dump by the operator via the virtual
guest console
2) Automatic IPL/boot of stand-alone dump by our z/VM hypervisor
watchdog

Michael

