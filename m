Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab2GZPII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:08:08 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:39144
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752452Ab2GZPIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:08:05 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q6QF7wpl032592
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Arend van Spriel <arend@broadcom.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Problem with commit cf03c5dac83609f09d9f0e9fa3c09d86daed614d
In-Reply-To: <20120726134926.GA10452@thinkpad-t410> (Seth Forshee's message of
	"Thu, 26 Jul 2012 08:49:26 -0500")
References: <gik3xqtzw3.fsf@karga.hank.lab>
	<20120726134926.GA10452@thinkpad-t410>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Thu, 26 Jul 2012 17:07:57 +0200
Message-ID: <gi7gtqlfw2.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Thu, 26 Jul 2012 17:08:00 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth Forshee <seth.forshee@canonical.com> writes:

> On Thu, Jul 26, 2012 at 03:28:44PM +0200, Dirk Gouders wrote:
>> Hi Seth,
>> 
>> today, I noticed a problem with the current kernel
>> (3.5.0-04773-gbdc0077): my laptop hangs during boot -- the last message
>> on the console is printed just before invoking `udevadm trigger'.
>> 
>> I bisected the problem and ended at commit
>> cf03c5dac83609f09d9f0e9fa3c09d86daed614d (brcm80211: smac: inform
>> mac80211 of the X2 regulatory domain).  However, I'm not sure that this
>> commit really is the reason for my problems, because the behaviour is a
>> bit different: at that state the machine not just hangs but the console
>> shows a trace which I append to the end of this mail -- but the trace
>> happens at the same state during the boot process.
>
> Hi Dirk,
>
> The NULL pointer dereference in wlc_phy_chanspec_band_validch is already
> fixed in edc7651f3a4ffa7fca37d92401562694121512ad. There was also
> another related crash that appeared after the introduction of 802.11ad
> support that's fixed in 32c336a5dfd16b4645c8a0dbc534efd02f079e02.
>
> So in all likelihood whatever problem your seeing in current -git is a
> different issue. One easy way to test this would be to prevent the
> brcmsmac module from loading and verify that you still get the hang,
> then rerun the bisection that way to keep those bugs from affecting your
> results.

Hi Seth,

thanks for your reply and sorry for the noise.

I followed your advice and tried to boot with the WLAN interface turned
off, and the problem still exists.  I'll start a new bisect session,
probably with one of the commits you mentioned as the first good commit.

Best regards,

Dirk
