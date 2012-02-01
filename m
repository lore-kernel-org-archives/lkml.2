Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab2BAXgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 18:36:04 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36044 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2BAXgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 18:36:02 -0500
MIME-Version: 1.0
In-Reply-To: <20120131122339.GG32010@elte.hu>
References: <20120121082857.GC32134@elte.hu> <CAMO-S2hq0jGeUdAzMizDOhYJvPSQ=8+HVTUVqzsBOJotxOWrUg@mail.gmail.com>
 <20120121165830.GA9216@elte.hu> <CAMO-S2iegkRWGcnDt0SZqJT3Y3JHQZcHfMY=THKMN7n4Ae0Fyw@mail.gmail.com>
 <CA+55aFz=KcR5ji3TBHyfAYxFg8PCjXbdLOWf7aXULYHW4pp2kg@mail.gmail.com>
 <CAMO-S2iRT+uRzzsQRmhhCs4WRefsfFirteeKXtgX3h+kuWi+eQ@mail.gmail.com>
 <CA+55aFyxbieV2-WpFNrEtwQ6gXbW7y_X9oW5N6FcEcxmQKA38g@mail.gmail.com>
 <20120131115855.5861bad7@pyramind.ukuu.org.uk> <20120131120922.GD32010@elte.hu>
 <20120131121820.58a1db97@pyramind.ukuu.org.uk> <20120131122339.GG32010@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Feb 2012 15:35:41 -0800
X-Google-Sender-Auth: aS9Dsw2undneKkOHKG8Fok0hhJo
Message-ID: <CA+55aFw4F-02NxbQHmpy0KtXxKc9++HutgVXd7nGe0G7NqG+Gw@mail.gmail.com>
Subject: Re: [PATCH] NVMe: Fix compilation on architecturs without readq/writeq
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Hitoshi Mitake <h.mitake@gmail.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Roland Dreier <roland@purestorage.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@parallels.com>,
        linux-kernel@vger.kernel.org, hpa@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 4:23 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> non-atomic sounds good to me too.

You both apparently missed the related discussion that some devices
really do care about order, even if they don't care about atomicity.

So we'd actually have two versions of the header file, one
little-endian, and one big-endian. Then the driver that knows it
doesn't need the atomic 'readq()' that is always defined, but wants a
low-bytes-first version would just do

   #include <linux/io64-little-endian.h>

(or "big-endian" if it wants to read/write high bits first). Most
drivers probably don't care, but apparently NVMe does.

                 Linus
