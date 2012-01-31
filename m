Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab2AaAe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 19:34:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab2AaAeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 19:34:25 -0500
Date: Mon, 30 Jan 2012 16:34:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org,
        lars@metafoo.de, rpurdie@rpsys.net
Subject: Re: [PATCH v2] add LED driver for PCA9663 I2C chip
Message-Id: <20120130163424.ef8eb9af.akpm@linux-foundation.org>
In-Reply-To: <20120130162849.635c83a9.akpm@linux-foundation.org>
References: <1326916289-19004-1-git-send-email-pmeerw@pmeerw.net>
	<20120130162849.635c83a9.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 16:28:49 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > +exit:
> > +	while (i--) {
> > +		led_classdev_unregister(&pca9633[i].led_cdev);
> > +		cancel_work_sync(&pca9633[i].work);
> > +	}
> 
> This (untested!) loop has an off-by-one error. 

Well, it's partly wrong.  It's wrong for the cancel_work_sync() but not
for the led_classdev_unregister().  The cancel_work_sync() can just be
removed: we haven't scheduled any works yet.


