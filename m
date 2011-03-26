Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab1CZQtA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 12:49:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752575Ab1CZQs7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 12:48:59 -0400
MIME-Version: 1.0
In-Reply-To: <4D8D87B0.3080107@fusionio.com>
References: <4D8B4A89.80608@fusionio.com> <AANLkTi=zJbUpcT+vbLARyxhA34F1se8pYq9No799Zqzh@mail.gmail.com>
 <4D8D87B0.3080107@fusionio.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 26 Mar 2011 09:48:37 -0700
Message-ID: <AANLkTi=jcm8pLQCTwYPK_Ey1SbMYSqQhYD4fJmCNz7sS@mail.gmail.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 11:29 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
> +
> +       /* Use 3ms as that was the old plug delay */
> +       blk_delay_queue(q, msecs_to_jiffies(3));

That's bogus. blk_delay_queue() already takes msecs, not jiffies.

Also, do we really need to delay every unplug like this? It seems sad.
A 3ms delay is a long time these days - admittedly most people
hopefully use ATA these days if they have an SSD or something, but
still..

                  Linus
