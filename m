Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab1LZRmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 12:42:21 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:24239 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751902Ab1LZRmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 12:42:20 -0500
X-IronPort-AV: E=Sophos;i="4.71,411,1320620400"; 
   d="scan'208";a="136907041"
Date: Mon, 26 Dec 2011 18:42:17 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: question about lqasc_release_port in drivers/tty/serial/lantiq.c
Message-ID: <alpine.DEB.2.02.1112261839190.1873@localhost6.localdomain6>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function lqasc_release_port in the file drivers/tty/serial/lantiq.c is 
defined as follows:

static void
lqasc_release_port(struct uart_port *port)
{
  	if (port->flags & UPF_IOREMAP) {
         	iounmap(port->membase);
 		port->membase = NULL;
 	}
}

But port->membase is initialized using devm_ioremap_nocache, implying that 
it should be freed with devm_ioremap.  devm_ioremap, however, requires an 
additional &pdev->dev argument.  Maybe the call to iounmap is not needed 
at all?

julia
