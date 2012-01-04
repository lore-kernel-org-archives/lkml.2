Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab2ADP7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:59:45 -0500
Received: from mx2.compro.net ([12.186.155.4]:61733 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756145Ab2ADP7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:59:40 -0500
X-IronPort-AV: E=Sophos;i="4.71,456,1320642000"; 
   d="scan'208";a="7460498"
Message-ID: <4F047767.5060708@compro.net>
Date: Wed, 04 Jan 2012 10:59:35 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Hounschell <dmarkh@cfl.rr.com>
Subject: Re: tty  TTY_HUPPED anomaly
References: <4EF49579.9040907@compro.net> <4EF4CC92.5090502@compro.net> <20111223204015.541924f2@pyx>
In-Reply-To: <20111223204015.541924f2@pyx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2011 03:40 PM, Alan Cox wrote:
>
>> I turned the TTY_DEBUG_HANGUP and added some additional printks. You see
>> below the first port works just fine but the second fails because
>> something is calling the tty_hangup function around 70usecs after I open
>> the device???
>> What and Why???
>
> The driver will be - and because the carrier dropped and the HUPCL flag
> is set on the port.
>

Thanks Alan,

But what has carrier dropping got to do with an TIOCSETD ioctl. For that 
matter, any operation other than an actual read or write to the port? 
This seems wrong. You've obviously looked at my code being executed. 
What can be done to prevent tty_hangup from being called after opening 
the port? And if this is really supposed to happen, why does it not 
always happen?

Even if the first thing I do after opening the port is to clear HUPCL 
and set CLOCAL, this still randomly happens the first time I open the 
port after booting.

Thanks again for your help
Mark



