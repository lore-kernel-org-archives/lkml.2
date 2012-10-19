Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab2JSLke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 07:40:34 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:56378 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab2JSLkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 07:40:32 -0400
Message-ID: <50813C15.1000202@ahsoftware.de>
Date: Fri, 19 Oct 2012 13:40:05 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: RFC: sign the modules at install time
References: <20121019142147.76f67505862afe5614167428@canb.auug.org.au> <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com> <87txtso9xw.fsf@rustcorp.com.au> <CA+55aFxZdtD51AVKLtKK95ooh8VB8-5Tt8nHsxSUT67CBRrp2g@mail.gmail.com> <871ugwny1n.fsf@rustcorp.com.au> <CA+55aFwTz6xadNL37H6Qb8+rWNefn0cQ0URFPfD=Ea=J54xzGg@mail.gmail.com> <87fw5bp858.fsf@rustcorp.com.au> <2201.1350645923@warthog.procyon.org.uk>
In-Reply-To: <2201.1350645923@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.10.2012 13:25, schrieb David Howells:
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
>> So, this still generates the keys during the normal build, right?  That
>> would be a problem for build servers that have limited randomness
>> available to them, I think.
>
> openssl uses /dev/urandom (unlike gpg), so that's less of a problem.

Hmm, please don't forget the case where people want to build the kernel 
in some sandbox (like chroot or similiar) where the build-system doesn't 
have access to /dev.

I haven't checked what openssl does if that is the case, so maybe the 
script which calls it should either offer a verbose error message for 
that case, or should be prepared that openssl might fail because of a 
missing /dev/urandom.

If that's already done, just ignore my email, I haven't read the 
complete thread, sorry.

Regards,

Alexander
