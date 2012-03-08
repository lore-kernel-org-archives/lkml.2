Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab2CHQQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 11:16:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab2CHQQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 11:16:04 -0500
Date: Thu, 8 Mar 2012 17:08:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Dmitry ADAMUSHKA (EXT)" <dmitry.adamushka_ext@softathome.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ralf Baechle <ralf@linux-mips.org>,
        wouter cloetens <wouter.cloetens@softathome.com>,
        linux-kernel@vger.kernel.org,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: 'khelper' (child) is stuck in endless loop: do_signal() and
	!user_mode(regs)
Message-ID: <20120308160843.GA12204@redhat.com>
References: <1587824623.61690.1331219566458.JavaMail.root@storentr1.softathome.com> <1382936138.61931.1331222140282.JavaMail.root@storentr1.softathome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382936138.61931.1331222140282.JavaMail.root@storentr1.softathome.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Dmitry ADAMUSHKA (EXT) wrote:
>
> And to simplify a real-life test case: it's enough for khelper's child task,
> while it's running in ____call_usermodehelper(), to receive SIGKILL.
> In this case, do_execve_common() will fail - there are a number of
> fatal_signal_pending(current) checks in there.

Actually there is no difference, SIGUSR1 equally kills the task and
makes fatal_signal_pending() true. The handler is SIG_DFL after
flush_signal_handlers(), complete_signal() adds SIGKILL implicitely.

Not that this actually matters.

Oleg.

