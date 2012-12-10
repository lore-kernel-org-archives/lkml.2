Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab2LJLvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:51:11 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:60269 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab2LJLvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:51:09 -0500
MIME-Version: 1.0
In-Reply-To: <CANFwon0-QQygKUmRq6E3QawbFqkPc1zy2Om2E7qvCXB-LZdbFQ@mail.gmail.com>
References: <CANFwon0-QQygKUmRq6E3QawbFqkPc1zy2Om2E7qvCXB-LZdbFQ@mail.gmail.com>
Date: Mon, 10 Dec 2012 12:51:08 +0100
Message-ID: <CAJ-WASdGwab0ep_O5YxsfFP+3ivtqoj4XQ7vsGwZwANTP25mzQ@mail.gmail.com>
Subject: Re: KGTP (Linux debugger and tracer) 20121204 release (bug fix and
 doc update)
From: Pawel Suchanecki <subdcc@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/10 Hui Zhu <teawater@gmail.com>
>
> According to the comments of Christoph, Geoff and Andi.  I make lite
> patch for review.  Please goto https://lkml.org/lkml/2012/5/9/90 to
> see it.

The patch you sent for review used kmalloc/memset() combo but in your
SVN (the tag specified (20121204) and in trunk as well) it was already
converted to kcalloc().

However it looks like you could reduce kernel text by using kzalloc()
instead of kcalloc(1, ...) (everywhere you allocate just one entry).

This issue was described here: http://lwn.net/Articles/147014/.

Thanks,
Pawel
