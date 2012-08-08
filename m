Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030761Ab2HHTdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:33:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35212 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758084Ab2HHTdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:33:06 -0400
Message-ID: <5022BEED.9090106@suse.cz>
Date: Wed, 08 Aug 2012 21:33:01 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120731 Thunderbird/15.0
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
Subject: Re: [PATCH 02/41] TTY: 68328serial, fix compilation
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz> <1344368886-24033-3-git-send-email-jslaby@suse.cz> <20120808162450.54158ce3@bob.linux.org.uk>
In-Reply-To: <20120808162450.54158ce3@bob.linux.org.uk>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 05:24 PM, Alan Cox wrote:
> On Tue,  7 Aug 2012 21:47:27 +0200
> Jiri Slaby <jslaby@suse.cz> wrote:
> 
>> tty_struct->termios is no longer a pointer. This was changed recently
>> by "tty: move the termios object into the tty". But 68328serial was
>> not changed, so we now have a compilation error:
>> 68328serial.c: In function 'change_speed':
>> 68328serial.c:518:22: error: invalid type argument of '->' (have
>> 'struct ktermios') 68328serial.c: In function 'rs_set_ldisc':
>> 68328serial.c:620:31: error: invalid type argument of '->' (have
>> 'struct ktermios') 68328serial.c: In function 'rs_set_termios':
>> 68328serial.c:988:20: error: invalid type argument of '->' (have
>> 'struct ktermios')
>>
>> Fix that now.
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Cc: Alan Cox <alan@linux.intel.com>
> 
> Cool - I couldn't even find a compile chain or config to test this. I'd
> assumed it was broken and really wanted dumping in staging (it still
> looks that way 8))

Heh, I cannot tell if there is any user at all. The only thing I know is
it used to compile cleanly the last time I tried and it became broken
now :).

BTW you perhaps know that, compilers for most arches are at:
ftp.kernel.org/pub/tools/crosstool/files/bin/

regards,
-- 
js
suse labs
