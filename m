Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222Ab0FKMo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 08:44:59 -0400
Received: from 1wt.eu ([62.212.114.60]:33130 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab0FKMo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 08:44:57 -0400
Date: Fri, 11 Jun 2010 14:44:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: Henri =?iso-8859-1?Q?H=E4kkinen?= <henuxd@gmail.com>
Cc: gregkh@suse.de, peterhuewe@gmx.de, julia@diku.dk, sudhakar.raj@ti.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:panel: Fixed coding conventions.
Message-ID: <20100611124442.GF8636@1wt.eu>
References: <1276258909-20838-1-git-send-email-henuxd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1276258909-20838-1-git-send-email-henuxd@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 03:21:49PM +0300, Henri Häkkinen wrote:
> Fixed many coding convention issues as reported by checkpatch.pl tool.
> Many of the cleanups were hacky due to deeply nasted control structures.

NAK. With such a "cleanup", it becomes even harder to read, understand
and debug. Enforcing the 80-chars limit on an existing code generally
involves restructuring it differently. This might be appropriate, but
pushing all the right chars on the 80th column just for the sake of not 
crossing the bound is the worst that can be done.

Also, single-line comments such as below area really boring to read
when converted to multi-line :

>  #define KEYPAD_BUFFER	64
>  #define INPUT_POLL_TIME	(HZ/50)	/* poll the keyboard this every second */
>  #define KEYPAD_REP_START	(10)	/* a key starts to repeat after this times INPUT_POLL_TIME */
>  #define KEYPAD_REP_DELAY	(2)	/* a key repeats this times INPUT_POLL_TIME */

becomes :

> +#define INPUT_POLL_TIME		(HZ/50)	/* poll the keyboard this every
> +					   second */
> +#define KEYPAD_REP_START	(10)	/* a key starts to repeat after
> +					   this times INPUT_POLL_TIME */
> +#define KEYPAD_REP_DELAY	(2)	/* a key repeats this times
> +					   INPUT_POLL_TIME */

Better shorten the comments or put them on their own line.

Also, I particularly hate changes as below. Looks, it's counter-productive,
you added 9 lines of code, which means you reduced a 80x25 terminal by half.
And the tests and statements are unreadable :

> @@ -1182,12 +1252,21 @@ static ssize_t lcd_write(struct file *file,
>  						value = 0;
>  						while (*esc && cgoffset < 8) {
>  							shift ^= 4;
> -							if (*esc >= '0' && *esc <= '9')
> -								value |= (*esc - '0') << shift;
> -							else if (*esc >= 'A' && *esc <= 'Z')
> -								value |= (*esc - 'A' + 10) << shift;
> -							else if (*esc >= 'a' && *esc <= 'z')
> -								value |= (*esc - 'a' + 10) << shift;
> +							if (*esc >= '0' &&
> +							    *esc <= '9')
> +								value |=
> +								  (*esc - '0')
> +								  << shift;
> +							else if (*esc >= 'A' &&
> +								 *esc <= 'Z')
> +								value |=
> +								  (*esc - 'A' +
> +								   10) << shift;
> +							else if (*esc >= 'a' &&
> +								 *esc <= 'z')
> +								value |=
> +								  (*esc - 'a' +
> +								   10) << shift;

If the line length really cause you trouble, see if you can move that
to an inline function and keep the code readable.

Thanks,
Willy

