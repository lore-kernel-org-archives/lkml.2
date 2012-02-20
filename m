Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab2BTKVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 05:21:42 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:49740 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2BTKVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 05:21:40 -0500
Date: Mon, 20 Feb 2012 15:50:29 +0530
From: Pradeep Kumar Surisetty <psuriset@linux.vnet.ibm.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: KVM: perf: a smart tool to analyse kvm events
Message-ID: <20120220102029.GC8666@linux.vnet.ibm.com>
Reply-To: Pradeep Kumar Surisetty <psuriset@linux.vnet.ibm.com>
References: <20120216155248.6865.47935.sendpatchset@localhost.localdomain>
 <4F3DBCD8.2020505@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4F3DBCD8.2020505@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022010-5518-0000-0000-0000025E4467
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> [2012-02-17 10:35:04]:

> On 02/16/2012 11:52 PM, Pradeep Kumar wrote:
> 
> > Xiao,
> > 
> >  i tried your perf events patch set on RHEL 6.1 host and failed to trace kvm-events with below error message.
> > 
> >   [root@kvm perf]# ./perf kvm-events report
> >   Warning: unknown op '{'
> >   Warning: Error: expected type 5 but read 1
> >   Warning: failed to read event print fmt for hrtimer_start
> >   Warning: unknown op '{'
> >   Warning: Error: expected type 5 but read 1
> >   Warning: failed to read event print fmt for hrtimer_expire_entry
> >   Analyze events for all VCPUs:
> >   VM-EXIT    Samples  Samples%     Time%         Avg time               
> >   Total Samples:0, Total events handled time:0.00us.
> >   [root@kvm perf]#          
> > 	     
> 
> 
> Thanks for your try, Pradeep!
> 
> It seems that kvm events do not be recorded.
> 
> Do your guest was running when kvm-events was executed?

Hello Xiao

my guest was not running when i executed. 

> What is the output of "./perf script | grep kvm_*"?

[root@phx3 perf]# ./perf script | grep kvm_*
Warning: unknown op '{'
Warning: Error: expected type 5 but read 1
Warning: failed to read event print fmt for hrtimer_start
Warning: unknown op '{'
Warning: Error: expected type 5 but read 1
Warning: failed to read event print fmt for
hrtimer_expire_entry
# cmdline : /home/patch/linux/tools/perf/perf record -a -R
# -f -m 1024 -c 1 -e kvm:kvm_entry -e kvm:kvm_exit -e
# kvm:kvm_mmio -e kvm:kvm_pio -e timer:* 
# event : name = kvm:kvm_entry, type = 2, config = 0x2ef,
# config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0,
# id = { 6241, 6242, 6243, 6244, 6245, 6246, 6247, 6248 }
# event : name = kvm:kvm_exit, type = 2, config = 0x2ea,
# config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0,
# id = { 6249, 6250, 6251, 6252, 6253, 6254, 6255, 6256 }
# event : name = kvm:kvm_mmio, type = 2, config = 0x2dd,
# config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0,
# id = { 6257, 6258, 6259, 6260, 6261, 6262, 6263, 6264 }
# event : name = kvm:kvm_pio, type = 2, config = 0x2ed,
# config1 = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0,
# id = { 6265, 6266, 6267, 6268, 6269, 6270, 6271, 6272 }
no symbols found in /sbin/killall5, maybe install a debug
package?

--Pradeep

> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

