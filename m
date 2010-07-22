Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab0GVXK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 19:10:59 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52520 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab0GVXK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 19:10:58 -0400
MIME-Version: 1.0
In-Reply-To: <20100722214821.GB14303@count0.beaverton.ibm.com>
References: <20100722182638.GA12712@kroah.com> <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com> 
	<20100722183614.GA5443@suse.de> <AANLkTimbcuzH6_bBhYX0U6vqftYgRwE0ZTmcbaRNzXef@mail.gmail.com> 
	<20100722185301.GA528@suse.de> <AANLkTik07hZot_x0p7xJuY8s4f8pGRd2Mn1+jYfHH2iq@mail.gmail.com> 
	<20100722191200.GA5609@suse.de> <20100722214821.GB14303@count0.beaverton.ibm.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 23 Jul 2010 01:10:43 +0200
Message-ID: <AANLkTikluqTBi3XsU-OT_IJuBdkURkHpM3ut-8ratnzr@mail.gmail.com>
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Greg KH <gregkh@suse.de>, Paul Menage <menage@google.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 23:48, Matt Helsley <matthltc@us.ibm.com> wrote:
> So I'd suggest
> those cgroup mounts go in /var/run/systemd/cgroup or something like that.

Impossible, we need it at bootup, and / is usually read-only, and /var
might even be behind the network we need to bring up.

It needs to be on tmpfs mounted on the rootsfs, or in any of the
virtual fss we have to mount anyway, so /sys/fs seems a good place.

Kay
