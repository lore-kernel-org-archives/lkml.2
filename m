Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab2CMQf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:35:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59459 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab2CMQf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:35:56 -0400
Date: Tue, 13 Mar 2012 09:35:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ben Guthro <ben@guthro.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: 3.2.10 stable build failures?
Message-ID: <20120313163551.GA3875@kroah.com>
References: <CAOvdn6W+-w2wYdqLCMHUDJr0WDXn3ssBvWnvvZy7Ni_FG2C0jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOvdn6W+-w2wYdqLCMHUDJr0WDXn3ssBvWnvvZy7Ni_FG2C0jQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 09:25:03AM -0400, Ben Guthro wrote:
> Hello - I merged the 3.2.10 stable patch set that you pushed yesterday
> into my tree, but am seeing build failures that
> WM1811_JACKDET_MODE_MASK is undeclared.
> 
> This looks like it originated with the following commit:
> 
> commit 315e73b400c9a287a53efb5f857d308589674ac5
> Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Date:   Mon Feb 20 21:32:32 2012 +0000
> 
>     mfd: Test for jack detection when deciding if wm8994 should suspend
> 
>     commit e7c248a049c2aac21bded0b0722caee6f0e57256 upstream.
> 
>     The jack detection on WM1811 is often required during system suspend, add
>     it as another check when deciding if we should suspend.
> 
>     Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>     Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 
> 
> I've grepped the entire 3.2.10 source tree for
> WM1811_JACKDET_MODE_MASK - but have only found the occurence in the if
> statement introduced in the above changeset

Ugh, you are right, thanks for pointing it out to me.  My .config I test
with here didn't have that driver enabled, my appologies.

I'll go do a new release right now, reverting this patch.

Mark, if you want this patch in 3.2, please rework it and resend it to
me.

thanks,

greg k-h
