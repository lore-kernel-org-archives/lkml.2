Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966231Ab2JZTlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 15:41:36 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42276 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab2JZTlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 15:41:35 -0400
MIME-Version: 1.0
In-Reply-To: <508AE611.3020504@mvista.com>
References: <1350420820-7156-1-git-send-email-minyard@acm.org>
 <1350420820-7156-5-git-send-email-minyard@acm.org> <20121022164902.9b204646.akpm@linux-foundation.org>
 <508AE611.3020504@mvista.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Oct 2012 12:41:13 -0700
X-Google-Sender-Auth: 6RvVep1lXytSQTxqNTobkD6QwhY
Message-ID: <CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com>
Subject: Re: [PATCH 4/5] IPMI: Fix some uninitialized warning
To: Corey Minyard <cminyard@mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, minyard@acm.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 12:35 PM, Corey Minyard <cminyard@mvista.com> wrote:
>
> I'll do a patch to switch it to uninitialized_var() for the next set of
> things I send.  Thanks.

Actually, I'm seriously considering getting rid of uninitialized_var().

The thing is an abomination, and we've already had one bug due to it
(real uninitialized variable that was incorrectly hidden by
uninitialized_var()).

The thing is moronic. The whole thing is almost entirely due to
compiler bugs (*stupid* gcc behavior), and we would have been better
off with an explicit (unnecessary) initialization that at least
doesn't cause random crashes etc if it turns out to be wrong.

So please don't use that abortion. Just initialize things to
0/NULL/whatever if gcc complains and you want to get rid of them.
Better than the crap that is uninitialized_var(), which just causes
silent random behavior if it is wrong.

              Linus
