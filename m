Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab2DUNOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 09:14:39 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:34693 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751842Ab2DUNOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 09:14:37 -0400
From: Robert Scott <bugs@humanleg.org.uk>
Reply-To: bugs@humanleg.org.uk
Organization: none
To: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [regression] Ideapad S10-3 does not wake up from suspend
Date: Sat, 21 Apr 2012 14:14:21 +0100
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        Fengzhe Zhang <fengzhe.zhang@intel.com>, mingo@redhat.com,
        hpa@zytor.com, Ian Campbell <Ian.Campbell@eu.citrix.com>,
        JBeulich@novell.com, xen-devel@lists.xensource.com,
        Lars Boegild Thomsen <lth@cow.dk>,
        e568b31a443d@6cc2cce7af2d.anonbox.net,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com> <201204161905.13260.bugs@humanleg.org.uk> <20120417020433.GA15848@burratino>
In-Reply-To: <20120417020433.GA15848@burratino>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201204211414.30286.bugs@humanleg.org.uk>
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=oafpOytrBa8A:10 a=l5_RjRQ6opQA:10 a=8nJEP1OIZ-IA:10 a=hLW_Fef1W2nHZV0zz8kA:9 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2012, Jonathan Nieder wrote:
> Robert Scott wrote:
> > On Sunday 15 April 2012, Jonathan Nieder wrote:
> 
> >> Lars, Robert, anon: can you try 3.4-rc2 or newer and let us know how
> >> it goes?  I suspect v3.4-rc2~24^2~4 ("x86: Preserve lazy irq disable
> >> semantics in fixup_irqs()") will fix this.
> >
> > Hmm, no, 3.4-rc2 seems to produce the same results I'm afraid.
> 
> Alas.  Does suspend-to-disk ("echo disk >/sys/power/state") have the
> same problem?  Can you get a log of the failure with
> "no_console_suspend" appended to the kernel command line, for example
> with a serial console or netconsole?

(back on 3.2.0-0.bpo.2-686-pae 3.2.12-1~bpo60+1*:)

eth0 seems to go down/come up to early/late to get anything useful from netconsole:

[  745.161322] PM: Syncing filesystems ... done.
[  747.088247] PM: Preparing system for mem sleep
[  747.187932] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  747.204325] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  747.220416] PM: Entering mem sleep
[  747.221085] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[  747.222247] sd 1:0:0:0: [sda] Stopping disk

(then nothing)

I may be able to hook up a usb-serial adaptor to try and get more info but it'll take me a bit longer what with all the rewiring fun as I don't have a null modem cable lying around.

> If someone has time to go through the steps in
> "Documentation/power/basic-pm-debugging.txt", that would also be useful.

"freezer", "devices", "platform", "processors", or "core" pm_test modes all work fine, naturally.


robert.

* I notice I accidentally copy/pasted the linux-modules version in a previous mail but you knew what I was talking about
