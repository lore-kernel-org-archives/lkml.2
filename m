Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620Ab0HDTHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 15:07:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933609Ab0HDTHO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 15:07:14 -0400
MIME-Version: 1.0
In-Reply-To: <20100803.203814.59697285.davem@davemloft.net>
References: <20100803.203814.59697285.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Aug 2010 12:06:47 -0700
Message-ID: <AANLkTimxv1y3QJ7s+ghi1FFCcwnUVWT1n6dvT-NNN=Oo@mail.gmail.com>
Subject: Re: [GIT] Networking
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 8:38 PM, David Miller <davem@davemloft.net> wrote:
>
> Another release, another merge window, another set of networking
> changes to merge :-)

Ok, merged. But you should double-check my merge resolution fixes,

I'm also a bit unhappy about how it introduces new warnings in very
subtle ways. I started wondering why the hell I suddenly had SCSI
warnings even though I hadn't pulled the SCSI tree yet. It was due to
the dev_printk() changes in commit 99bcf217183e0 (""), which ends up
causing things like

  drivers/scsi/constants.c: In function ‘scsi_print_sense’:
  drivers/scsi/constants.c:1407: warning: zero-length gnu_printf format string
  drivers/scsi/constants.c:1413: warning: zero-length gnu_printf format string
  drivers/scsi/constants.c: In function ‘scsi_print_result’:
  drivers/scsi/constants.c:1456: warning: zero-length gnu_printf format string
  ...

which is a bit annoying. But more annoying was that you must have
known about this, and I'd have been much happier not seeing it as a
new surprise.

            Linus
