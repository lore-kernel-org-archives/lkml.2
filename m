Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab1DSKSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 06:18:13 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46200 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab1DSKSK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 06:18:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UUFtRlY/51/DGRD6c87MGz059P1j19PezjWrR9/YEKcHDw1tkWhlzCGSieR9eseJsJ
         eKq8T2pBMjv55HNaVodreNjRrZXCETfNkjirBFV1Ij4MoukJtVAxBMrmxOAdxLto7mNy
         m4GDSPM95p4SAVQp7sQI+i3/1kRmxG5sSS1mE=
MIME-Version: 1.0
In-Reply-To: <201104182159.54316.rjw@sisk.pl>
References: <201104130205.26988.rjw@sisk.pl>
	<201104170135.19388.rjw@sisk.pl>
	<201104170142.10723.rjw@sisk.pl>
	<201104182159.54316.rjw@sisk.pl>
Date: Tue, 19 Apr 2011 19:18:10 +0900
Message-ID: <BANLkTimZpXAH7uGTDmYJSJJWgX=H5md0JQ@mail.gmail.com>
Subject: Re: [Update][PATCH 7/9] PM / Runtime: Add generic clock manipulation
 rountines for runtime PM
From: Magnus Damm <magnus.damm@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Tue, Apr 19, 2011 at 4:59 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Many different platforms and subsystems may want to disable device
> clocks during suspend and enable them during resume which is going to
> be done in a very similar way in all those cases.  For this reason,
> provide generic routines for the manipulation of device clocks during
> suspend and resume.
>
> Convert the ARM shmobile platform to using the new routines.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>
> Hi,
>
> The previous version of the patch had a build problem for CONFIG_HAVE_CLK
> unset and a the name of pm_runtime_clock_add_notifier() misspelled (a
> couple of times).

Thanks for your work on this. I like that we get closer to a shared code base.

Do you have any plans to add support for multiple clocks per struct
device? I had some plans to play around with that myself, but if we're
moving the code to a common place then this obviously becomes a bit
more complicated.

It's rather common that each hardware block in an SoC is connected to
more than a single clock. This needs to be managed by software
somehow.

So if the plan is to make to the code generic, how about allowing the
architecture to associate clocks with each struct device somehow?

Thanks,

/ magnus
