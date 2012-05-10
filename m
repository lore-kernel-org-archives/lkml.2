Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991Ab2EJUkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 16:40:23 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:51211 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab2EJUkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 16:40:20 -0400
MIME-Version: 1.0
In-Reply-To: <1336682226.29763.2.camel@joe2Laptop>
References: <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
 <CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
 <CA+55aFzgXzFs9z-5ViQ4=4hhtOtK=CBHGxNX_dsXQV9mn1qANg@mail.gmail.com>
 <20120509070710.GA29981@gmail.com> <CAPXgP11evyQQKNDaa00R7qsOFy5Xk-utN1w9OgB4y6NxLZG=UA@mail.gmail.com>
 <1336611278.728.9.camel@mop> <CA+55aFyrrH0jJV--L=ugt0YK7pT+jmhjvt_WRWyenyiroN97zg@mail.gmail.com>
 <1336667984.947.24.camel@mop> <CA+55aFxUaNC4SGEodrdddkDN6t=Sbx=P4XyaHkj7eTQBQOeLeA@mail.gmail.com>
 <1336676986.947.47.camel@mop> <20120510201409.GA6467@thunk.org> <1336682226.29763.2.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 10 May 2012 22:39:59 +0200
Message-ID: <CAPXgP11T7vjBBFaE5jne0hntZ2J-MoVxwJ2C9TNsRzme9DmLuQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Joe Perches <joe@perches.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 10:37 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2012-05-10 at 16:14 -0400, Ted Ts'o wrote:
>> Is there any difference in any of the cases in terms of how printk's
>> that are prefixed with KERN_CONT versus a printk that does not have
>> any KERN_* prefix?  If so, is there value in keeping KERN_CONT?
>
> As far as I know, no.
>
> It is a useful marker to show where prints
> are actually continued.
>
> #define KERN_CONT ""
>
> would save a small amount of text.

Nah, we can't do that. We need it to tell "here is your non-prefix to
parse, leave the data behind alone".

Kay
