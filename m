Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1GNSFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 14:05:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab1GNSFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 14:05:37 -0400
Date: Thu, 14 Jul 2011 14:05:28 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110714180528.GF6672@redhat.com>
References: <1309944287.3937.39.camel@br98xy6r>
 <20110707193321.GE28850@redhat.com>
 <20110708110121.5acfc3c9@mschwide>
 <20110711144255.GE30674@redhat.com>
 <20110711175626.121dcc58@mschwide>
 <20110713160239.GE4426@redhat.com>
 <20110713184611.6dcb09b4@mschwide>
 <20110713200004.GG4426@redhat.com>
 <20110714091800.720da848@mschwide>
 <20110714175532.GE6672@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110714175532.GE6672@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 01:55:32PM -0400, Vivek Goyal wrote:

[..]
> > > So we first try to take purgatory path which does the checksum and is
> > > consistent with other architectures. If that does not work in case
> > > of hard hang, you always have the option of IPLing the stand alone tool
> > > later manually.
> > 
> > How are we suddenly on the purgatory path again? The code that gets
> > control in case of a hard crash + IPL is the stand-alone dump tool,
> > not the purgatory code.
> 
> I think that's the biggest contetion point. From the start of discussion
> you have this hardcoded requirement that the moment panic() happens
> you are jumping to some IPL code and that's what I am questioning. Why
> can't you execute some more code after panic() (purgatory), before
> you jump to IPL code (only if you have to). 
> 

In your parlance of shutdown actions, I think it is equivalnet to saying
that "kdump" is a shutdown action and that that means is that for specific
trigger points we will execute "crash_kexec()" function which will try
to capture the dump.

In user space I think one can modify the kexec-tools infrastrucuture a
bit so that one is able to define an entry point in case checksum of
loaded segment failes. Once you are loding kdump kernel, you can define
that entry point. (And this would be jump to IPL etc.).

Thanks
Vivek
