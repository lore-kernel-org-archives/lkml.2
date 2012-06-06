Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758470Ab2FFVCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:02:39 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49602 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758447Ab2FFVCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:02:35 -0400
Date: Wed, 6 Jun 2012 16:55:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] xen/mce: Add mcelog support for Xen platform
Message-ID: <20120606205523.GA10891@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923351FEE7C@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923351FEE7C@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 12:57:44PM +0000, Liu, Jinsong wrote:
> >From 1a7951d6ca01d7f2c9dd2bdb6de5f8e7fdcb8bbd Mon Sep 17 00:00:00 2001
> From: root <root@ljsromley.bj.intel.com>
> Date: Fri, 1 Jun 2012 03:12:51 +0800
> Subject: [PATCH 1/2] xen/mce: Add mcelog support for Xen platform
> 
> When MCA error occurs, it would be handled by Xen hypervisor first,
> and then the error information would be sent to initial domain for logging.
> 
> This patch gets error information from Xen hypervisor and convert
> Xen format error into Linux format mcelog. This logic is basically
> self-contained, not touching other kernel components.
> 
> By using tools like mcelog tool users could read specific error information,
> like what they did under native Linux.
> 
> To test follow directions outlined in Documentation/acpi/apei/einj.txt

[   53.264610] switch: port 1(eth0) entered forwarding state
[ 1058.051938] BUG: sleeping function called from invalid context at /home/konrad/linux/include/linux/kernel.h:199
[ 1058.052066] in_atomic(): 1, irqs_disabled(): 0, pid: 4552, name: mcelog
[ 1058.052130] Pid: 4552, comm: mcelog Tainted: G           O 3.5.0-rc1upstream-00041-ga16e594-dirty #2
[ 1058.052235] Call Trace:
[ 1058.052291]  [<ffffffff8109ad9a>] __might_sleep+0xda/0x100
[ 1058.052349]  [<ffffffff8132a55b>] xen_mce_chrdev_read+0xab/0x140
[ 1058.052408]  [<ffffffff81148d85>] vfs_read+0xc5/0x190
[ 1058.052461]  [<ffffffff81148f4c>] sys_read+0x4c/0x90
[ 1058.052515]  [<ffffffff815bdd79>] system_call_fastpath+0x16/0x1

?
