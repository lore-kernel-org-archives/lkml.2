Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab1HRWXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 18:23:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754598Ab1HRWW7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 18:22:59 -0400
MIME-Version: 1.0
In-Reply-To: <1313704516.15082.5.camel@mop>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org>
 <20110817115543.GA8745@redhat.com> <CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com>
 <20110817134516.GA14136@redhat.com> <20110818124353.GA2839@tango.0pointer.de>
 <20110818142508.GA30959@redhat.com> <1313691091.1107.9.camel@mop>
 <CA+55aFxGDbNOhNQJe_LpUMcJCGcW8qFFWzC9H0_KW26Xzb0cXw@mail.gmail.com> <1313704516.15082.5.camel@mop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Aug 2011 15:22:06 -0700
Message-ID: <CA+55aFyFnMRMuWSSpytwvpk9u5YysMRfTRELyhGX9grWbGyi6Q@mail.gmail.com>
Subject: Re: + prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
 .patch added to -mm tree
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Lennart Poettering <mzxreary@0pointer.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-man@vger.kernel.org, roland@hack.frob.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 2:55 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>> So NAK. We're not slowing down normal code for some new feature that
>> realistically will never be used by any normal applications.
>
> It will be used for all new service managers. UNIX is a pain if you want
> to watch your children regarding double-forking, if you are not init.

I'll believe that "all new service managers" when I see it. Until
then, a new feature is just that - a new feature. Which nobody uses.

> And it will clean up the mess the desktop stuff is putting in 'ps afx'.
> Here is the before/after output:
>
>  253 ?        Ss     0:00 /bin/dbus-daemon --system --address=systemd: --nofork --systemd-activation
>  294 ?        Sl     0:00 /usr/libexec/polkit-1/polkitd
>  328 ?        S      0:00 /usr/sbin/modem-manager
>  608 ?        Sl     0:00 /usr/libexec/colord
>  658 ?        Sl     0:00 /usr/libexec/upowerd
>  819 ?        Sl     0:00 /usr/libexec/imsettings-daemon
>  916 ?        Sl     0:00 /usr/libexec/udisks-daemon
>  917 ?        S      0:00  \_ udisks-daemon: not polling any devices
>
>
>  294 ?        Ss     0:00 /bin/dbus-daemon --system --address=systemd: --nofork --systemd-activation
>  426 ?        Sl     0:00  \_ /usr/libexec/polkit-1/polkitd
>  449 ?        S      0:00  \_ /usr/sbin/modem-manager
>  635 ?        Sl     0:00  \_ /usr/libexec/colord
>  705 ?        Sl     0:00  \_ /usr/libexec/upowerd
>  959 ?        Sl     0:00  \_ /usr/libexec/udisks-daemon
>  960 ?        S      0:00  |   \_ udisks-daemon: not polling any devices
>  977 ?        Sl     0:00  \_ /usr/libexec/packagekitd

Yeah, that looks like a nice feature.

> If you want, we can make the forked processes inherit a flag if the
> 'subreaper' should be looked up at all. Then we have almost zero
> overhead if the feature isn't used. You think that's needed?

Yes, I do. Because with any current system, that "almost zero
overhead" is just totally wasted effort entirely for zero gain. Which
just makes me go "Eww".

             Linus
