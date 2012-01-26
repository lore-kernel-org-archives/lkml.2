Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab2AZNPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:15:47 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57306 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2AZNPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:15:46 -0500
Message-ID: <4F2151FD.4050101@suse.cz>
Date: Thu, 26 Jan 2012 14:15:41 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120118 Thunderbird/10.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Why are not processes HUPped when they open /dev/console?
References: <4F207660.500@suse.cz> <20120125214522.7a49cf39@pyramind.ukuu.org.uk>
In-Reply-To: <20120125214522.7a49cf39@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2012 10:45 PM, Alan Cox wrote:
> On Wed, 25 Jan 2012 22:38:40 +0100
> Jiri Slaby <jslaby@suse.cz> wrote:
> 
>> Hello,
>>
>> don't you remember by a chance the reason for this test in __tty_hangup:
>>   if (filp->f_op->write != tty_write)
>>
>> The logic there is not to HUP processes that have this tty open via
>> /dev/console.
> 
> Because if you hang up the console the machine crashes ?
>
> At least that's what used to happen.

It does not crash anymore. However the system (systemd more precisely)
is confused a bit (well, a huge). So I suppose the test has its meaning.

The whole exercise was about how to fix the userspace issue introduced
by the added infinite timeout.

I think the proper solution here is just not to call vhangup in
userspace for the device which is /dev/console. It never worked anyway.
Because the HUP signal was never sent and it always timed out.

thanks,
-- 
js
suse labs
