Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2AGT3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 14:29:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58463 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab2AGT3c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 14:29:32 -0500
MIME-Version: 1.0
In-Reply-To: <20120106223148.GN20752@decadent.org.uk>
References: <20120106201126.GA7239@kroah.com> <CAMuHMdVdTcJFePA2tf-jqnLGW_2i7rJLqAX521SM+rz0YzXJNg@mail.gmail.com>
 <20120106220608.GA20623@suse.de> <20120106223148.GN20752@decadent.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 7 Jan 2012 11:29:09 -0800
X-Google-Sender-Auth: Brgdy6dG-BF0qVUCACowNjU05iM
Message-ID: <CA+55aFxzx0Z7QKXE9xzOcY3WOtAs18MPkP9kfT3tk1sNTgWrHw@mail.gmail.com>
Subject: Re: [GIT PATCH] driver core merge for 3.3
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg KH <gregkh@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 6, 2012 at 2:31 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
>
> It works just fine on UP x86.  However I have been made aware that
> it breaks on m68k and I told you as much in
> <1325462025.13595.189.camel@deadeye>:
>
>> None of these architectures appears to call register_cpu():
>>
>>     c6x frv h8300 m68k microblaze openrisc score um xtensa
>>
>> and therefore they will all panic at boot following this change (commit
>> ccbc60d3e19a1b6ae66ca0d89b3da02dde62088b).  So either I can try to fix
>> them or else it must be reverted for now.

Ok, let's try to move forward, and just have those architectures add
the appropriate "register_cpu()" calls. I can live with them breaking
for a short while, and hopefully me merging this will result in it
quickly being fixed.

                      Linus
