Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab1GLOMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 10:12:45 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:19905 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab1GLOMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 10:12:43 -0400
Date: Tue, 12 Jul 2011 10:12:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: xen-devel@lists.xensource.com, julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110712141228.GA7831@dumpdata.com>
References: <CAAVPGOPAx-oLZct9u2Kq3uQ4W2GwJFYUGgw3h=M_Y4_wv7b51w@mail.gmail.com>
 <20110710214639.GP6014@linux.vnet.ibm.com>
 <CAAVPGOMafp_+45X=7asHe=MqaHY8CiJYsf2GZ3qOPrWpjctHVQ@mail.gmail.com>
 <20110710231449.GQ6014@linux.vnet.ibm.com>
 <20110711162450.GA22913@dumpdata.com>
 <20110711171337.GK2245@linux.vnet.ibm.com>
 <20110711193021.GA2996@dumpdata.com>
 <20110711201508.GN2245@linux.vnet.ibm.com>
 <20110711210954.GA15745@dumpdata.com>
 <20110712105506.GB2253@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110712105506.GB2253@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E1C5656.00A7:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >   [<c042d0f5>] task_waking_fair+0x14  <--
> 
> Hmmm...  This is a 32-bit system, isn't it?

Yes. I ran this little loop:

#!/bin/bash

ID=`xl list | grep Fedora | awk '  { print $2}'`

rm -f cpu*.log
while (true) do
	xl pause $ID
	 /usr/lib64/xen/bin/xenctx -s /mnt/tmp/FC15-32/System.map-3.0.0-rc6-julie-tested-dirty -a $ID 0 >> cpu0.log
	 /usr/lib64/xen/bin/xenctx -s /mnt/tmp/FC15-32/System.map-3.0.0-rc6-julie-tested-dirty -a $ID 1 >> cpu1.log
	 /usr/lib64/xen/bin/xenctx -s /mnt/tmp/FC15-32/System.map-3.0.0-rc6-julie-tested-dirty -a $ID 2 >> cpu2.log
	 /usr/lib64/xen/bin/xenctx -s /mnt/tmp/FC15-32/System.map-3.0.0-rc6-julie-tested-dirty -a $ID 3 >> cpu3.log
	xl unpause $ID
done

To get an idea what the CPU is doing before it hits the task_waking_fair
and there isn't anything daming. Here are the logs:

http://darnok.org/xen/cpu1.log

> 
> Could you please add a check to the loop in task_waking_fair() and
> do a printk() if the loop does (say) more than 1000 passes without
> exiting?

Of course. Let me queue that up.
