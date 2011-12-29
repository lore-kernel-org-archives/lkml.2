Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab1L2MKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 07:10:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62351 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab1L2MKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 07:10:06 -0500
Date: Thu, 29 Dec 2011 06:09:56 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
        Phil Miller <mille121@illinois.edu>
Subject: Re: [27/27] clockevents: Set noop handler in
 clockevents_exchange_device()
Message-ID: <20111229120956.GA31878@elie.Belkin>
References: <20111207165611.GA19872@kroah.com>
 <20111207165602.672902223@clark.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207165602.672902223@clark.kroah.org>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Greg KH wrote:

> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Thomas Gleixner <tglx@linutronix.de>
>
> commit de28f25e8244c7353abed8de0c7792f5f883588c upstream.
[...]
> --- a/kernel/time/clockevents.c
> +++ b/kernel/time/clockevents.c
> @@ -221,6 +221,7 @@ void clockevents_exchange_device(struct
>  	 * released list and do a notify add later.
>  	 */
>  	if (old) {
> +		old->event_handler = clockevents_handle_noop;
>  		clockevents_set_mode(old, CLOCK_EVT_MODE_UNUSED);

This is basically the reverse of 7c1e768974 (clockevents: prevent
clockevent event_handler ending up handler_noop, 2008-09-03).  The
rationale for the latter still applies.  People have been reporting
the analagous patch to this one causing hangs on resume in 3.1.y and
3.2 release candidates:

 - http://thread.gmane.org/gmane.linux.kernel/1233033
 - http://thread.gmane.org/gmane.linux.kernel/1233389
 - http://thread.gmane.org/gmane.linux.kernel/1233159
 - http://thread.gmane.org/gmane.linux.kernel/1227868/focus=1230877

So please consider reverting it for now.

Thanks,
Jonathan
