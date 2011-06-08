Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500Ab1FHQSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 12:18:33 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:34441 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751313Ab1FHQSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 12:18:31 -0400
X-Sasl-enc: 2NaS8qt78Q94YDPeyPDCY5MD0P3hqUhgYD0/nJeLrGH5 1307549910
Date: Wed, 8 Jun 2011 09:11:27 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Igor M. Liplianin" <liplianin@netup.ru>
Subject: Re: linux-next: build failure after merge of the staging.current tree
Message-ID: <20110608161127.GD21645@kroah.com>
References: <20110608114130.444a7f99.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110608114130.444a7f99.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 11:41:30AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the staging.current tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/media/video/cx23885/cx23885-cards.c:28:28: fatal error: staging/altera.h: No such file or directory
> 
> Caused by commit 85ab9ee946da ("Staging: altera: move .h file to proper
> place").
> 
> I have used the staging.current tree from next-20110607 for today.

Ok, sorry about that.

Mauro, Igor, why would another driver need to reference a .h file of a
staging driver?  I'll patch it right now to point to the proper place
(down in the staging tree), but it would be good to resolve this
"properly" somehow.

Next time, please never include a staging driver that isn't
self-contained, and don't create include/staging/ that's not acceptable.

thanks,

greg k-h
