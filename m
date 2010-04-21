Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab0DUV40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:56:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323Ab0DUV4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:56:24 -0400
Date: Wed, 21 Apr 2010 14:55:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: axel.lin@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Eric Miao <eric.miao@marvell.com>
Subject: Re: [PATCH] max732x: Correct nr_port checking off by one error
Message-Id: <20100421145552.72307e9c.akpm@linux-foundation.org>
In-Reply-To: <q2t427d64721004120029n91bb5bcg1416b34dda1a28be@mail.gmail.com>
References: <q2t427d64721004120029n91bb5bcg1416b34dda1a28be@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Apr 2010 15:29:16 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> Setup both client_group_a and client_group_b if nr_port > 8 (not
> including nr_port==8).
> 

OK, that's what the patch does.  But why does it do it?

In other words, when fixing a bug, please include a description of that
bug!  And, if it's not obvious from the description, please also describe
the user-visible effects of that bug.  So the poor schmuck at the other
end (ie: me) can work out which kernel(s) the fix should be merged
into.

> 
> diff --git a/drivers/gpio/max732x.c b/drivers/gpio/max732x.c
> index f786824..51b02c6 100644
> --- a/drivers/gpio/max732x.c
> +++ b/drivers/gpio/max732x.c
> @@ -285,14 +285,14 @@ static int __devinit max732x_probe(struct
> i2c_client *client,

The patch is wordwrapped.

>         switch (client->addr & 0x70) {
>         case 0x60:
>                 chip->client_group_a = client;
> -               if (nr_port > 7) {
> +               if (nr_port > 8) {

And has its tabs replaced with spaces.  sorry-youre-using-gmail.

Please see if you can get that fixed up for next time
(Documentation/email-clients.txt has some tips).  Worst-case, use
text/plain attachments.

Thanks.

