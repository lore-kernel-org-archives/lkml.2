Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab2GXRyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 13:54:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34561 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab2GXRyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 13:54:15 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVMeRQ-Fwk03uVg5LOH193PF+AyCoAAxmXDpqjeZXi7nxw@mail.gmail.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
 <CA+55aFzKu6xhTPmKPTg+p36Su0GkZgzGWpnvhpsFXJzhp=R16w@mail.gmail.com> <CACVXFVMeRQ-Fwk03uVg5LOH193PF+AyCoAAxmXDpqjeZXi7nxw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Jul 2012 10:53:53 -0700
X-Google-Sender-Auth: rNJrj_18wDOPyCPPwfpk-4cgYS4
Message-ID: <CA+55aFypmnk8S4JkLui1Z7JxKae=-k88K-wEP9xDwrf1LOX-Vw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/13] firmware loader: introduce cache/uncache firmware
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 10:47 AM, Ming Lei <ming.lei@canonical.com> wrote:
>
> I remembered that Matthew objected caching firmware because he thought
> it can't solve the isight camera problem after warm reset. But now,
> this specific
> problem can be solved easily by letting its driver defer probe.

I really think the isight thing is a totally different thing entirely.

And quite frankly, that's just a BUG in the USB implementation. If the
USB ID changes, it shouldn't be considered a "resume" thing at all,
but a probe thing, and that should not be done in early resume - it
should be done *after* the resume is done.

The fact that USB confuses resuming existing devices and probing new
ones is just an implementation issue, and is a bug.

                       Linus
