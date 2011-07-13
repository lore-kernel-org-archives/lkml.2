Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab1GMAgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 20:36:04 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:39856 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab1GMAgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 20:36:03 -0400
MIME-Version: 1.0
In-Reply-To: <20110712222227.GA1316@thinkpad>
References: <1308923350-7932-1-git-send-email-andrea@betterlinux.com>
	<4E07F349.2040900@jp.fujitsu.com>
	<20110627071139.GC1247@thinkpad>
	<4E0858CF.6070808@draigBrady.com>
	<20110627102933.GA1282@thinkpad>
	<4E086F51.50403@draigBrady.com>
	<8762n7kvym.fsf@cmungerjr.com>
	<20110712222227.GA1316@thinkpad>
Date: Tue, 12 Jul 2011 17:36:01 -0700
Message-ID: <CAKGkouvYTaij0LTPOWfPaTb4ZivZZvXTWWWV+i_CPMNRecovcw@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] fadvise: support POSIX_FADV_NOREUSE
From: "Patrick J. LoPresti" <lopresti@gmail.com>
To: Andrea Righi <andrea@betterlinux.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 3:22 PM, Andrea Righi <andrea@betterlinux.com> wrote:
>
> If the file data is not in memory you can't set a bit in any struct
> page. You could even open a file and execute POSIX_FADV_NOREUSE without
> reading any page from the file.

Mmm, too bad.

> I think it would be better to maintain a list of file offset/length
> structures per file descriptor or (as a starting solution) even mark the
> entire file as non-cacheable without considering the ranges.

I recommend against the "whole file" approach.  In my application (for
instance), I deal with files in the hundreds of gigabytes.  Marking
the whole file non-cacheable, when I was just trying to give a hint
about a few hundred megs, would be a total disaster.

I would suggest implementing it right or leaving it as a no-op.  Just my $0.02.

Thanks for working on this.  Better support for these page cache hints
will be great to see.

 - Pat
