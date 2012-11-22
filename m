Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab2KVSbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:31:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:31975 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab2KVSbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:31:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,299,1352102400"; 
   d="scan'208";a="252819532"
Date: Thu, 22 Nov 2012 11:08:57 +0000
From: Alan Cox <alan@linux.intel.com>
To: Jun Chen <jun.d.chen@intel.com>
Cc: Bi Chao <chao.bi@intel.com>, serial <linux-serial@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "russ.gorby" <russ.gorby@intel.com>
Subject: Re: [PATCH] serial: ifx6x60: Add modem power off function in the
 platform reboot process
Message-ID: <20121122110857.2f7c9804@bob.linux.org.uk>
In-Reply-To: <1353583163.23300.7.camel@chenjun-workstation>
References: <1353583163.23300.7.camel@chenjun-workstation>
Organization: Intel
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2012 06:19:23 -0500
Jun Chen <jun.d.chen@intel.com> wrote:

> 
> This patch add modem power off function in the reboot process
> according registering reboot callback to the reboot_notifier_list.
> Also realizing the spi shutdown function.

Need to unregister the reboot notifier in the ifx_spi_exit path. If the
driver module is unloaded you leave the callback present and the kernel
will call into freed memory.

Alan
