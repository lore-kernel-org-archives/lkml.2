Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab2CPVT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:19:56 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64168 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab2CPVTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:19:54 -0400
MIME-Version: 1.0
In-Reply-To: <201203162214.42553.chunkeey@googlemail.com>
References: <201203032122.36745.chunkeey@googlemail.com> <4F62E841.70405@linux.vnet.ibm.com>
 <201203162123.44927.rjw@sisk.pl> <201203162214.42553.chunkeey@googlemail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 16 Mar 2012 14:19:32 -0700
X-Google-Sender-Auth: nsVoEs__4M5_pAmeshMCITTtI5o
Message-ID: <CA+55aFw75kz641ydAn_nRmji+Si3jDb-3w9muCVyoa86LHBPJA@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when
 helper is not yet available
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        skannan@codeaurora.org, Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 2:14 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
>
> Because As far as I know "driver_init();" is called before
> "usermodehelper_enable();" in "do_basic_setup()".
> So, theoretical these people should see the same WARNINGs
> and read the comment about suspend/resume and I'm sure
> they will be thinking: WTF!

Just make the explanation be simple:

  "The system is not 8in a fully initialized state, and you cannot
load firmware at this point. User mode is not running, not all devices
have necessarily been initialized, user space applications may or may
not be frozen, and the filesystem may or may not exist yet. Loading
firmware is buggy under these circumstances. Go away"

Don't try to go into any details. The "you can race with freezer" is
too much detail. Even "suspend/resume" is too much detail. The fact
is, the system just isn't ready yet. The details are almost entirely
irrelevant, at best they can be examples of some things that can cause
problems.

                      Linus
