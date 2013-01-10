Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab3AJSVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 13:21:02 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:51703 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab3AJSVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 13:21:00 -0500
MIME-Version: 1.0
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A2A05C@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A2A05C@USINDEM103.corp.hds.com>
Date: Thu, 10 Jan 2013 10:20:58 -0800
Message-ID: <CA+8MBbKTHQJoeRVUGZr+rcXm+VwOw2vSG31Cwnrg-sc=CzLu9w@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] pstore: Avoid deadlock in panic and
 emergency-restart path
From: Tony Luck <tony.luck@gmail.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "ccross@android.com" <ccross@android.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 7:12 AM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
> +       if (pstore_cannot_block_path(reason)) {
> +               is_locked = spin_trylock_irqsave(&psinfo->buf_lock, flags);
> +               if (!is_locked) {
> +                       pr_err("pstore dump routine blocked in %s path, may corrupt error record\n"
> +                                      , in_nmi() ? "NMI" : why);
> +               }

My only quibble with this patchset is this message. The sentiment is
nice, but nobody will see it. kmsg_dump has already picked the
pieces of log_buf that will be saved to pstore - so this new message
won't be included.  I suppose it will show up on a serial console - but
if a user has a serial console, they don't need to use pstore.

But I don't think it is likely to hurt us (to get this far in a panic we already
printed a bunch of stuff to the console and I can't think of a credible
scenario where a few extra bytes would run into a problem that the
earlier messages didn't).

So:

Acked-by: Tony Luck <tony.luck@intel.com>

[Also Ack for part2 the touches efivars.c]

-Tony

[Or are you asking me to apply these rather than just Ack them??]
