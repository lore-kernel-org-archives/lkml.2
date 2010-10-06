Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618Ab0JFSSu convert rfc822-to-quoted-printable (ORCPT
	<rfc822;w@1wt.eu>); Wed, 6 Oct 2010 14:18:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114Ab0JFSSt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:18:49 -0400
MIME-Version: 1.0
In-Reply-To: <4CACA9AD.9070900@fusionio.com>
References: <4CACA9AD.9070900@fusionio.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 6 Oct 2010 11:17:54 -0700
Message-ID: <AANLkTi=NkzSWR0voR9xLs2f7Rxfc4A_n7qi+t9fbB2iz@mail.gmail.com>
Subject: Re: [GIT PULL] one writeback regression fix for .36
To: Jens Axboe <jaxboe@fusionio.com>, Christoph Hellwig <hch@lst.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from QUOTED-PRINTABLE to 8bit by mail.home.local id o96IK4jc025692

On Wed, Oct 6, 2010 at 9:54 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>
> The recent patch series from Jan introduced a WARN_ON() regression.
> The real fix for this is adding a super_operations->get_bdi(), which
> we'll do for 2.6.37.
>
> Please pull.
>
> are available in the git repository at:
>  git://git.kernel.dk/linux-2.6-block.git for-linus
>
> Christoph Hellwig (1):
>      writeback: always use sb->s_bdi for writeback purposes

This is a f*cking disgrace. It's now the second patch I see during
this release window that works by parsing random strings in the block
device layer.

This needs to stop. There's something seriously wrong in the whole
subsystem. This kind of hackery is a disease, and it seems to be
endemic.

So let's just make sure that 2.6.37 really does clean these things up.
And dammit, I don't want to see more random crap added. There has been
too much crazyness going on, with too little taste in the whole
writeback and IO scheduler area. Jens, you need to put the brakes on.
No more crap. Really. Make 2.6.37 a stabilization and cleanup release,
without new crazy features or clever tweaking. Ok? Because writeback
was a disaster in 2.6.35, and it's been this kind of crazy ugly in
2.6.36.

So I'm not taking any more writeback changes unless I feel that you
are actively working on cleaning up the crazy tasteless crap without
adding new code.

                     Linus
