Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab1DJV2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 17:28:49 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51718 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab1DJV2s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 17:28:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=C6kbR3bHWCtW0RHAfFFQgG1F+GVUkoNx6MmDzBZsUwS20XyYqERcvVQ76eprS+PmUX
         x8bGuIhTw9oB+azIhTt6fHaFVxZEWLnIk6xPt7n5lQ6dsCDjhl4XCUfYQUQKlyHzCqM1
         CqM6XA4KRuIoouq/eKYHpHD56mh2pd8rstSAY=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=n+ckDXVk6rN=Mgh+BApbrPqPfmg@mail.gmail.com>
References: <BANLkTi=n+ckDXVk6rN=Mgh+BApbrPqPfmg@mail.gmail.com>
Date: Sun, 10 Apr 2011 17:28:45 -0400
X-Google-Sender-Auth: 999DXfnVsnhm0pgziMDm0R0Zgj4
Message-ID: <BANLkTikLBv1bzohbG7e+M47xJ_fDuES=9Q@mail.gmail.com>
Subject: Re: Crash with kfree(null) on MacBook? kobject_set_name_vargs
From: Bob Copeland <me@bobcopeland.com>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Botting <andy@andybotting.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/10 Rafał Miłecki <zajec5@gmail.com>:
> I'm writing new axi bus driver and one of the early testers reported
> it crashing for him. Andy is using MacBook and backtrace+debugging
> pretty clearly point to kfree being called on null string.

> bcopeland on #linux-wireless suggested turning on SLAB or SLUB. Is
> this going to provide some interesting info?

To be precise, I said slab or slub _debugging_.  The reason I said
this is that often a crash on kfree() is due to memory corruption.
Many places in the kernel rely on kfree(NULL) being a safe operation,
so it's likely something more than that.  SL?B debugging adds
poisoning and corresponding checks that detect several kinds of
corruption like buffer overruns, use-after-free, etc.

The other thing you can do is get the disassembly of the Code portion
for your oops and match it up with specific C code, look at the
register file in the oops and match that up with variable names, and
work backwards to figure out which pointers are broken.  Sometimes
this can be enlightening, like if a pointer has ascii values, or is a
small number (0 + some struct offset).
-- 
Bob Copeland %% www.bobcopeland.com
