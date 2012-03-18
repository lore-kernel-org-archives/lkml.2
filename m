Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab2CRL5J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 07:57:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50839 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab2CRL5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 07:57:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when helper is not yet available
Date: Sun, 18 Mar 2012 13:01:18 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <CA+55aFyUAiVpueCTe2rDMZxcDkoQ=gYM+-Qmu0KG2SPTV4B+zA@mail.gmail.com> <4F659C41.70701@codeaurora.org>
In-Reply-To: <4F659C41.70701@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203181301.19048.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 18, 2012, Stephen Boyd wrote:
> On 3/16/2012 10:51 PM, Linus Torvalds wrote:
> > On Fri, Mar 16, 2012 at 7:47 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> >> -       if (WARN_ON(usermodehelper_is_disabled())) {
> >> +       if (is_sleep_task()) {
> >>                dev_err(device, "firmware: %s will not be loaded\n", name);
> > Stop these idiotic games already!
> >
> > It's very simple: you cannot load firmware while the system is not
> > readt. Your moronic "let's change the test to something else" is
> > entirely and utterly misguided and totally misses the point.
> >
> > It's not about sleeping, and it's not about anything even *remotely*
> > about that. Stop the idiocy already.
> >
> > How hard is it to understand? How many times do people have to tell you?
> >
> > That warning is very much valid during bootup, and that warning has
> > been *seen* during bootup. For example, try to compile in most
> > wireless drivers as non-modular, and that warning *has* to trigger.
> 
> Ok. I like where nowait() is going in the other part of the thread but
> I'm still confused about when request_firmware() is correct to use. It
> seems that the function is inherently racy with freezing. Does every
> user of request_firmware() need to synchronize with freezing?
> 
> For example, if one CPU is in the middle of a driver probe that makes a
> request_firmware() call and another CPU is starting to suspend we will
> have a race between usermodehelpers being disabled and the
> request_firmware() call acquiring the usermodehelper rwsem. If the
> suspending CPU wins the race it will disable usermodehelpers and the
> request_firmware() call will return -EBUSY and warn.

Yes, it will.

Thanks,
Rafael
