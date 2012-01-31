Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab2AaVwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 16:52:16 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41025 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2AaVwP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 16:52:15 -0500
MIME-Version: 1.0
In-Reply-To: <20120131211554.GA28105@pengutronix.de>
References: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
 <1328004002-24646-2-git-send-email-Barry.Song@csr.com> <20120131101734.GE2471@pengutronix.de>
 <CAGsJ_4wyJ6Wymy4AWoW1eHubZX=W7GT_Fbow9ofXoY1RrcHzgA@mail.gmail.com>
 <20120131113358.GM2471@pengutronix.de> <20120131203455.GG22611@ponder.secretlab.ca>
 <20120131211554.GA28105@pengutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 31 Jan 2012 14:51:53 -0700
X-Google-Sender-Auth: YW0utfbzhi9Vb74H7aiYHyKeUPs
Message-ID: <CACxGe6tLLgaetPsW47pXVFbRt64kum+qgeVedFUG9fyDA1c3Hw@mail.gmail.com>
Subject: Re: [PATCH 1/3] platform: add common resource requesting and mapping helper
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Barry Song <21cnbao@gmail.com>, Barry Song <Barry.Song@csr.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Erik Gilling <konkers@google.com>,
        linux-mtd@lists.infradead.org, Barry Song <Baohua.Song@csr.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 2:15 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
>
>> > I am not sure using 'platform_devm_request_and_ioremap' and later using
>> > plain 'devm_*' functions (without platform_-prefix) is less confusing.
>> > The alternative would be to check which helper functions also use
>> > 'struct resource' and if they do checks on that. If all do that, you
>> > would have the simple rule, that you only need to check yourself if you
>> > access it yourself.
>>
>> The reason I suggested the wrapper is that then the driver code doesn't need
>> to fart around with the res pointer at all.  It reduces boilerplate in platform
>> drivers which I think is a good thing.
>
> I do understand your motivation and fully agree with what you are aiming for
> (that's exactly why I implemented devm_request_and_ioremap()).
>
> This patch is a micro-optimization, though, and won't cut it IMHO. I still have
> issues with only one platform_devm_* and all the rest being devm_* (without
> platform_). Things might look better, if we'd for example also have
> platform_devm_request_irq() or something similar. That might be an approach
> where we can play around with and see what is left to do. Or, if other
> approaches might be more elegant.
>
> To discuss that, try things, etc, I'd simply like to have a bit more time. If
> we are accepting the first iteration right away, and people let run their
> coccinelle-scripts based on that, it might get annoying to change that a second
> time, I'd think.

Okay, I'm willing to sit-tight on this for a bit.

g.
