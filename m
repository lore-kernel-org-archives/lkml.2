Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab2FCOUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 10:20:34 -0400
Received: from solo.fdn.fr ([80.67.169.19]:54056 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab2FCOUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 10:20:33 -0400
Date: Sun, 3 Jun 2012 16:20:21 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Chris Yungmann <yungmann.chris@gmail.com>
Cc: w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@braille.uwo.ca,
        gregkh@linuxfoundation.org, speakup@braille.uwo.ca,
        linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org
Subject: Re: [PATCH] staging: speakup: fixed checkpatch and sparse warnings
 in selection.c
Message-ID: <20120603142021.GI4546@type.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Chris Yungmann <yungmann.chris@gmail.com>, w.d.hubbs@gmail.com,
	chris@the-brannons.com, kirk@braille.uwo.ca,
	gregkh@linuxfoundation.org, speakup@braille.uwo.ca,
	linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org
References: <1338658358-20402-1-git-send-email-yungmann.chris@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1338658358-20402-1-git-send-email-yungmann.chris@gmail.com>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Yungmann, le Sat 02 Jun 2012 12:32:38 -0500, a écrit :
> @@ -132,7 +132,7 @@ int speakup_paste_selection(struct tty_struct *tty)
>  	while (sel_buffer && sel_buffer_lth > pasted) {
>  		set_current_state(TASK_INTERRUPTIBLE);
>  		if (test_bit(TTY_THROTTLED, &tty->flags)) {
> -			if (in_atomic())
> +			if (in_interrupt())
>  				/* if we are in an interrupt handler, abort */
>  				break;
>  			schedule();

I'd rather keep in_atomic(), which is clearly known to be broken (see
TODO above).

Samuel
