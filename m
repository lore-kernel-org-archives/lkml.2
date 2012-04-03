Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2DCF45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 01:56:57 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:50598 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab2DCF4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 01:56:55 -0400
Date: Tue, 3 Apr 2012 07:56:51 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH 24/69] TTY: con3215, centralize allocation
Message-ID: <20120403055650.GB2700@osiris.boeblingen.de.ibm.com>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
 <1333367693-3244-25-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333367693-3244-25-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12040305-4966-0000-0000-000001ED0044
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 01:54:08PM +0200, Jiri Slaby wrote:
> There are two copies of allocations of device information. One of them
> is totally broken. See:
> raw->cdev = cdev;
> raw->inbuf = (char *) raw + sizeof(struct raw3215_info);
> memset(raw, 0, sizeof(struct raw3215_info));
> 
> It suggests that this path was never executed. The code uses both
> raw->cdev and raw->inbuf all over. And it is NULL due to the memset
> here, so it would panic immediately. I believe nobody used that driver
> without being a system console.
> 
> Either way, let us fix it by moving the allocations (and
> initializations) to a single place. This will save us some double
> initializations later too.
> 
> And while at it, initialize the timer properly -- once, at the
> allocation.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: linux390@de.ibm.com
> Cc: linux-s390@vger.kernel.org
> ---
>  drivers/s390/char/con3215.c |   74 +++++++++++++++++++++++--------------------
>  1 file changed, 39 insertions(+), 35 deletions(-)

Nice!

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>

