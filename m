Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2HDI5a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 04:57:30 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45992 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2HDI53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 04:57:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120731210438.GA31713@phenom.dumpdata.com>
References: <c31aaed4-9d50-4cdf-b794-367fc5850483@default>
	<CAOJsxLEhW=b3En737d5751xufW2BLehPc2ZGGG1NEtRVSo3=jg@mail.gmail.com>
	<20120731210438.GA31713@phenom.dumpdata.com>
Date: Sat, 4 Aug 2012 11:57:27 +0300
X-Google-Sender-Auth: IbbjIrBuZ_KirYvp95aDucdxItc
Message-ID: <CAOJsxLEsDTp+ZkhVNDSreD3DhsS+D88MpMJFEzYmu+Eg8GcBYA@mail.gmail.com>
Subject: Re: [RFC/PATCH] zcache/ramster rewrite and promotion
From: Pekka Enberg <penberg@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

> On Tue, Jul 31, 2012 at 11:53:57PM +0300, Pekka Enberg wrote:
>> Why on earth would you want to move that under the mm directory?

On Wed, Aug 1, 2012 at 12:04 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> If you take aside that problem that it is one big patch instead
> of being split up in more reasonable pieces - would you recommend
> that it reside in a different directory?
>
> Or is that it does not make sense b/c it has other components in it - such
> as tcp/nodemaneger/hearbeat/etc so it should go under the refactor knife?
>
> And if you rip out the ramster from this and just concentrate on zcache -
> should that go in drivers/mm or mm/tmem/zcache?

I definitely think mm/zcache.c makes sense. I hate the fact that it's
now riddled with references to "tmem" and "ramster" but that's probably
fixable. I also hate the fact that you've now gone and rewritten
everything so we lose all the change history zcache has had under
staging.

As for ramster, it might make sense to have its core in mm/ramster.c and
move the TCP weirdness somewhere else. The exact location depends on
what kind of userspace ABIs you expose, I suppose. I mean, surely you
need to configure the thing somehow?

                        Pekka
