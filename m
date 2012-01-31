Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab2AaEWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 23:22:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54977 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451Ab2AaEWY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 23:22:24 -0500
MIME-Version: 1.0
In-Reply-To: <1327963304-24828-1-git-send-email-asharma@fb.com>
References: <1327963304-24828-1-git-send-email-asharma@fb.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 30 Jan 2012 20:22:03 -0800
Message-ID: <CAErSpo54KRJbWEQ0fB_kuGx0qRQKWpH9d3mN=dPdiNfWH+Dhww@mail.gmail.com>
Subject: Re: [PATCH] net: Disambiguate kernel message
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Glauber Costa <glommer@parallels.com>, Ingo Molnar <mingo@elte.hu>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 2:41 PM, Arun Sharma <asharma@fb.com> wrote:
> Some of our machines were reporting:
>
> TCP: too many of orphaned sockets
>
> even when the number of orphaned sockets was well below the
> limit.
>
> We print a different message depending on whether we're out
> of TCP memory or there are too many orphan sockets.

This patch mentions pairs of messages that are almost the same, but
not quite.  If they're supposed to be different, I'd suggest making
them clearly different.  As it is, the differences look like careless
mistakes:

>                                printk(KERN_INFO "TCP: too many of orphaned "
>                                       "sockets\n");
> +                       printk(KERN_INFO "TCP: too many orphaned sockets\n");

> +                               printk(KERN_INFO "TCP: out of memory. "
> +                                      "Consider tuning tcp_mem\n");
>                        printk(KERN_INFO "Out of socket memory\n");

"too many orphaned sockets" is better English usage than "too many of ..."

Bjorn
