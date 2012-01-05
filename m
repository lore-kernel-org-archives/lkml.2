Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab2AEMkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 07:40:52 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:39097 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277Ab2AEMkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 07:40:51 -0500
MIME-Version: 1.0
In-Reply-To: <84FF21A720B0874AA94B46D76DB98269045542B5@008-AM1MPN1-003.mgdnok.nokia.com>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
	<20120104195612.GB19181@suse.de>
	<84FF21A720B0874AA94B46D76DB98269045542B5@008-AM1MPN1-003.mgdnok.nokia.com>
Date: Thu, 5 Jan 2012 14:40:49 +0200
X-Google-Sender-Auth: w_STJzUaLNbyRW1BDus88D-A29M
Message-ID: <CAOJsxLEdTMB6JtYViRJq5gZ4_w5aaV18S3q-1rOXGzaMtmiW6A@mail.gmail.com>
Subject: Re: [PATCH 3.2.0-rc1 0/3] Used Memory Meter pseudo-device and related
 changes in MM
From: Pekka Enberg <penberg@kernel.org>
To: leonid.moiseichuk@nokia.com
Cc: gregkh@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        cesarb@cesarb.net, kamezawa.hiroyu@jp.fujitsu.com, emunson@mgebm.net,
        aarcange@redhat.com, riel@redhat.com, mel@csn.ul.ie,
        rientjes@google.com, dima@android.com, rebecca@android.com,
        san@google.com, akpm@linux-foundation.org, vesa.jaaskelainen@nokia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 1:47 PM,  <leonid.moiseichuk@nokia.com> wrote:
> As I understand AOOM it wait until situation is reached bad conditions which
> required memory reclaiming, selects application according to free memory and
> oom_adj level and kills it.  So no intermediate levels could be checked (e.g.
> 75% usage),  nothing could be done in user-space to prevent killing, no
> notification for case when memory becomes OK.
>
> What I try to do is to get notification in any application that memory
> becomes low, and do something about it like stop processing data, close
> unused pages or correctly shuts applications, daemons.  Application(s) might
> have necessity to install several notification levels, so reaction could be
> adjusted based on current utilization level per each application, not
> globally.

Sure. However, from VM point of view, both have the exact same
functionality: detect when we reach low memory condition (for some
configurable threshold) and notify userspace or kernel subsystem about
it.

That's the part I'd like to see implemented in mm/notify.c or similar.
I really don't care what Android or any other folks use it for exactly
as long as the generic code is light-weight, clean, and we can
reasonably assume that distros can actually enable it.
