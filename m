Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab2IZVPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 17:15:31 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63729 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2IZVPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 17:15:30 -0400
Date: Wed, 26 Sep 2012 14:15:26 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jan =?iso-8859-1?Q?H=2E_Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: drop ambiguous LOG_CONT flag
Message-ID: <20120926211526.GA30261@kroah.com>
References: <1348682325-8402-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1348682325-8402-1-git-send-email-schnhrr@cs.tu-berlin.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 07:58:45PM +0200, Jan H. Schönherr wrote:
> From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
> 
> The meaning of LOG_CONT is unclear, i. e., whether a message is a starting,
> ending, or middle fragment. Unfortunately, this cannot be inferred from
> the LOG_PREFIX and LOG_NEWLINE flags, as they are not always kept.
> Furthermore, in some cases LOG_CONT is set, although it is unknown if
> there will be a continuation. This leads to wrongly concatenated output.
> 
> Fix this by dropping LOG_CONT and rely on LOG_PREFIX and LOG_NEWLINE to
> distinguish the type of fragment. That is, if LOG_PREFIX is set, this
> fragment does not continue the previous fragment. And if LOG_NEWLINE is
> set, this fragment is not continued by the next fragment.
> 
> (Unfortunately, we still have to look at the previous fragment to catch the
> case of an unset LOG_PREFIX on this fragment, but a set LOG_NEWLINE on
> the previous fragment.)
> 
> Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
> ---
> Against v3.6-rc7, only lightly tested.

Well, against linux-next and highly tested would be best.  It's a bit
late to get this into linux-next for 3.7, how important is it really?

thanks,

greg k-h
