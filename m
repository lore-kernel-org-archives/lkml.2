Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab2CAXlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 18:41:51 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:35824 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205Ab2CAXlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 18:41:49 -0500
Date: Thu, 1 Mar 2012 15:41:48 -0800 (PST)
From: Andrei Warkentin <awarkentin@vmware.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrei Warkentin <andreiw@vmware.com>,
        kgdb-bugreport@lists.sourceforge.net, Matt Mackall <mpm@selenic.com>,
        Andrei Warkentin <andrey.warkentin@gmail.com>
Message-ID: <1659130373.1834747.1330645308581.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <4F4FF712.2030400@windriver.com>
Subject: Re: [PATCHv3 1/3] NETPOLL: Extend rx_hook support.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.60.13]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

----- Original Message -----
> From: "Jason Wessel" <jason.wessel@windriver.com>
> To: "Andrei Warkentin" <awarkentin@vmware.com>
> Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, "Andrei Warkentin" <andreiw@vmware.com>,
> kgdb-bugreport@lists.sourceforge.net, "Matt Mackall" <mpm@selenic.com>, "Andrei Warkentin"
> <andrey.warkentin@gmail.com>
> Sent: Thursday, March 1, 2012 5:24:18 PM
> Subject: Re: [PATCHv3 1/3] NETPOLL: Extend rx_hook support.

> > I did have a question, because it seems you were using qemu / kvm.
>   I have a number of test cases that use kvm, but the netkkgdb does
> not seem to work with the nc.  My question is how am I supposed to
> actually use the netkgdb?
> 
> Here is what I observe on the target system:
> 
> insmod netkgdb.ko netkgdb=@/,@10.0.2.2/
> echo g > /proc/sysrq-trigger
> 
> On my host system:
> nc.traditional -l -u -p 7777
> 
> I will type help, and then the netkgdb is toast.  It doesn't seem to
> respond anymore.
> 

Strange. I've just repeated your steps (I didn't build as a ko before, but now I did)
and I don't see this problem. Can you tell me your qemu/kvm command line?

With qemu I've see odd behavior with ne2k_pci, which is the default
(qemu would wedge) occasionally. If you are using ne2000, can you try rtl8139?
Note: I just tried ne2k_pci, and other than having to specify a local 
IP address (something I don't need to for rtl8139). I've also realized
that if you insert netkgdb as a module without any parameters, it
doesn't bind to existing netdevs - that's a bug.

Anything I should know about your network topology?

Can you also apply the multi-I/O-backend patch and boot with kgdboc=kbd, and
see if the VM is toast after you type "help".

A
