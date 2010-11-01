Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab0KAQJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 12:09:47 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64418 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428Ab0KAQJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 12:09:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ifEZsfmIc7tsXuX+Ub7W7BN/p6EuX2tuWx+/arnw0L3BoY+DiM1/7QqXnJqPvEYuHT
         sBer8ag/mmyl/QvoBT9UgoEvBG8DSyOr1r/dgWEpXnjyVfD6WWTrlFqAB5vubX6h3Qk0
         Eke86uONZAHWi6OPOPnZKkV5K/UZJqON8CFLM=
MIME-Version: 1.0
In-Reply-To: <AANLkTingbRtFQUoQNZmQubL0LNhVF2hvkdma6j7VDTEU@mail.gmail.com>
References: <AANLkTinWT9OyicLfdeY+AvWs=5vb5z8skZ3t6keYjk9j@mail.gmail.com>
	<AANLkTikNywvthaU-+s5HXvh3RX=HxiFWmADW--Ln_Gga@mail.gmail.com>
	<AANLkTimgCU1tM9VJv8RJ-dim+bRsT7cbZ9ZidbT5sco-@mail.gmail.com>
	<20101031224757.GA2430@selene>
	<AANLkTingbRtFQUoQNZmQubL0LNhVF2hvkdma6j7VDTEU@mail.gmail.com>
Date: Mon, 1 Nov 2010 12:09:43 -0400
Message-ID: <AANLkTimMCw8p+YJRzCg7_cEn4UEDTC6vxs6ByUjJYMnL@mail.gmail.com>
Subject: Re: Horrible btrfs performance due to fragmentation
From: Gregory Maxwell <gmaxwell@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>, cwillu <cwillu@cwillu.com>,
        Calvin Walton <calvin.walton@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 11:58 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> Or when going through all the fragments of a file, have a counter, and
> if it exceeds certain limit mark it somehow, so that it gets
> defragmented at least to a certain extent.

Thats elegant, — then resources are only spent on defragmenting files
which are actually in use and which actually need it... but I don't
see how it deals with the partial mutual exclusivity of defragmenting
and COWed files.
