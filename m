Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab0JDWDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 18:03:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751999Ab0JDWDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 18:03:18 -0400
Date: Mon, 4 Oct 2010 15:02:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Drake <dsd@laptop.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH] serial8250: ratelimit "too much work" error
Message-Id: <20101004150238.fbc1b6cf.akpm@linux-foundation.org>
In-Reply-To: <20101004145101.b28fdc0a.akpm@linux-foundation.org>
References: <20101002110438.801F49D401B@zog.reactivated.net>
	<20101004145101.b28fdc0a.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Oct 2010 14:51:01 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> someone stuck a
> DEFINE_RATELIMIT_STATE() in include/linux/kernel.h and it ain't defined
> anywhere.  Let me fix that up...

Well that's a PITA.  Can't include ratelimit.h into kernel.h because a)
it'll slow everyone's compiels down and b) ratelimit.h needs spinlock.h
which surely needs kernel.h.  Fixable by adding a new
printk_ratelimit.h and including that from 135 source files, blah.

I'll give up and pronounce that users of printk_ratelimited() need to
include ratelimit.h as well.

