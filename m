Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab2AEJNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 04:13:17 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44458 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab2AEJNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 04:13:11 -0500
Message-ID: <4F0569A3.5040407@openvz.org>
Date: Thu, 05 Jan 2012 13:13:07 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20111108 Iceape/2.0.14
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty: cleanup prohibition of direct opening for unix98
 pty master
References: <20120102172231.11476.57711.stgit@zurg> <20120103085110.17283.60539.stgit@zurg> <20120105002336.GA30069@kroah.com>
In-Reply-To: <20120105002336.GA30069@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Jan 03, 2012 at 12:51:11PM +0400, Konstantin Khlebnikov wrote:
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
>
> What tree did you make this patch against?  I get fuzz warnings when
> applying it to the tty-next branch (it's in the linux-next releases).
>
> Please rediff it and resend it.

Sorry for that, I did not expect such activity in tty-layer =)

>
> thanks,
>
> greg k-h

