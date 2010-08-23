Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab0HWQeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:34:17 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44555 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab0HWQeO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:34:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LzzQ/HnJc1WpmH4YKuQPuU+LnrWQdVHnbHTjNzALxGLgZzs6DBBGPGoCggKjkrKAsj
         I+lJue+Ihr8Wu/wd8R5XOcqnjafEYJfMRsEpJzIanJ9mYb5mZT+7IGQEHzOzU1xsZJrt
         adW/4YZD/vaU/9OlMhnbFy0sBczKQUzbZpDI8=
MIME-Version: 1.0
In-Reply-To: <20100821160839.GA26375@merkur.ravnborg.org>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
	<1282391770.29609.1223.camel@localhost.localdomain>
	<AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>
	<20100821160839.GA26375@merkur.ravnborg.org>
Date: Mon, 23 Aug 2010 09:34:14 -0700
X-Google-Sender-Auth: hIf2F-99YBw8PNFc8eve5yOSJsk
Message-ID: <AANLkTinY6GcgVKznUOcxh28xS3Dvy71Ln4vS-eV8F+na@mail.gmail.com>
Subject: Re: [RFC] mlock/stack guard interaction fixup
From: Tony Luck <tony.luck@intel.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 9:08 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> Tony Luck already provided a VM_GROWSUP version.
>
>    See: http://lkml.org/lkml/2010/8/20/325
>
> [It is signed off by Tony Luc - but I guess they know each other ;-) ]

Tony Luc spends too much time looking at the To: and Cc: to make
sure that he spelled *other* peoples names correctly.

That patch doesn't apply any more because of the latest change to look
at vm_prev instead of calling find_vma() [N.B. the block comment above
check_stack_guard_page() still talks about find_vma()].  I can fix up my
patch ... but I have to wonder whether the new code doesn't leave a
hole again.  It assumes that any VM_GROWSDOWN object that is
found below the current one is the result of the stack vma having been
split. But couldn't an attacker have used MAP_GROWSDOWN when
placing their sneaky stack smashing mapping just below the stack?

-Tony
