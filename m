Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab2EQPEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:04:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48287 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933033Ab2EQPEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:04:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120517145519.GF21275@google.com>
References: <alpine.LNX.2.00.1205160932280.8796@pobox.suse.cz>
 <20120516170124.GA21275@google.com> <alpine.LNX.2.00.1205162133180.8796@pobox.suse.cz>
 <CA+55aFw-us7LnG-iq5EQmSDJ7xH9hiOMmCryAGobReko4LkVWg@mail.gmail.com>
 <20120516195332.GC21275@google.com> <alpine.LNX.2.00.1205162156120.8796@pobox.suse.cz>
 <20120516200147.GD21275@google.com> <alpine.LNX.2.00.1205162216390.8796@pobox.suse.cz>
 <20120516202924.GE21275@google.com> <CA+55aFyX3OgdcWuYQO+YuS3fF_Wt1p8w-G33C5MCkiR-3ncfVA@mail.gmail.com>
 <20120517145519.GF21275@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 May 2012 08:03:55 -0700
X-Google-Sender-Auth: r-YNr1JOJxEJdGEQ0VLfcpxxt0U
Message-ID: <CA+55aFz4Ckm+keZKRiBjCKKE-NHd94w4T5-HXipi=wovmwhnSA@mail.gmail.com>
Subject: Re: [PATCH] floppy: convert to delayed work and single-thread wq
To: Tejun Heo <tj@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 7:55 AM, Tejun Heo <tj@kernel.org> wrote:
>
> They're not being serialized.

If they aren't serialized, they are useless for floppy for other
reasons. There are *three* work item for the floppy driver, and the
whole point was to serialize them.

                      Linus
