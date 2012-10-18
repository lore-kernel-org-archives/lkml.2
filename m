Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab2JRDOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 23:14:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41747 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2JRDOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 23:14:54 -0400
MIME-Version: 1.0
In-Reply-To: <20121018005432.GA20163@kroah.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
 <3179.1350512382@warthog.procyon.org.uk> <CA+55aFzEH1jguw8NB90si2uxvyO63FuKPOc8wiEPRCYwruSzRg@mail.gmail.com>
 <20121018005432.GA20163@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 17 Oct 2012 20:14:31 -0700
X-Google-Sender-Auth: Vnga67OBnXK2r0ncRLiOAbmgPZc
Message-ID: <CA+55aFxo-b3nUAWhG0N7hJkH1goStvBBTCT7XWGD+RJLG0=fsQ@mail.gmail.com>
Subject: Re: RFC: sign the modules at install time
To: Greg KH <gregkh@linuxfoundation.org>
Cc: David Howells <dhowells@redhat.com>, David Miller <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jwboyer@redhat.com, pjones@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 5:54 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>> One of the main sane use-cases for module signing is:
>>
>>  - CONFIG_CHECK_SIGNATURE=y
>>  - randomly generated one-time key
>>  - "make modules_install; make install"
>>  - "make clean" to get rid of the keys.
>>  - reboot.
>
> I want that too, but right now 'make clean' leaves the keys around,
> which seems a bit dangerous to me.

Oh, yes, we should make sure the key file gets cleaned up at "make clean".

I have to admit that I never do the whole "make clean/distclean" any
more, I have gotten so used to just going

    git clean -dqfx

to get rid of all generated files in a git directory that I no longer
depend on the makefile getting it right for me.

                  Linus
