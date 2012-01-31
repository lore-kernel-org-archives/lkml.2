Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab2AaMqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:46:48 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:57617 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081Ab2AaMqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:46:47 -0500
MIME-Version: 1.0
In-Reply-To: <4F26CAD1.2000209@stericsson.com>
References: <1327930436-10263-1-git-send-email-maxime.coquelin@stericsson.com>
	<1327930436-10263-4-git-send-email-maxime.coquelin@stericsson.com>
	<20120130152237.GS25268@csn.ul.ie>
	<4F26CAD1.2000209@stericsson.com>
Date: Tue, 31 Jan 2012 14:46:46 +0200
X-Google-Sender-Auth: 5R6X5aT_ugi1NGebNg8KncdooEQ
Message-ID: <CAOJsxLE_iby+-EGzqXDc9D=Db7mm1NDDqdHqN_a+mZAQfLBrFA@mail.gmail.com>
Subject: Re: [RFCv1 3/6] PASR: mm: Integrate PASR in Buddy allocator
From: Pekka Enberg <penberg@kernel.org>
To: Maxime Coquelin <maxime.coquelin@stericsson.com>
Cc: Mel Gorman <mel@csn.ul.ie>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Andrea GALLO <andrea.gallo@stericsson.com>,
        Vincent GUITTOT <vincent.guittot@stericsson.com>,
        Philippe LANGLAIS <philippe.langlais@stericsson.com>,
        Loic PALLARDY <loic.pallardy@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 6:52 PM, Maxime Coquelin
<maxime.coquelin@stericsson.com> wrote:
>> What is more likely is that you will get pushed to doing something like
>> periodically scanning memory as part of a separate power management
>> module and calling into PASR if regions of memory that are found that
>> can be powered down in some ways.
>
> With this solution, we need in any case to add some hooks in the allocator
> to ensure the pages being allocated are refreshed.

Why do you insist on making this happen at page level when you're only
able to power off *much* larger chunks?
