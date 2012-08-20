Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab2HTIu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:50:59 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38943 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab2HTIu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:50:57 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1208180025311.29492@hermes-1.csi.cam.ac.uk>
References: <alpine.LNX.2.00.1208172136490.15699@swampdragon.chaosbits.net>
	<alpine.LSU.2.00.1208180025311.29492@hermes-1.csi.cam.ac.uk>
Date: Mon, 20 Aug 2012 10:50:56 +0200
Message-ID: <CAE2SPAacGx1Q3SOjwEGK9vuqBDq3S=A996JQkbDXC+7MkfiDXA@mail.gmail.com>
Subject: Re: [PATCH] unifdef: set a secure umask before calling mkstemp()
From: Bastien ROUCARIES <roucaries.bastien@gmail.com>
To: Tony Finch <dot@dotat.at>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 1:43 AM, Tony Finch <dot@dotat.at> wrote:
> Jesper Juhl <jj@chaosbits.net> wrote:
>
>> In newer glibc's (versions > 2.06) reasonably secure permissions of
>> 0600 are used when creating a temporary file with mkstemp(). But for
>> older glibc's (versions <= 2.06) 0666 is used which is not secure.
>
> Thanks for your suggestion! I'm afraid I prefer not to make the change.
>
> Unifdef is only using mkstemp as a convenient way to open a file with a
> non-clashing name. It isn't trying to be secure, so it's OK just to rely
> on the user's umask. And I find it hard to care about a bug that was fixed
> 15 years ago.
>
> I'm also trying to reduce the unixisms in the program for portability
> reasons and this is the most awkward part :-/

have you tried gnulib for improving portability ?

Bastien
> Tony.
> --
> f.anthony.n.finch  <dot@dotat.at>  http://dotat.at/
> Forties, Cromarty: East, veering southeast, 4 or 5, occasionally 6 at first.
> Rough, becoming slight or moderate. Showers, rain at first. Moderate or good,
> occasionally poor at first.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
