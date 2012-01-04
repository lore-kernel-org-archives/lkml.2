Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab2ADUyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 15:54:35 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33345 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab2ADUyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 15:54:33 -0500
Message-ID: <4F04BC85.9060803@suse.cz>
Date: Wed, 04 Jan 2012 21:54:29 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20111223 Thunderbird/10.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: serial ports now asserting DTR and RTS during boot; breaks connected
 hardware
References: <20120103153707.GA12771@redhat.com> <20120103160655.69107c93@pyramind.ukuu.org.uk>
In-Reply-To: <20120103160655.69107c93@pyramind.ukuu.org.uk>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2012 05:06 PM, Alan Cox wrote:
> On Tue, 3 Jan 2012 10:37:07 -0500
> Dave Jones <davej@redhat.com> wrote:
> 
>> Jiri,
>> We got this report from a user who notes a change in behaviour for
>> his serial hardware over the last few kernel versions.
>>  
>> https://bugzilla.redhat.com/show_bug.cgi?id=771010
>>
>> This sounds like it might be related to your DTR/RTS changes back in March 2011 maybe ? 
> 
> Looks like your userspace to me at first glance.
> 
> ftdi_sio sets up the modem lines in set_termios. Set_termios is called
> from ftdi_open. ftdi_open is triggered by userspace.
> 
>>  > The following code in the ftdi_sio driver is one suspect but this behavior
>>  > happens on 8250 UARTs also so it is systemic now,
> 
> Likewise 8250 sets up the lines in serial8250_startup. This is called via
> uart_startup which is called via open.

Ok, let's apply the cut&paste rule. Does uninstalling ModemManager fix
the issue?

-- 
js
suse labs
