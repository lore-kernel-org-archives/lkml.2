Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab1FFMWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 08:22:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:23444 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab1FFMWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:22:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,326,1304319600"; 
   d="scan'208";a="7739619"
Date: Mon, 6 Jun 2011 13:09:45 +0100
From: Alan Cox <alan@linux.intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: 8250, increase PASS_LIMIT
Message-ID: <20110606130945.7ad9edef@bob.linux.org.uk>
In-Reply-To: <1307307109-27776-1-git-send-email-jslaby@suse.cz>
References: <1307307109-27776-1-git-send-email-jslaby@suse.cz>
Organization: Intel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  5 Jun 2011 22:51:49 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> From: Jiri Slaby <jirislaby@gmail.com>
> 
> With virtual machines like qemu, it's pretty common to see "too much
> work for irq4" messages nowadays. This happens when a bunch of output
> is printed on the emulated serial console. This is caused by too low
> PASS_LIMIT. When ISR loops more than the limit, it spits the message.
> 
> I've been using a kernel with doubled the limit and I couldn't see no
> problems. Maybe it's time to get rid of the message now?

We need a limit to deal with hangs caused by misconfiguration /
mis-detection on ISA ports in particular but we can certainly bump the
limit to handle poor emulations.
