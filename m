Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab2KTPFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:05:04 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34965 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab2KTPFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:05:03 -0500
MIME-Version: 1.0
In-Reply-To: <20121120145807.GB19467@localhost>
References: <CAGTBQpaDR4+V5b1AwAVyuVLu5rkU=Wc1WeUdLu5ag=WOk5oJzQ@mail.gmail.com>
	<20121120080427.GA11019@localhost>
	<CAGTBQpayd-HyH8SWfUCavS7epybcQR5SAx+tr+wyB38__4b-2Q@mail.gmail.com>
	<20121120145807.GB19467@localhost>
Date: Tue, 20 Nov 2012 12:05:02 -0300
Message-ID: <CAGTBQpY-yav5G4aPSBdUmACWQbe8RR=8OnRwKHbMuuR=GBgBxw@mail.gmail.com>
Subject: Re: fadvise interferes with readahead
From: Claudio Freire <klaussfreire@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 11:58 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>
>> But if cache hits were to simply update
>> readahead state, it would only mean that read calls behave the same
>> regardless of fadvise calls. I think that's worth pursuing.
>
> Here you are describing an alternative solution that will somehow trap
> into the readahead code even when, for example, the application is
> accessing once and again an already cached file?  I'm afraid this will
> add non-trivial overheads and is less attractive than the "readahead
> on fadvise" solution.

Not for all cache hits, only those in state !PageUptodate, which are
I/O in progress, the case that hurts.

>> I ought to try to prepare a patch for this to illustrate my point. Not
>> sure I'll be able to though.
>
> I'd be glad to materialize the readahead on fadvise proposal, if there
> are no obvious negative examples/cases.

I don't expect a significant performance hit if only !PageUptodate
hits invoke readahead code. But I'm no kernel expert either.
