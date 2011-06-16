Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab1FPPgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:36:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757252Ab1FPPgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:36:08 -0400
Date: Thu, 16 Jun 2011 09:36:10 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        christian.dietrich@informatik.uni-erlangen.de
Subject: Re: [PATCH 11/11] usb/class: use printk_ratelimited() instead of
 printk_ratelimit()
Message-ID: <20110616093610.0415834c@lembas.zaitcev.lan>
In-Reply-To: <3842dc0135657cd0b1ba08436a1c501c19ad0116.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
References: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
	<3842dc0135657cd0b1ba08436a1c501c19ad0116.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011 14:15:54 +0200
Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de> wrote:

> +++ b/drivers/usb/class/usblp.c
> @@ -348,8 +349,7 @@ static int usblp_check_status(struct usblp *usblp, int err)
>  	mutex_lock(&usblp->mut);
>  	if ((error = usblp_read_status(usblp, usblp->statusbuf)) < 0) {
>  		mutex_unlock(&usblp->mut);
> -		if (printk_ratelimit())
> -			printk(KERN_ERR
> +		printk_ratelimited(KERN_ERR
>  				"usblp%d: error %d reading printer status\n",

I wish you went a step further and placed the state into usblp,
but it works for now, ACK. I should've done it myself, really.

-- Pete
