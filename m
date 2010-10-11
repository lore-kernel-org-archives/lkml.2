Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab0JKWoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:44:05 -0400
Received: from smtp-out.google.com ([74.125.121.35]:6088 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab0JKWoC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:44:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EqKZ9NfZt7HmWskQxLHmepcgYwGJyCH28bpNDzZvP9cGlg98HsolcfbhqtUMYIT3FM
         b/yaJ33lHjP2GurEcm+w==
MIME-Version: 1.0
In-Reply-To: <20101011152534.6cf01208.akpm@linux-foundation.org>
References: <1286265215-9025-1-git-send-email-walken@google.com>
	<1286265215-9025-3-git-send-email-walken@google.com>
	<4CAB628D.3030205@redhat.com>
	<AANLkTimdACZ9Xm01DM2+E64+T5XfLffrkFBhf7CJ286p@mail.gmail.com>
	<20101008043956.GA25662@google.com>
	<4CAF1B90.3080703@redhat.com>
	<AANLkTinWxTT=+m_fAudc080OUMwacSefnMbSMBFZgPMH@mail.gmail.com>
	<20101009012204.GA17458@google.com>
	<20101011152534.6cf01208.akpm@linux-foundation.org>
Date: Mon, 11 Oct 2010 15:43:56 -0700
Message-ID: <AANLkTi=cm8jQ5hY5qVA0bUvVemUGJvx-_B7-1sexGkvB@mail.gmail.com>
Subject: Re: [PATCH 2/3] Retry page fault when blocking on disk transfer.
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        Ying Han <yinghan@google.com>, linux-kernel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 3:25 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> Replacement patches are a bit cruel to people who've already reviewed
> the previous version.  I always turn them into deltas so I can see what
> was changed.  It is below.

Thanks Andrew. Sorry for the trouble, I'll know to avoid this next time.

> How well was the new swapin path tested?

Not as well as the file backed path - it's not gotten real production
use yet. However the plan is that this change will be in google's next
kernel update, so it will get a lot more more testing soon (starting
in ~1 week).

I did basic testing by dirtying an anon VMA larger that memory, then
accessing it in random order while another thread runs a mmap/munmap
loop, and checking that things behave as expected there (i.e. the
patch allows the mmap/munmap thread to progress without waiting for
the other thread swap-ins).

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
