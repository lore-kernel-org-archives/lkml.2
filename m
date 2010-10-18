Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144Ab0JRTlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:41:24 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46590 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab0JRTlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:41:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Q9OcaT/DwPbc3Rb5oMhPpW0m6vaCQgaeacBDb11ZJEb3mQ2GYGQRidFWHX8DikHSDz
         40FNF3TUm4HuIvHcMV9pr7lTsUpjt6Q/P1GkCnodqnRJSLVLnYEYHdOCL5VyEYGB2k2A
         t8HOs/rk2Y9eOXzo61VutKCarQI6FoKUh6mS4=
MIME-Version: 1.0
In-Reply-To: <20101018191936.GH27377@linux-mips.org>
References: <17ebecce124618ddf83ec6fe8e526f93@localhost>
	<17d8d27a2356640a4359f1a7dcbb3b42@localhost>
	<4CBC4F4E.5010305@pobox.com>
	<20101018191936.GH27377@linux-mips.org>
Date: Mon, 18 Oct 2010 12:41:20 -0700
Message-ID: <AANLkTimmatKpOFATCPDxthN-9pZzzXRAOnLGR1_348=r@mail.gmail.com>
Subject: Re: [PATCH resend 5/9] MIPS: sync after cacheflush
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Shinya Kuribayashi <skuribay@pobox.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 12:19 PM, Ralf Baechle <ralf@linux-mips.org> wrote:
> I'm trying to get a statement from the MIPS architecture guys if the
> necessity to do anything beyond a cache flush is an architecture violation.

IMO such a requirement would be unnecessarily strict.  Larger flushes
(e.g. page at a time) tend to benefit from some form of pipelining or
write gathering.  Forcing the processor to flush exactly 32 bytes at a
time, synchronously, could really slow things down and thrash the
memory controller.

I have not been able to find any official statement from MIPS that
says that CACHE + SYNC should be used, but that seems like the most
intuitive way to implement things on the hardware side.
