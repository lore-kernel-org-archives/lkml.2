Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1HWSrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:47:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755256Ab1HWSqz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:46:55 -0400
MIME-Version: 1.0
In-Reply-To: <201108231739.p7NHdXQ8008360@stout.americas.sgi.com>
References: <201108231739.p7NHdXQ8008360@stout.americas.sgi.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 23 Aug 2011 11:46:30 -0700
Message-ID: <CA+55aFxEyj8qJnr9QR3Scy7SFocEr2BNA9z4PXs7q9rpkXM1vQ@mail.gmail.com>
Subject: Re: [GIT PULL] XFS update for 3.1-rc4
To: Alex Elder <aelder@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 10:39 AM, Alex Elder <aelder@sgi.com> wrote:
>
> Linus, please pull the following XFS changes.  Their effect is to
> remove the subdirectory structure from the XFS source hierarchy.
> There are no functional changes to the XFS code itself.  Thanks.

Pulled.

Any plans to further sanitize the namespace?

It's kind of crazy to have filenames like

   fs/xfs/xfs_trace.c

which just duplicate the "xfs" part for no good reason. Why not just
do something like

  for i in xfs_*; do j=$(echo $i | sed 's/^xfs_//'); git mv $i $j; done

to get rid of the silly "xfs_" prefix that adds nothing?

You could use the bytes you save to rename "qm.c" to "quota_manager.c"
instead. Wouldn't it be nice to have *good* names, instead of a jumble
of crazy and mostly redundant letters?

                        Linus
