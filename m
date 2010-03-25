Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab0CYSOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 14:14:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37812 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751604Ab0CYSON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 14:14:13 -0400
Date: Thu, 25 Mar 2010 18:16:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Giel van Schijndel <me@mortis.eu>
Cc: Hans de Goede <hdegoede@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] resource: shared I/O region support
Message-ID: <20100325181633.0313b8a5@lxorguk.ukuu.org.uk>
In-Reply-To: <20100325180347.GA2761@salidar.me.mortis.eu>
References: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk>
	<1269523063-30346-1-git-send-email-me@mortis.eu>
	<20100325155705.1ec79dbc@lxorguk.ukuu.org.uk>
	<20100325180347.GA2761@salidar.me.mortis.eu>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Always fun reviewing your own code ;-)
> 
> New patch attached.
> 
> One question though. I did some reading in
> Documentation/memory-barriers.txt and think it is correct *not* to call
> set_current_state(TASK_INTERRUPTIBLE) after schedule() finishes. Could
> you confirm or deny that?

After the schedule() returns we will be in TASK_RUNNING which is where we
want to be ...


> +			if (res->flags & IORESOURCE_MUXED)
> +				wake_up(&muxed_resource_wait);
>  			kfree(res);
>  			return;

And you'll want a

Signed-off-by: Alan Cox <alan@linux.intel.com>


>  		}


-- 
--
	"Alan, I'm getting a bit worried about you."
				-- Linus Torvalds
