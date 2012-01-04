Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab2ADS7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 13:59:23 -0500
Received: from mx2.compro.net ([12.186.155.4]:11299 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab2ADS7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 13:59:20 -0500
X-IronPort-AV: E=Sophos;i="4.71,457,1320642000"; 
   d="scan'208";a="7461654"
Message-ID: <4F04A187.2050705@compro.net>
Date: Wed, 04 Jan 2012 13:59:19 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Hounschell <dmarkh@cfl.rr.com>
Subject: Re: tty  TTY_HUPPED anomaly
References: <4EF49579.9040907@compro.net> <4EF4CC92.5090502@compro.net> <20111223204015.541924f2@pyx> <4F047767.5060708@compro.net> <20120104162745.76fc3852@pyramind.ukuu.org.uk>
In-Reply-To: <20120104162745.76fc3852@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 11:27 AM, Alan Cox wrote:
>> But what has carrier dropping got to do with an TIOCSETD ioctl. For that
>
> When the carrier is dropped and HUPCL is set then the tty is disconnected
> from the physical interface. It's specified behaviour and required for
> security. So by the time you go to issue the TIOCSETD you are no longer
> connected to the tty. That may well just be a timing change.
>
>> What can be done to prevent tty_hangup from being called after opening
>> the port? And if this is really supposed to happen, why does it not
>> always happen?
>
> It should only happen if the carrier is dropped.
>
>> Even if the first thing I do after opening the port is to clear HUPCL
>> and set CLOCAL, this still randomly happens the first time I open the
>> port after booting.
>
> I'd expect the behaviour to either be
>
> carrier high, stays high - open works, no hangup events seen
>
> or
>
> carrier low, stays low - open blocks, but open with O_NDELAY works,
> hangup events not seen.
>
> It's the act of the drop which is a hangup not the presence of low
> carrier if I remember the spec properly. The Synclink GT correctly does
> this as far as I can tell (I have no hardware or docs for it) but the
> code indicates that the hardware reports changes and it acts on them
> properly (checking CLOCAL etc).
>
>
> I would guess (given the distro change is the trigger) that you've got a
> SuSE problem not a kernel one. The kernel behaviour and code looks
> correct. My guess therefore is that newer SuSE is running stuff in the
> boot which is probing serial ports and messing with the carrier wrongly
> and in ways it didn't use to. That would fit the fact that something
> similarly broken has apparently also appeared in the Fedora user space
> bootup.
>

Yes,  I never really though it was a kernel problem. All though I can't 
say I agree with the HUPCL/security thing. In any case, with the 
Synclink cards, at first open after boot of SuSE-12.1, CLOCAL is not 
set. Whereas all pre SuSE-12.1 releases do have CLOCAL set.


Mark

