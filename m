Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab2AMSUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:20:15 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48369 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758627Ab2AMSUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:20:12 -0500
MIME-Version: 1.0
In-Reply-To: <1326474399-27278-3-git-send-email-miklos@szeredi.hu>
References: <1326474399-27278-1-git-send-email-miklos@szeredi.hu> <1326474399-27278-3-git-send-email-miklos@szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jan 2012 10:19:50 -0800
X-Google-Sender-Auth: r_qETzGuMV_7Qs_dADAEn6LQ9Dk
Message-ID: <CA+55aFy7xLkMThg8+G=e7v7x7WaHSkLWGRiRF8hCq4WEUHxymw@mail.gmail.com>
Subject: Re: [PATCH 2/2] cuse: implement memory mapping
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, htejun@gmail.com,
        david.henningsson@canonical.com, smcnam@gmail.com,
        gmane@colin.guthr.ie, jamescaldwell1@gmail.com,
        s.maddox@lantizia.me.uk, mszeredi@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 9:06 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Tejun Heo <htejun@gmail.com>
>
> This implements memory mapping of char devices.

I don't think this is how you want to do it.

It seems to maintain a page list of its own, and do the magic page
fault etc behavior. Which to me smells like a really bad design.

I would expect that what you actually want to do is to expose it as a
shared mmap, and depend on all the normal shmem support. Is there any
reason not to do that?

I guess you don't generally have big mappings, so an argument like
"that way you can page out pages etc" may not strike you as a very
strong argument, but I'd still prefer to at least see that approach
explored. Hmm?

                     Linus
