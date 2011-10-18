Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab1JRVpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 17:45:12 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43425 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab1JRVpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 17:45:08 -0400
Date: Tue, 18 Oct 2011 14:45:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <kees@outflux.net>
Cc: linux-kernel@vger.kernel.org, Marco Stornelli <marco.stornelli@gmail.com>,
        Sergiu Iordache <sergiu@chromium.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: Re: [PATCH] ramoops: update parameters only after successful init
Message-Id: <20111018144505.6b46caf8.akpm@linux-foundation.org>
In-Reply-To: <20111018180126.GA20695@outflux.net>
References: <20111018180126.GA20695@outflux.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011 11:01:27 -0700
Kees Cook <kees@outflux.net> wrote:

> If a platform device exists on the system, but ramoops fails to attach to
> it, the module parameters are overridden before ramoops can fall back and
> try to use passed module parameters. Move update to end of init routine.

Modifying the module paremeters in this way seems like a Wrong Thing To
Do and a rather nasty hack.

I'd have thought that /sys/module/ramoops/parameters should reflect the
options which were provided to the module and should not be modified by
the kernel behind everyone's back.

If we wish to display the configuration which the driver acquired from
the platform data then sure, add an interface to do that.  But it's
wrong to go and pretend that this is what the user provided to
modprobe!

