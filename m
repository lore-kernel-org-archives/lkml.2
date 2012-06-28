Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab2F1WDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 18:03:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2F1WDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 18:03:43 -0400
Date: Thu, 28 Jun 2012 15:03:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Jack Steiner <steiner@sgi.com>
Subject: Re: [patch] sgi-xp: nested calls to spin_lock_irqsave()
Message-Id: <20120628150342.aaa4ad2d.akpm@linux-foundation.org>
In-Reply-To: <20120627135155.GA3464@sgi.com>
References: <20120627135155.GA3464@sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012 08:51:55 -0500
Robin Holt <holt@sgi.com> wrote:

> The code here has a nested spin_lock_irqsave().  It's not needed since
> IRQs are already disabled and it causes a problem because it means that
> IRQs won't be enabled again at the end.  The second call to
> spin_lock_irqsave() will overwrite the value of irq_flags and we can't
> restore the proper settings.

Please find large crayon and write on forehead "when fixing a bug,
be sure to describe the end-user impact of that bug".

Then others will have a chance of deciding whether the fix should be
backported.

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Robin Holt <holt@sgi.com>

I'm wondering if there should have been a Reported-by:dan in there. 
He's like that.

