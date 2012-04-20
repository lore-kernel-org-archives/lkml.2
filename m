Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab2DTT5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 15:57:23 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51291 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab2DTT5V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 15:57:21 -0400
MIME-Version: 1.0
In-Reply-To: <1334950527-5050-3-git-send-email-asharma@fb.com>
References: <1334950527-5050-1-git-send-email-asharma@fb.com> <1334950527-5050-3-git-send-email-asharma@fb.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Apr 2012 12:57:00 -0700
X-Google-Sender-Auth: L66bZ_YywM4ZA8X81dQ4btqm4CI
Message-ID: <CA+55aFwE=-52Ld=KW6QKmSSfUnSd5Jw90xEouvNHT_kSFm3FFQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] perf, x86: Don't leak kernel data via callchains
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 12:35 PM, Arun Sharma <asharma@fb.com> wrote:
>
> +       set_fs(USER_DS);

NAK.

I really don't think this is the right thing to do. We're in random
NMI context, set_fs() is not at all necessarily safe.

No, the code needs to check the frame range by hand, not depend on current-fs.

In fact, I'd argue that this is a bug in copy_from_user_nmi(), which
should simply check the *user* address space explicitly, not using
access_ok().

                   Linus
