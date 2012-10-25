Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935336Ab2JYJpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:45:06 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48483 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934884Ab2JYJpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:45:03 -0400
Date: Thu, 25 Oct 2012 10:44:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH 2/6] pinctrl: Update clock handling for the
 pinctrl-nomadik GPIO driver
Message-ID: <20121025094458.GB4008@gmail.com>
References: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
 <1351089926-32161-3-git-send-email-lee.jones@linaro.org>
 <CACRpkdaeBW2ecQZ2fA-hL8o47pYpjZ=5Mn131F87u58rX+dekw@mail.gmail.com>
 <20121025073127.GB971@gmail.com>
 <5088F0EE.8030900@stericsson.com>
 <20121025082341.GC3348@gmail.com>
 <CAPDyKFromkv_VYgiQsERR=PbrwYqgux=teF_HSZxCtk2BCsk1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPDyKFromkv_VYgiQsERR=PbrwYqgux=teF_HSZxCtk2BCsk1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2012, Ulf Hansson wrote:

> On 25 October 2012 10:23, Lee Jones <lee.jones@linaro.org> wrote:
> > On Thu, 25 Oct 2012, Linus Walleij wrote:
> >
> >> On 10/25/2012 09:31 AM, Lee Jones wrote:
> >> >
> >> >This certainly doesn't fix the bug we spoke about. I believe Ulf
> >> >is still working on that one.
> >> >
> >> >So do you want me to remove this patch?
> >> >
> >>
> >> Yeah drop it for now.
> >
> > Actually, a quick question before I do:
> >
> > If it's better/faster to prepare the clock and keep it prepared
> > while you do clk_enable/clk_disable, why don't we do that in all
> > drivers? Why do we bother to prepare/unprepare each time if all
> > it does is take up cycles?
> >
> 
> Depending on clock type, a clk_disable is actually not going to "gate"
> the clock, that might happen only in unprepare. This depends on if the
> clock is a fast or slow clock.
> To save as much power as possible, in general, we should do both
> disable and unprepare. Although it will be device driver dependent
> were it is most convenient to do this things.
> Sometimes it is possible to group them sometimes not.

And in this case, it's better to ... ?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
