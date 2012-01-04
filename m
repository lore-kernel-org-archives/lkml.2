Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab2ADN0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 08:26:43 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54782 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab2ADN0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 08:26:40 -0500
Message-ID: <4F045386.3050706@openvz.org>
Date: Wed, 04 Jan 2012 17:26:30 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20111108 Iceape/2.0.14
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty: cleanup prohibition of direct opening for unix98
 pty master
References: <20120102172231.11476.57711.stgit@zurg> <20120103085110.17283.60539.stgit@zurg>  <CA+55aFyG476bzW1kBeF0MFRkXZkumaG-SzMexoPLdPFAzDUG6A@mail.gmail.com>
In-Reply-To: <CA+55aFyG476bzW1kBeF0MFRkXZkumaG-SzMexoPLdPFAzDUG6A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Looks ok as far as I can tell, and does indeed clean things up. I
> assume somebody tested the case that we used to have issues with?

Yes of course I tested it.

>
>                      Linus
>
> On Tue, Jan 3, 2012 at 12:51 AM, Konstantin Khlebnikov
> <khlebnikov@openvz.org>  wrote:
>> cleanup hack added in v2.6.27-3203-g15582d3
>>
>> comment from that patch:
>>
>> : pty: If the administrator creates a device for a ptmx slave we should not error
>> :
>> : The open path for ptmx slaves is via the ptmx device. Opening them any
>> : other way is not allowed. Vegard Nossum found that previously this was not
>> : the case and mknod foo c 128 42; cat foo would produce nasty diagnostics
>> :
>> : Signed-off-by: Alan Cox<alan@redhat.com>
>> : Signed-off-by: Linus Torvalds<torvalds@linux-foundation.org>
>>
>> devpts_get_tty() returns non-null only for inodes on devpts, but there is no
>> inodes for master-devices, /dev/ptmx (/dev/pts/ptmx) is the only way to open them.
>> Thus we can completely forbid lookup for master-devices and eliminate that hack in
>> tty_init_dev() because tty_open() will get EIO from tty_driver_lookup_tty().
>>
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
