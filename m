Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab2LRPUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:20:16 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:65173 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab2LRPUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:20:11 -0500
MIME-Version: 1.0
In-Reply-To: <20121121125310.00625f55@pyramind.ukuu.org.uk>
References: <20121116192606.11799.35711.stgit@localhost.localdomain>
	<CA+5PVA6nKNZY70UoeDUhQo9Rj4Ck+k+XTHL++gwErgzqAdy6Aw@mail.gmail.com>
	<20121121125310.00625f55@pyramind.ukuu.org.uk>
Date: Tue, 18 Dec 2012 10:20:10 -0500
Message-ID: <CA+5PVA5iQwYOcoSYtLOoRBHaTNJANdv+X-C78474n3SzZg_m9w@mail.gmail.com>
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
From: Josh Boyer <jwboyer@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, florianschandinat@gmx.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 7:53 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 21 Nov 2012 07:45:45 -0500
> Josh Boyer <jwboyer@gmail.com> wrote:
>
>> On Fri, Nov 16, 2012 at 2:27 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> >
>> > [The fb maintainer appears to be absent at the moment].
>> >
>> > This is needed to fix a pile of lockdep splats that now show up because console_lock()
>> > is being properly audited. Hugh Dickins and Sasha Levin have tested it and both reports
>> > all looks good. This is probably not the whole story - the entire fb layer has locking
>> > confusion problems that were previously hidden but it seems to get the ones people hit
>> > in testing. This hopefully explains a few of the weird fb hangs that have been floating
>> > around forever.
>> >
>> > From: Alan Cox <alan@linux.intel.com>
>> >
>> > Adjust the console layer to allow a take over call where the caller already
>> > holds the locks. Make the fb layer lock in order.
>> >
>> > This s partly a band aid, the fb layer is terminally confused about the
>> > locking rules it uses for its notifiers it seems.
>> >
>> > Signed-off-by: Alan Cox <alan@linux.intel.com>
>>
>> Should this eventually get into the stable trees?
>
> Thats a question I'm not sure about at this point. I think the bug is
> real but not caught by the lock checker in older trees but I've not
> investigated.

So... this patch seems to still be twisting in the wind.  It should
probably be headed into 3.8 at this point, shouldn't it?

josh
