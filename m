Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab1F2GvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 02:51:16 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64489 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab1F2GvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 02:51:10 -0400
Subject: Re: [PATCH] UBI: new module ubiblk: block layer on top of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: David Wagner <david.wagner@free-electrons.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Jun 2011 09:52:01 +0300
In-Reply-To: <4E09BC89.40306@free-electrons.com>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
		<1308922482-14967-2-git-send-email-david.wagner@free-electrons.com>
	 <1309202771.24805.11.camel@koala> <4E09BC89.40306@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1309330325.23597.123.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-28 at 13:35 +0200, David Wagner wrote:
> Hi,
> 
> On 06/27/2011 09:26 PM, Artem Bityutskiy wrote:
> > On Fri, 2011-06-24 at 15:34 +0200, david.wagner@free-electrons.com
> > wrote:
> >> +	/* Stolen from mtd_blkdevs.c */
> >> +	/* Create processing thread */
> >> +	dev->thread = kthread_run(ubi_ubiblk_thread, dev, "%s%d_%d",
> >> +				  "kubiblkd", dev->ubi_num, dev->vol_id);
> >> +	if (IS_ERR(dev->thread)) {
> >> +		ret = PTR_ERR(dev->thread);
> >> +		goto out_thread;
> >> +	}
> > 
> > Why we need a kernel thread? Could you please describe when exactly it
> > is needed and why we cannot avoid having it?
> 
> Do you mean that there could be another/better way ?

No, I just do not understand why it is there. I think this is juts block
layer's design, but I wanted you to explain this - the design, how block
requests are handled, and where exactly the thread is needed. I expected
you just have the explanation.

-- 
Best Regards,
Artem Bityutskiy

