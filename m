Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864Ab0FJWa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 18:30:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754025Ab0FJWa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 18:30:27 -0400
MIME-Version: 1.0
In-Reply-To: <4C116652.8010408@athenacr.com>
References: <AANLkTinLth4iKXAwszEEsPm_9ZDlj8HtqsiG5cdFE1cZ@mail.gmail.com>
	<20100610181042.GA19210@puku.stupidest.org>
	<4C116652.8010408@athenacr.com>
Date: Thu, 10 Jun 2010 15:30:20 -0700
Message-ID: <AANLkTikEnVUsO2SjMzDJX7oZjpwYN40dPn4j2i6kPcd8@mail.gmail.com>
Subject: Re: Slow pty's (was Re: libdivecomputer interfaces?)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Brian Bloniarz <bmb@athenacr.com>
Cc: Chris Wedgwood <cw@f00f.org>, Greg KH <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Jef Driesen <jefdriesen@telenet.be>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 3:25 PM, Brian Bloniarz <bmb@athenacr.com> wrote:
> On 06/10/2010 02:10 PM, Chris Wedgwood wrote:
>>
>> this might not be related, but i have slow serial ports with NOHZ that
>> goes away when i revert 39c0cbe2150cbd848a25ba6cdb271d1ad46818ad.
>
> Unrelated or not, I think Chris is right about this. Somewhere before
> -rc1, the emulated serial console on my KVM instance became slow
> to echo input. I just tested with the commit reverted and it's
> back to normal.

I suspect it's related. The tty subsystem clearly ends up depending on
the timer tick to move things forward even if there are pending
readers. So I suspect the slowness is very much related to the same
issue.

                     Linus
