Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab2BBXXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:23:42 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44701 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab2BBXXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:23:40 -0500
Message-ID: <4F2B1AF8.2000000@suse.cz>
Date: Fri, 03 Feb 2012 00:23:36 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120124 Thunderbird/10.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jiri Slaby <jirislaby@gmail.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: Re: [PATCH 3/5] TTY: use tty_standard_install
References: <1327954472-26594-1-git-send-email-jslaby@suse.cz> <1327954472-26594-3-git-send-email-jslaby@suse.cz> <20120202230518.GA18903@kroah.com>
In-Reply-To: <20120202230518.GA18903@kroah.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 12:05 AM, Greg KH wrote:
> On Mon, Jan 30, 2012 at 09:14:30PM +0100, Jiri Slaby wrote:
>> Use the helper in the rest of the tty drivers. This is a simple
>> replacement.
> 
> It would be, if you actually built this patch, as it is, it breaks :(

Yes, I replied to this patch that I sent you some broken bastard. Also I
attached the correct version...

>> --- a/drivers/isdn/capi/capi.c
>> +++ b/drivers/isdn/capi/capi.c
>> @@ -1015,14 +1015,11 @@ capinc_tty_install(struct tty_driver *driver, struct tty_struct *tty)
>>  {
>>  	int idx = tty->index;
>>  	struct capiminor *mp = capiminor_get(idx);
>> -	int ret = tty_init_termios(tty);
>> +	int ret = tty_standard_install(tty);
> 
> This, and, all of the other calls in this patch, should be (driver, tty)
> for the function arguments, right?
> 
> That seems to fix the build for me, so I've checked it in, but please
> verify that I got it right.

It is OK.

Sorry for that.

thanks,
-- 
js
suse labs
