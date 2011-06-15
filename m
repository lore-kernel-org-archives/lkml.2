Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab1FOKUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 06:20:50 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:53017 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab1FOKUt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 06:20:49 -0400
Date: Wed, 15 Jun 2011 12:20:46 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Wanlong Gao <wanlong.gao@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        linux-fbdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Possible deadlock when suspending framebuffer
Message-ID: <20110615122046.70e1ee17@pluto.restena.lu>
In-Reply-To: <BANLkTinE+EZ9nr1qGKC0VY0bVHuF8U-R0w@mail.gmail.com>
References: <1308100165.2113.4.camel@Tux>
	<20110615075803.3348b4ec@pluto.restena.lu>
	<BANLkTinE+EZ9nr1qGKC0VY0bVHuF8U-R0w@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jun 2011 09:12:46 Francis Moreau wrote:
> On Wed, Jun 15, 2011 at 7:58 AM, Bruno Prémont wrote:
> Well, sorry for the dumb question but the fb/fbcon code is pretty hard
> to follow for me.

Certainly not just for you

> Why does store_fbstate() and any fb driver's suspsend methods acquire
> the console lock at all ?

>From my understanding, fbcon currently has very loose binding with
framebuffers in general instead of just with those few framebuffers
it is effectively mapped to (and active on!).
James Simmons started a complete rework of fbcon/tty code which is
expected to get things more fine-grained, until then console semaphore
(console_lock) remains a kind of big kernel lock in the
console/framebuffer area.

As such any state change of framebuffer may influence/race against
fbcon.
e.g. for the suspend state you want to avoid fbcon to fiddle with
your framebuffer while it is suspending (and have fbcon know about the
suspended state). This way fbcon can unsuspend framebuffer if needed
but also stop accessing it when it should not.

Bruno
