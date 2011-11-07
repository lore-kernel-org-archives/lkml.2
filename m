Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab1KGLrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 06:47:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:6010 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab1KGLq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 06:46:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,469,1315206000"; 
   d="scan'208";a="81955062"
Date: Mon, 7 Nov 2011 11:58:02 +0000
From: Alan Cox <alan@linux.intel.com>
To: Ilya Zykov <ilya@ilyx.ru>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Race condition in tty buffer's function
 flush_to_ldisc().
Message-ID: <20111107115802.23201d45@bob.linux.org.uk>
In-Reply-To: <4EB7BD9A.7070600@ilyx.ru>
References: <4EB7BD9A.7070600@ilyx.ru>
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

On Mon, 07 Nov 2011 15:14:34 +0400
Ilya Zykov <ilya@ilyx.ru> wrote:

> Function flush_to_ldisc() call disc->ops->receive_buf(),
> without tty->buf.lock and with TTY_FLUSHING bit set.

flush_to_ldisc is single threaded for a given tty. If you fail to
ensure that is the case everything breaks.

What cases does this occur ?

Also for the other patches do you have benchmarks yet ?

Alan
