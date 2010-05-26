Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab0EZMX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:23:58 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60503 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab0EZMX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:23:57 -0400
To: Changli Gao <xiaosuo@gmail.com>
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <AANLkTildR17ccf4TAT0GavB6BoethCqg8BrqBPFu8s0N@mail.gmail.com>
	(message from Changli Gao on Wed, 26 May 2010 19:53:53 +0800)
Subject: Re: [PATCH 2/3] splice: allow non-block splice only when in file is 
	seekable
References: <1274867768-3011-1-git-send-email-xiaosuo@gmail.com> 
	<E1OHDru-0000Ge-Lr@pomaz-ex.szeredi.hu> <AANLkTildR17ccf4TAT0GavB6BoethCqg8BrqBPFu8s0N@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1OHFe5-00019D-DO@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 May 2010 14:23:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010, Changli Gao wrote:
> On Wed, May 26, 2010 at 6:29 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > On Wed, 26 May 2010, Changli Gao wrote:
> >> allow non-block splice only when in file is seekable.
> >>
> >> do_splice_to() is split to two parts: read data from in file to spd, and move
> >> data from spd to pipe. If there isn't much space in pipe for the data in spd,
> >> and the splice is called with non-block flag, the data dropped due to non
> >> enough space in pipe will be lost forever when in file isn't seekable.
> >
> > This is a gratuitous ABI change.  I don't think we should hold the
> > hand of application writers,
> 
> Yea, it is an ABI change. But without that, we'll fail user silently
> currently. Some fundamental change is needed to fix this issue fully,
> if you think it is a bug.

I don't think it's a bug.  The same thing will happen without
SPLICE_F_NONBLOCK if splice_to_pipe() is interrupted by a signal while
it blocks.

To prevent data loss the application needs to be aware of the fact
that doing a splice from a non-seekable fd needs to be done carefully,
making sure that it doesn't block on the pipe.

Miklos
