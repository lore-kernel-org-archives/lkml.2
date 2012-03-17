Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab2CQFv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 01:51:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35538 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2CQFvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 01:51:54 -0400
MIME-Version: 1.0
In-Reply-To: <4F63FB59.9010104@codeaurora.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203150034.08863.rjw@sisk.pl>
 <4F612C05.8010301@codeaurora.org> <201203150111.05724.rjw@sisk.pl> <4F63FB59.9010104@codeaurora.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 16 Mar 2012 22:51:32 -0700
X-Google-Sender-Auth: QhMDn6U-pajKqXbVB-Pir4ke72w
Message-ID: <CA+55aFyUAiVpueCTe2rDMZxcDkoQ=gYM+-Qmu0KG2SPTV4B+zA@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when
 helper is not yet available
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 7:47 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> -       if (WARN_ON(usermodehelper_is_disabled())) {
> +       if (is_sleep_task()) {
>                dev_err(device, "firmware: %s will not be loaded\n", name);

Stop these idiotic games already!

It's very simple: you cannot load firmware while the system is not
readt. Your moronic "let's change the test to something else" is
entirely and utterly misguided and totally misses the point.

It's not about sleeping, and it's not about anything even *remotely*
about that. Stop the idiocy already.

How hard is it to understand? How many times do people have to tell you?

That warning is very much valid during bootup, and that warning has
been *seen* during bootup. For example, try to compile in most
wireless drivers as non-modular, and that warning *has* to trigger.

Rafael, please consider everything along these *IDIOTIC* lines
completely NAK'ed. In fact, until Stephen starts showing any sign of
understanding that it's not about just some random small detail, just
ignore anything and everything from him.

Stephen, you've been told multiple times that that WARN_ON() is
correct. Until you understand that, just stop sending these entirely
random patches that change it to something completely wrong.

How hard can it be to understand that you cannot and must not load
firmware when the system isn't up-and-running.

And *dammit*, the fact that you send these kinds of completely
nonsensical patches that seem to think that "up-and-running" is just
about suspend (and not bootup, for example), all you are showing is
that you don't understand the problem. Stop, think, and read the
emails that have been in this thread and that have explained how it
*could* be solved.

Until you do that, any patch you send is just worthless. Really.

                     Linus

                              Linus
