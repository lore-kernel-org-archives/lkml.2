Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab2CKNXA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 09:23:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59386 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab2CKNW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 09:22:58 -0400
MIME-Version: 1.0
In-Reply-To: <1331471665-22226-1-git-send-email-santoshprasadnayak@gmail.com>
References: <1331471665-22226-1-git-send-email-santoshprasadnayak@gmail.com>
Date: Sun, 11 Mar 2012 14:22:57 +0100
Message-ID: <CAFLxGvygW=DeSQbRq8Wbcdy5E3e4vYcN666_9oWgnuwzT1WKqw@mail.gmail.com>
Subject: Re: [PATCH] Video : Amba: Use in_interrupt() in clcdfb_sleep().
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: linux@arm.linux.org.uk, FlorianSchandinat@gmx.de,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 2:14 PM, santosh nayak
<santoshprasadnayak@gmail.com> wrote:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>
> Instead of "in_atomic()", we can use in_interrupt() to check whether
> its an interrupt context.

What is the benefit?

Your change turns clcdfb_sleep() into a ticking bomb.
If clcdfb_sleep() is called from an atomic section (e.g. under a
spinlock) it will call msleep()
and the whole thing explodes...

-- 
Thanks,
//richard
