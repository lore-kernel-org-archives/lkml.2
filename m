Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab1KQThz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 14:37:55 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36183 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322Ab1KQThy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 14:37:54 -0500
MIME-Version: 1.0
In-Reply-To: <CA+8MBb+SEF_0ORtbHq+ZpxQyE=WTVrGCPoY7ZH1zCDD8zoJ=Zg@mail.gmail.com>
References: <20111117184200.GA5037@www.outflux.net>
	<CA+8MBb+SEF_0ORtbHq+ZpxQyE=WTVrGCPoY7ZH1zCDD8zoJ=Zg@mail.gmail.com>
Date: Thu, 17 Nov 2011 11:37:53 -0800
X-Google-Sender-Auth: hRoFaMRJsS0XmPGku4ePElh1Cv8
Message-ID: <CAGXu5jK7kJotJVU8qAjEPACW6HEbbFTfLeAG+g+ccejGsqQ-9g@mail.gmail.com>
Subject: Re: [PATCH] pstore: gracefully handle NULL pstore_info functions
From: Kees Cook <keescook@chromium.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Chen Gong <gong.chen@linux.intel.com>, Don Zickus <dzickus@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 11:13 AM, Tony Luck <tony.luck@gmail.com> wrote:
> On Thu, Nov 17, 2011 at 10:42 AM, Kees Cook <keescook@chromium.org> wrote:
>> -       kmsg_dump_register(&pstore_dumper);
>> +       if (psi->write && psi->buf && psi->bufsize)
>> +               kmsg_dump_register(&pstore_dumper);
>
> I can see that you might not need the other parts of the pstore
> interface if your back-end is very simple (e.g. only has space for a
> single record). But stub functions are cheap - so it isn't clear who
> should pay the overhead.

Okay, fine by me. :) I'll resend with just the open/read/close/erase checked.

-Kees

-- 
Kees Cook
ChromeOS Security
