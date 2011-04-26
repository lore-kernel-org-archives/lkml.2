Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab1DZQeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:34:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28891 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab1DZQet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:34:49 -0400
Date: Tue, 26 Apr 2011 09:34:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Harry Wei <jiaweiwei.xiyou@gmail.com>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [TRIVIAL PATCH] treewide: Cleanup continuations and remove
 logging message whitespace
Message-Id: <20110426093434.e999ed24.randy.dunlap@oracle.com>
In-Reply-To: <20110426024807.GA2751@gmail.com>
References: <65136ab68431de0cc0c554663cee33fc9d4a9850.1303615717.git.joe@perches.com>
	<20110425082230.6d656ed0.randy.dunlap@oracle.com>
	<20110426024807.GA2751@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DB6F425.005E:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 10:48:10 +0800 Harry Wei wrote:

> On Mon, Apr 25, 2011 at 08:22:30AM -0700, Randy Dunlap wrote:
> > On Sat, 23 Apr 2011 20:38:19 -0700 Joe Perches wrote:
> > 
> > > Using C line continuation inside format strings is error prone.
> > > Clean up the unintended whitespace introduced by misuse of \.
> > > Neaten correctly used line continations as well for consistency.
> > > 
> > > drivers/scsi/arcmsr/arcmsr_hba.c has these errors as well,
> > > but arcmsr needs a lot more work and the driver should likely be
> > > moved to staging instead.
> > > 
> > > Signed-off-by: Joe Perches <joe@perches.com>
> >
> Acked-by: Harry Wei <harryxiyou@gmail.com>
> > 
> > 
> > Joe,
> > Is there a decent fix for this warning in linux-next:
> > 
> > drivers/tty/n_gsm.c:535: warning: zero-length gnu_printf format string
> Hi Randy & Joe,
>    I have seen the drivers/tty/n_gsm.c. 
> From line 529 to line 540 in drivers/tty/n_gsm.c like following.
> 
> 529 static void hex_packet(const unsigned char *p, int len)
> 530 {
> 531	int i;
> 532	for (i = 0; i < len; i++) {
> 533		if (i && (i % 16) == 0) {
> 534			pr_cont("\n");
> 535			pr_debug("");                                                                      
> 536		}
> 537		pr_cont("%02X ", *p++);
> 538	}
> 539	pr_cont("\n");
> 540 }
> 
> Should we need the line 535? If true, i wanna the function of 
> 'pr_debug("");'

Hi Harry,

Joe sent a different patch for this warning message.

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
