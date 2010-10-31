Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab0JaQKl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 12:10:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65223 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab0JaQKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 12:10:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=DQAqw5YFMxLAgy27dsAd9ApAG/hMHqDle7PCqBffH9/sjimULHtMQLYWCRmQBnomVL
         zFY52Bfe0/0zkmNrPa8HPbwMZUBX6PEYGqIn1B8YmqQ49t2l1/8W+q2PM0S8zQbTD2tq
         2gamTTLN2FDG3PNJgEFz8aNCeHLuq+koH00u0=
MIME-Version: 1.0
In-Reply-To: <m2bp6apelh.fsf@igel.home>
References: <AANLkTimtfUXN9oTQ=BaxNz+h+mgwFBPrzN_Nggbai+ZJ@mail.gmail.com>
	<m2bp6apelh.fsf@igel.home>
Date: Sun, 31 Oct 2010 19:10:37 +0300
Message-ID: <AANLkTimGUUhYgSQ6dCBtyaY5s1JQOqewU2RA78t4p8_6@mail.gmail.com>
Subject: Re: Why get/put_unaligned are hidden behind #ifdef __KERNEL__ on
 PowerPC and Microblaze?
From: Igor Zhbanov <izh1979@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/31 Andreas Schwab <schwab@linux-m68k.org>:
>
> Since <asm/unaligned.h> is not an exported header the point is moot.

And why not to export <asm/unaligned.h>? I think it will be useful to
have unified mechanism
for unaligned memory access in users pace. There are numerous
libraries that deal
with binary file formats with unaligned structure fields. Also there
are some network
protocols with unaligned fields of packets.

I think that unaligned memory access interface are stable, so it can
be safely exported
to user space. We have some other platform-related exported headers,
e.g. <asm/byteorder.h>,
so why not to export <asm/unaligned.h>. Let it be "official" way to
deal with unaligned data
in user space too.
