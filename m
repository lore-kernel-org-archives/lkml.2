Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab2I0OSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:18:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58581 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab2I0OSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:18:09 -0400
Message-ID: <5064600D.1090506@zytor.com>
Date: Thu, 27 Sep 2012 07:17:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
References: <20120922180639.GC11610@moon> <20120922200731.GD14004@kroah.com> <20120922201144.GD11610@moon> <20120922215232.GA25778@moon> <20120923010953.GA17663@kroah.com> <20120923064007.GA2994@moon> <34f6ba7b-2c50-492e-9267-52d328a8d37f@email.android.com> <20120924141441.GD16532@moon> <20120927140502.GB12552@moon> <20120927151447.2460ce44@pyramind.ukuu.org.uk> <20120927141425.GG6618@moon>
In-Reply-To: <20120927141425.GG6618@moon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 07:14 AM, Cyrill Gorcunov wrote:
> On Thu, Sep 27, 2012 at 03:14:47PM +0100, Alan Cox wrote:
>>> Alan, Greg, what's opinion? This flags fetching is the same as say fetching
>>> of termios settings, once fetched they can be changed immediately, and it's
>>> up to caller what to do with termios settings. No?
>>
>> I think you need to explain what you expect to be doing with it, and why
>> it is safe in that application.
>
> OK, it seems it was unclear from changelog. We need to know this parameters
> to be able to restore tty connection after checkpoint.
>
> While we easily can fetch termios settings and such, there are few bits which
> are missed to expord. So this patch provides them to user-space.
>

What bothers me (and the same applies to termios) is that you have NO 
idea if your particular process is the "owner" of that tty.  tty users 
use out-of-band protocols, often implicit, to determine which process 
"owns" the tty state.

If you can't guarantee that ALL those processes are stopped and 
checkpointed/restarted, you have a huge problem.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

