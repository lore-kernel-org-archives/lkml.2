Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289Ab2EJLmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 07:42:04 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27861 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab2EJLmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 07:42:02 -0400
Date: Thu, 10 May 2012 14:45:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH RESEND 2/3] kmsg: export printk records to the /dev/kmsg
 interface
Message-ID: <20120510114520.GA10111@mwanda>
References: <1336004981.4240.10.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336004981.4240.10.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 02:29:41AM +0200, Kay Sievers wrote:
> +	/* escape non-printable characters */
> +	for (i = 0; i < msg->text_len; i++) {
> +		char c = log_text(msg)[i];
> +
> +		if (c < ' ' || c >= 128)

Signed char type is never larger than 127.

> +			len += sprintf(user->buf + len, "\\x%02x", c);
> +		else
> +			user->buf[len++] = c;
> +	}
> +	user->buf[len++] = '\n';
> +
> +	if (msg->dict_len) {
> +		bool line = true;
> +
> +		for (i = 0; i < msg->dict_len; i++) {
> +			char c = log_dict(msg)[i];
> +
> +			if (line) {
> +				user->buf[len++] = ' ';
> +				line = false;
> +			}
> +
> +			if (c == '\0') {
> +				user->buf[len++] = '\n';
> +				line = true;
> +				continue;
> +			}
> +
> +			if (c < ' ' || c >= 128) {

Same.

> +				len += sprintf(user->buf + len, "\\x%02x", c);
> +				continue;
> +			}
> +

regards,
dan carpenter

