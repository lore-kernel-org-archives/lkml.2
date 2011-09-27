Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab1I0Kvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:51:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:10498 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab1I0Kvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:51:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="56987860"
Date: Tue, 27 Sep 2011 11:59:57 +0100
From: Alan Cox <alan@linux.intel.com>
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Cc: linux-serial@vger.kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tty/n_gsm: avoid fifo overflow in
 gsm_dlci_data_output
Message-ID: <20110927115957.5e6cb79c@bob.linux.org.uk>
In-Reply-To: <1316791376-4863-2-git-send-email-mikhail.kshevetskiy@gmail.com>
References: <1316791376-4863-1-git-send-email-mikhail.kshevetskiy@gmail.com>
	<1316791376-4863-2-git-send-email-mikhail.kshevetskiy@gmail.com>
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

On Fri, 23 Sep 2011 19:22:56 +0400
Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com> wrote:

> n_gsm use a simple approach: every writing to fifo correspond exactly
> one reading from fifo. There are no problem in this approach until we
> read less bytes then we write. As result fifo may owerflow. This
> leads to packet loss and very slow responce.

We do need to do something here but your change means a single DLCI
will hog the channel, so I think the while loop needs to be one layer
up.

Alan
