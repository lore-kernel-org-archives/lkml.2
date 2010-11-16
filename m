Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab0KPWTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 17:19:53 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61575 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932822Ab0KPWTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 17:19:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=fZrMz0pEycSYZnLaRm+oub08atZUQ2XFbVmKBHpnFlkFJGeC4x266KwnTMLIl2Ibrz
         bDJ2+cbRmqgrdFR3Mu+OgthcmzaDMzS7srVpbgkAGqOuqwrUqwKM5mk5uzPYrjItO7rK
         r8E031gDAuQBBkoEwXCpspYVP4X3ZJm19ayeM=
MIME-Version: 1.0
In-Reply-To: <cover.1289430026.git.luto@mit.edu>
References: <cover.1289430026.git.luto@mit.edu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 16 Nov 2010 17:19:30 -0500
X-Google-Sender-Auth: PcF7Zs3QlCUXRfkLqT9Cp8T-2tI
Message-ID: <AANLkTimM6EUeFiyaH=6bkes19LtYO6t1PJL_SE9Zt3-L@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Fix nouveau-related freezes
To: Ben Skeggs <bskeggs@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 6:04 PM, Andy Lutomirski <luto@mit.edu> wrote:
> Nouveau takes down my system quite reliably when any hotplug event occurs.
> The bug happens because the IRQ handler didn't acknowledge the hotplug
> state until the bottom half, so the card generated a new interrupt
> immediately, starving the bottom half and permanently starving that CPU
> (and hence the bottom half).
>
> Even with this fix, a lot of the IRQ code looks rather broken.
>
> This is tested on 2.6.36 (and makes the system stable for me), but it also
> applies cleanly to 2.6.37 (untested, but surely also necessary).  Fedora 14's
> 2.6.35 kernels seem to have to same problem for me, so I suspect that 2.6.35
> needs this fix as well.  (All of my tests are on an NV50 card.)
>
> Changes from v1:
>  - Ignore unrequested hotplug bits (I accidentally removed that part).
>  - Support newer hardware (untested -- Ben, can you check this?)

Just a quick ping: is this making its way to Linus (and stable)?  I've
been running it for five days through (literally, due to monitor bugs)
thousands of plug/unplug cycles with no ill effects.

(Can we *please* get rid of, or at least ratelimit, the
plugged/unplugged printk?  It's taking over my logs, and I'm almost
certain that it's not a driver bug.)

--Andy
