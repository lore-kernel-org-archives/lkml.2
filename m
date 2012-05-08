Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab2EHP0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:26:01 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51061 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688Ab2EHPZ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:25:59 -0400
MIME-Version: 1.0
In-Reply-To: <1336432421-17972-1-git-send-email-marcheu@chromium.org>
References: <1336432421-17972-1-git-send-email-marcheu@chromium.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 May 2012 08:25:38 -0700
X-Google-Sender-Auth: CO7ul8nEIRoKJWrm1nzR8VWowbk
Message-ID: <CA+55aFyd08=eemQsUFvtjerEVQdznhe647w4PmSrPkkEvjNuzg@mail.gmail.com>
Subject: Re: [PATCH] mm: Work around Intel SNB GTT bug with some physical pages.
To: =?ISO-8859-1?Q?St=E9phane_Marchesin?= <marcheu@chromium.org>
Cc: linux-kernel@vger.kernel.org, keithp@keithp.com, seanpaul@chromium.org,
        olofj@chromium.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 7, 2012 at 4:13 PM, Stéphane Marchesin <marcheu@chromium.org> wrote:
>
> In the end, I came up with the ugly workaround of just leaking the
> offending pages in shmem.c.

Don't leak it.

Instead, add it to some RCU list, and free it using RCU. Or some
one-second timer or something.

That kind of approach should guarantee that it

 (a) gets returned to the system

but

 (b) the returning to the system gets delayed sufficiently that if the
i915 driver is doing lots of allocations it will be getting other
pages.

Hmm?

              Linus
