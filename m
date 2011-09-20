Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab1ITHS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 03:18:58 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51620 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab1ITHS4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 03:18:56 -0400
MIME-Version: 1.0
In-Reply-To: <20110919132500.GA16740@parisc-linux.org>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
	<201109161616.50004.andres@anarazel.de>
	<20110916153620.GA9913@parisc-linux.org>
	<201109161927.34472.andres@anarazel.de>
	<20110916200817.GD28519@kvack.org>
	<20110919123100.GJ12765@tamriel.snowman.net>
	<20110919132500.GA16740@parisc-linux.org>
Date: Tue, 20 Sep 2011 09:18:56 +0200
Message-ID: <CANGUGtDCLkKMa5vmgYtDDfh5p32aUGAtYOGFMrT6YK6oVYLBCQ@mail.gmail.com>
Subject: Re: [HACKERS] Improve lseek scalability v3
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Stephen Frost <sfrost@snowman.net>, Benjamin LaHaise <bcrl@kvack.org>,
        Andres Freund <andres@anarazel.de>, Andi Kleen <andi@firstfloor.org>,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, robertmhaas@gmail.com,
        pgsql-hackers@postgresql.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/19 Matthew Wilcox <matthew@wil.cx>:
> On Mon, Sep 19, 2011 at 08:31:00AM -0400, Stephen Frost wrote:
>> * Benjamin LaHaise (bcrl@kvack.org) wrote:
>> > For such tables, can't Postgres track the size of the file internally?  I'm
>> > assuming it's keeping file descriptors open on the tables it manages, in
>> > which case when it writes to a file to extend it, the internally stored size
>> > could be updated.  Not making a syscall at all would scale far better than
>> > even a modified lseek() will perform.
>>
>> We'd have to have it in shared memory and have a lock around it, it
>> wouldn't be cheap at all.
>
> Yep, that makes perfect sense.  After all, the kernel does basically the
> same thing to maintain this information; why should we have userspace
> duplicating the same infrastructure?
>
> I must admit, I'd never heard of this usage of lseek to get the current
> size of a file before; I'd assumed everybody used fstat.  Given this
> legitimate reason for a high-frequency calling of lseek, I withdraw my
> earlier objection to the patch series.
>
> --
> Matthew Wilcox                          Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I really don't understand the approach here. An improvement is an
improvement, do we need a use case to add an improvement to the
kernel? We are not talking about to add a new syscall or to do an ABI
change in this case. So my absolute ack to these patches.

Marco
