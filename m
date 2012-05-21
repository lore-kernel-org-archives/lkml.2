Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab2EUPO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:14:27 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58381 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2EUPOZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:14:25 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1205211059510.1725-100000@iolanthe.rowland.org>
References: <CAF1ivSYmY3d8VonvsX0orsj0fLKXOXsLoG5jSwLs90MoP7=5Dw@mail.gmail.com>
	<Pine.LNX.4.44L0.1205211059510.1725-100000@iolanthe.rowland.org>
Date: Mon, 21 May 2012 23:14:24 +0800
X-Google-Sender-Auth: 6rgcHETp5eA6MRC2GF6ZIRfkugw
Message-ID: <CAF1ivSajZb_D9nOuA5gYeDgHgbvyqbCueV8+kDyy3DSBs1AumQ@mail.gmail.com>
Subject: Re: [RFC v2 PATCH 2/4] block: add queue runtime pm callbacks
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 11:00 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 21 May 2012, Lin Ming wrote:
>
>> On Fri, May 18, 2012 at 2:29 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> [snip]
>> > I may have left some parts out from this brief description.  Hopefully
>> > you'll be able to figure out the general idea and get it to work.
>>
>> All journal threads and flusher thread of the disk need to be freezed
>> before suspend and thaw after resume.
>
> Why?  If any of those threads needs to write something to the disk
> while the disk is suspended, the disk will simply be resumed.

When tested the patches, I found that kjournald and flusher thread
frequently resume the disk.

I'm not familiar with journal.
Are the journal threads still need to be in active state when the disk
is already suspended?

>
> Alan Stern
