Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab1JLSH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 14:07:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:12996 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab1JLSHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 14:07:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,335,1315206000"; 
   d="scan'208";a="61580535"
Date: Wed, 12 Oct 2011 19:17:25 +0100
From: Alan Cox <alan@linux.intel.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH] 8250_pci: Fix kernel panic when pch_uart is disabled
Message-ID: <20111012191725.179db127@bob.linux.org.uk>
In-Reply-To: <1317962389-21786-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
References: <1317962389-21786-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 Oct 2011 13:39:49 +0900
Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com> wrote:

> Currently, ".setup" function is not set. 
> As a result, when detecting our IOH's uart device without pch_uart,
> kernel panic occurs at the following of pciserial_init_ports().
> 
> 	for (i = 0; i < nr_ports; i++) {
> 		if (quirk->setup(priv, board, &serial_port, i))
> 			break;
> 
> So, this patch adds the ".setup" function.
> We can use pci_default_setup because our IOH's uart is compatible
> with 16550.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>

Acked-by: Alan Cox <alan@linux.intel.com>
