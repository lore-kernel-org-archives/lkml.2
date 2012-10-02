Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab2JBLph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:45:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:43009 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab2JBLpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:45:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,523,1344236400"; 
   d="scan'208";a="229491163"
Date: Tue, 2 Oct 2012 12:47:07 +0100
From: Alan Cox <alan@linux.intel.com>
To: <Vineet.Gupta1@synopsys.com>
Cc: <gregkh@linuxfoundation.org>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] serial/arc-uart: Add new driver
Message-ID: <20121002124707.32b70292@bob.linux.org.uk>
In-Reply-To: <1349154216-7906-1-git-send-email-vgupta@synopsys.com>
References: <1349154216-7906-1-git-send-email-vgupta@synopsys.com>
Organization: Intel
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.11; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/* Is this for UART emulation on ARC Instruction Set Simulator (ISS)
> */ +int __attribute__((weak)) running_on_iss;

Why not pass a quirks field in your platform data instead - much
cleaner than a global.
> +static void arc_serial_set_ldisc(struct uart_port *port, int ld)
> +{
> +}

If you don't need it just remove this one

> +	new->c_cflag &= ~(CMSPAR|CRTSCTS);

also force the CSIZE bits to CS8 if you only do 8N1.

Alan
