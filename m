Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab1IFEYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 00:24:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61777 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1IFEYw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 00:24:52 -0400
MIME-Version: 1.0
In-Reply-To: <201109051704.12040.arnd@arndb.de>
References: <4E5B4AAF.2040101@samsung.com>
	<20110905121840.GA4768@infradead.org>
	<CAH9JG2U9uWMQYVjyH1HOmefe2mdf79fpR5mkjPW9nj4v2MrcwQ@mail.gmail.com>
	<201109051704.12040.arnd@arndb.de>
Date: Tue, 6 Sep 2011 13:24:51 +0900
X-Google-Sender-Auth: Z1Y3ECgh5jGqS2uAAZKaxhuZJ9w
Message-ID: <CAH9JG2XST45QSmkbu4kqmuQ-vOS-xdwwz_w_CLepHYpA7z01cA@mail.gmail.com>
Subject: Re: [RFC PATCH v2] support ioctl for tunable user request
From: Kyungmin Park <kmpark@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jaxboe@fusionio.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lin Ming <lxy@ss.pku.edu.cn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 6, 2011 at 12:04 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 05 September 2011, Kyungmin Park wrote:
>> On Mon, Sep 5, 2011 at 9:18 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> > On Mon, Sep 05, 2011 at 08:47:58PM +0900, Kyungmin Park wrote:
>> >> The concept is similar with DISCARD request except no-wait for request complete
>> >>
>> >>  #define REQ_DISCARD            (1 << __REQ_DISCARD)
>> >> +#define REQ_TUNE               (1 << __REQ_TUNE)
>> >>
>> >> As it's hard to detect the idle time at device level, user send the
>> >> tune request to device when idle.
>> >
>> > But what does a "tune" request actually do?  It's an overly generic
>> > term, but I still can't even think of what it would do to a storage
>>
>> Yes, tune is generic term, that's reason to send the RFC patch, we
>> consider the several names, but not found the proper name, if you
>> suggest the proper name, it can change the proper one.
>
> Would __REQ_GC as a shortcut for garbage collection fit? Right now,
> I also think TUNE is not at all describing what we expect the drive
> to do, but it's hard to come up with a term that is generic enough
> to cover similar concepts in other hardware while still describing
> what the drive does.
No problem to use the REQ_GC. BTW, does it acceptable to GC request? I
hope each devices can do own optimization if REQ_GC is requested, if
no need to these one, just ignore it at driver level.

Thank you,
Kyungmin Park
