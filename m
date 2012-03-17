Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab2CQUBx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 16:01:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50492 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab2CQUBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 16:01:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when helper is not yet available
Date: Sat, 17 Mar 2012 21:06:00 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <4F63FB59.9010104@codeaurora.org> <CA+55aFyUAiVpueCTe2rDMZxcDkoQ=gYM+-Qmu0KG2SPTV4B+zA@mail.gmail.com>
In-Reply-To: <CA+55aFyUAiVpueCTe2rDMZxcDkoQ=gYM+-Qmu0KG2SPTV4B+zA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203172106.01052.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 17, 2012, Linus Torvalds wrote:
> On Fri, Mar 16, 2012 at 7:47 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > -       if (WARN_ON(usermodehelper_is_disabled())) {
> > +       if (is_sleep_task()) {
> >                dev_err(device, "firmware: %s will not be loaded\n", name);
> 
> Stop these idiotic games already!
> 
> It's very simple: you cannot load firmware while the system is not
> readt. Your moronic "let's change the test to something else" is
> entirely and utterly misguided and totally misses the point.
> 
> It's not about sleeping, and it's not about anything even *remotely*
> about that. Stop the idiocy already.
> 
> How hard is it to understand? How many times do people have to tell you?
> 
> That warning is very much valid during bootup, and that warning has
> been *seen* during bootup. For example, try to compile in most
> wireless drivers as non-modular, and that warning *has* to trigger.
> 
> Rafael, please consider everything along these *IDIOTIC* lines
> completely NAK'ed.

I will.

Thanks,
Rafael
