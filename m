Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab0FGSN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:13:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57590 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab0FGSN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:13:27 -0400
Date: Mon, 7 Jun 2010 11:11:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.COM>
To: Greg KH <gregkh@suse.de>
Cc: Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Support kernel/hotplug sysctl variable when !CONFIG_NET
Message-Id: <20100607111145.1b98fdb4.randy.dunlap@oracle.com>
In-Reply-To: <20100607174350.GA7807@suse.de>
References: <1275911832-11667-1-git-send-email-abbotti@mev.co.uk>
	<20100607174350.GA7807@suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090202.4C0D36C0.0010:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jun 2010 10:43:50 -0700 Greg KH wrote:

> On Mon, Jun 07, 2010 at 12:57:12PM +0100, Ian Abbott wrote:
> > From: Ian Abbott <abbotti@mev.co.uk>
> > 
> > The kernel/hotplug sysctl variable (/proc/sys/kernel/hotplug file) was
> > made conditional on CONFIG_NET by commit
> > f743ca5e10f4145e0b3e6d11b9b46171e16af7ce (applied in 2.6.18) to fix
> > problems with undefined references in 2.6.16 when CONFIG_HOTPLUG=y &&
> > !CONFIG_NET, but this restriction is no longer needed.

Ack, builds for me on x86_64 when CONFIG_NET is not enabled.

> Why is this restriction no longer needed?  What changed?


commit cd3772e6898c6386f21d2958346d6dd57d4204f5
Author: Ming Lei <tom.leiming@gmail.com>
Date:   Sun Nov 16 18:22:09 2008 +0800

    kernel/ksysfs.c:fix dependence on CONFIG_NET
    
    Access to uevent_seqnum and uevent_helper does not need to
    depend on CONFIG_NET, so remove it.
    
    Signed-off-by: Ming Lei <tom.leiming@gmail.com>
    Cc: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


> > This patch makes the kernel/hotplug sysctl variable depend only on
> > CONFIG_HOTPLUG.
> 
> Why is this needed?  Are you really running without a network and still
> want to change the default /sbin/hotplug binary?
> 
> confused,


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
