Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab0FFK62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 06:58:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58811 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755621Ab0FFK60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 06:58:26 -0400
Date: Sun, 6 Jun 2010 12:05:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Florian Mickler <florian@mickler.org>
Cc: Vitaly Wool <vitalywool@gmail.com>, Brian Swetland <swetland@google.com>,
       Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
Message-ID: <20100606120557.72356de9@lxorguk.ukuu.org.uk>
In-Reply-To: <20100606124601.2f1f6714@schatten.dmk.lab>
References: <20100603193045.GA7188@elte.hu>
	<20100603231153.GA11302@elte.hu>
	<20100603232302.GA16184@elte.hu>
	<AANLkTikZP3bmckpfb_jUdG7qZO5W9DgpZ79ugtSZaEpt@mail.gmail.com>
	<20100604071354.GA14451@elte.hu>
	<AANLkTimH4ihf3QqtKFpfGXRKtO55PrUuff9JYtaEBG44@mail.gmail.com>
	<20100604083423.GD15181@elte.hu>
	<AANLkTinQyzzeF-NOAjrAqqQXqKjFJhx85nI4uyBGRtWd@mail.gmail.com>
	<1275653210.27810.39762.camel@twins>
	<AANLkTinyjBa0KYfFz3_EFbC65hoQFwFINlTDYjCe-wM3@mail.gmail.com>
	<1275731653.27810.41078.camel@twins>
	<20100605092851.6ee15f13@infradead.org>
	<AANLkTimEwznq9c_8lkuBMxEQ-42rdvpZEqA9Y71Cu-qC@mail.gmail.com>
	<AANLkTimKknOurmCffOpHjc1FjrP2MKf10pBwEEbLJPg_@mail.gmail.com>
	<AANLkTil1NCX91bWhpXHtC88Opr29mNjdhXD9RXQ6DI0y@mail.gmail.com>
	<AANLkTin1Za3GvfIKbcZdx6TzjIHzCvsg5uaY_Vk4nJIh@mail.gmail.com>
	<AANLkTilQ1k78dDCYadOa1Wiyjm2nsBcRpxwdpGvYcf8z@mail.gmail.com>
	<AANLkTin7oM3gVwHbIHWqYV8yeC6bbQ4q2jDDxAgz3DwQ@mail.gmail.com>
	<20100606124601.2f1f6714@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jun 2010 12:46:01 +0200
Florian Mickler <florian@mickler.org> wrote:

> On Sun, 6 Jun 2010 12:00:47 +0200
> Vitaly Wool <vitalywool@gmail.com> wrote:
> 
> > Even worse, the suspend wakelock will keep the
> > whole kernel active, as opposed to powering off unused devices
> > separately as it's done in runtime PM. 
> 
> That is not true. While the kernel is not suspended it does
> runtime pm.

On several of our platforms runtime PM already includes suspend so a
suspend wakelock does interfere with existing power managemet at that
level (not to mention the maintenance mess it causes).

This is one of the reasons you want QoS information, it provides
parameters by which the power management code can make a decision.
Suspend blocksers simply don't have sufficient variety to manage the
direction of power policy.

If Android chooses to abuse the QoS information for crude suspend
blocking then that is fine, it doesn't interfere with doing the job
'properly' on other systems or its use for realtime work on other boxes.

Alan
