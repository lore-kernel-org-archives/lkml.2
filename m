Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1BUNv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 08:51:28 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41058 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab1BUNv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 08:51:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VsNQVwx92Wgdbmc2L3PwqMk+d9FcbSFdik7M3Mn/dLkV4zvruQRAdWutuaIUnRPl3P
         WpxRo69zIg0lzy5w0wwlwCjbddgWe3dPCaL+GVpd6y9XEfBkBqBAujtBBm65BxUmWpFz
         Liyvo9Q/OJvtWyzEE6BSbjpm/qtuW6BrlDNgE=
MIME-Version: 1.0
In-Reply-To: <20110221123049.GC23087@legolas.emea.dhcp.ti.com>
References: <1298283649-24532-1-git-send-email-dacohen@gmail.com>
	<1298283649-24532-2-git-send-email-dacohen@gmail.com>
	<AANLkTimwvgLvpvndCqcd_okA2Kk4cu7z4bD3QXTdgWJW@mail.gmail.com>
	<20110221123049.GC23087@legolas.emea.dhcp.ti.com>
Date: Mon, 21 Feb 2011 15:51:25 +0200
Message-ID: <AANLkTinc=ye2qZJ1esSta=xEGz_iEr73eg3qEES2S5P7@mail.gmail.com>
Subject: Re: [PATCH 1/1] headers: fix circular dependency between
 linux/sched.h and linux/wait.h
From: Alexey Dobriyan <adobriyan@gmail.com>
To: balbi@ti.com
Cc: David Cohen <dacohen@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, linux-omap@vger.kernel.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 2:30 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Mon, Feb 21, 2011 at 01:05:51PM +0200, Alexey Dobriyan wrote:

>> Just include <linux/sched.h> in your driver.
>> This include splitting in small pieces is troublesome as well.
>
> so, simply to call wake_up*() we need to know everything there is to
> know about the scheduler ?

"know everything" is exaggeration.
You add sched.h, if someone else haven't added it already via other headers.

File is misnamed, BTW. It should be called task-state.h or something.
And, again, TASK_COMM_LEN should be left alone.

> I rather have the split done and kill the circular dependency.

It's not circular for starters.
