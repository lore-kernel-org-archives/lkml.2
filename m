Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab1AYT6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 14:58:52 -0500
Received: from smtp-out.google.com ([74.125.121.67]:33651 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab1AYT6v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 14:58:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hbijucxfKmjrYImHw3G21AX2p3G4fgHY1VF3T/3JbdkttB0MXyA3l6YaSuDiZMGWRf
         9GCHfTI7qg4itBdQx2qg==
MIME-Version: 1.0
In-Reply-To: <20110125030105.GA8761@kroah.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com> <20110125030105.GA8761@kroah.com>
From: Mike Waychison <mikew@google.com>
Date: Tue, 25 Jan 2011 11:58:27 -0800
Message-ID: <AANLkTim_KmmtAULeeBBsoz_BkxhbQLg24PK_pfPQiLtE@mail.gmail.com>
Subject: Re: [PATCH v1 0/6] google firmware support
To: Greg KH <greg@kroah.com>
Cc: torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Aaron Durbin <adurbin@google.com>, Duncan Laurie <dlaurie@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 7:01 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, Jan 24, 2011 at 04:24:34PM -0800, Mike Waychison wrote:
>>
>>    - [5] prepares for [6] by introducing prepend_to_dmesg() which
>>      allows drivers to prepend pre-kernel messages to the dmesg at
>>      bootup.
>
> That seems "rude".  Why can't you just pick out from the kernel log the
> data you need when it gets printed?  This seems like you feel your code
> should always get a "First Post!" message.

Well, the use case we have is that we prepend all the bios output (and
anything emitted by option roms and boot loaders via int 10h).  This
typically runs in the 100+ lines of output.

Basically, everything the user sees on the console after power up is
available to him in the dmesg.  We did this out of convenience as it
makes for a good looking log :)

That said, it's dmesg, and we don't build automation on anything in
there if we can help it.  I can move this memory console dump
elsewhere (/sys/firmware/log ?)

>  What happens when someone
> else wants this and you get dueling "firsts"?

No idea :)

Originally I had something a little different for getting this done:
I had introduced a weak symbol called something like
"arch_dmesg_fixup()" that could be made strong in the architecture
code somewhere (in my case, it was in this driver).    That sort of
pattern would allow us to enforce having only one 'first post'
callback :)

Anyhow, let me know what you think about /sys/firmware/log or similar.
