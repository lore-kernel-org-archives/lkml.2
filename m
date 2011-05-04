Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1EDQtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:49:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49865 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab1EDQtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:49:24 -0400
Date: Wed, 4 May 2011 09:49:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: linux-next: Tree for May 4 (hyperv / vmbus)
Message-Id: <20110504094908.b8295d22.randy.dunlap@oracle.com>
In-Reply-To: <20110504144759.802483cc.sfr@canb.auug.org.au>
References: <20110504144759.802483cc.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DC1838B.0140:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011 14:47:59 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110503:


when CONFIG_ACPI is not enabled:


drivers/staging/hv/vmbus_drv.c:736: warning: 'struct acpi_device' declared inside parameter list
drivers/staging/hv/vmbus_drv.c:736: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/staging/hv/vmbus_drv.c: In function 'vmbus_acpi_add':
drivers/staging/hv/vmbus_drv.c:741: error: dereferencing pointer to incomplete type
drivers/staging/hv/vmbus_drv.c: At top level:
drivers/staging/hv/vmbus_drv.c:758: error: variable 'vmbus_acpi_driver' has initializer but incomplete type
drivers/staging/hv/vmbus_drv.c:759: error: unknown field 'name' specified in initializer
drivers/staging/hv/vmbus_drv.c:759: warning: excess elements in struct initializer
drivers/staging/hv/vmbus_drv.c:759: warning: (near initialization for 'vmbus_acpi_driver')
drivers/staging/hv/vmbus_drv.c:760: error: unknown field 'ids' specified in initializer
drivers/staging/hv/vmbus_drv.c:760: warning: excess elements in struct initializer
drivers/staging/hv/vmbus_drv.c:760: warning: (near initialization for 'vmbus_acpi_driver')
drivers/staging/hv/vmbus_drv.c:761: error: unknown field 'ops' specified in initializer
drivers/staging/hv/vmbus_drv.c:761: error: extra brace group at end of initializer
drivers/staging/hv/vmbus_drv.c:761: error: (near initialization for 'vmbus_acpi_driver')
drivers/staging/hv/vmbus_drv.c:763: warning: excess elements in struct initializer
drivers/staging/hv/vmbus_drv.c:763: warning: (near initialization for 'vmbus_acpi_driver')
drivers/staging/hv/vmbus_drv.c: In function 'vmbus_acpi_init':
drivers/staging/hv/vmbus_drv.c:771: error: implicit declaration of function 'acpi_bus_register_driver'
drivers/staging/hv/vmbus_drv.c: In function 'vmbus_acpi_exit':
drivers/staging/hv/vmbus_drv.c:780: error: implicit declaration of function 'acpi_bus_unregister_driver'
make[4]: *** [drivers/staging/hv/vmbus_drv.o] Error 1
make[3]: *** [drivers/staging/hv] Error 2





vmbus_drv.c sure looks like it requires (depends on) both ACPI and PCI.
That should be expressed somewhere in its Kconfig file.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
