Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab1A0MJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 07:09:30 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:44172 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752243Ab1A0MJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 07:09:28 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 27 Jan 2011 13:09:45 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ping Cheng <pingc@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>, Chris Bagwell <chris@cnpbagwell.com>,
        Rafi Rubin <rafi@seas.upenn.edu>, Stephane Chatty <chatty@lii-enac.fr>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] input: evdev: Add EVIOC mechanism to extract the MT
 slot state
Message-ID: <20110127120945.GC15626@polaris.bitmath.org>
References: <1296124547-3323-1-git-send-email-benjamin.tissoires@enac.fr>
 <1296124547-3323-3-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296124547-3323-3-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.192.164
X-Scan-Result: No virus found in message 1PiQen-0002Ur-Af.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PiQen-0002Ur-Af cd6203726fdb8693c16bd366b794d0e9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 11:35:47AM +0100, Benjamin Tissoires wrote:
> This patch adds the ability to extract the MT slot state sequentially
> via EVIOCGABS. The slot parameter is first selected by calling
> EVIOCSABS with ABS_MT_SLOT as argument, followed by a set of EVIOCGABS
> calls. The slot selection is local to the evdev client handler, and
> does not affect the actual input state.

Ok - it seemed like a reasonable idea at the time, but..

> @@ -767,9 +769,10 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
>  			if (size < sizeof(struct input_absinfo))
>  				abs.resolution = 0;
>  
> -			/* We can't change number of reserved MT slots */
> -			if (t == ABS_MT_SLOT)
> -				return -EINVAL;
> +			if (t == ABS_MT_SLOT) {
> +				client->slot = abs.value;
> +				return 0;
> +			}

...this just does not look right. Perhaps there should really be a
different ioctl to retrieve the slot values instead. Dmitry?

Thanks,
Henrik
