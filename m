Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab2KEJLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:11:31 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:63591 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab2KEJL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 04:11:29 -0500
Date: Mon, 5 Nov 2012 01:11:18 -0800
From: Jonathan Nieder <jrnieder@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, John Stultz <john.stultz@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Janne Boman <janne.m.boman@gmail.com>,
        Heinz Wiesinger <HMWiesinger@gmx.at>, rtc-linux@googlegroups.com
Subject: [regression] Re: [ 049/149] rtc: Disable the alarm in the hardware
 (v2)
Message-ID: <20121105091118.GA12721@elie.Belkin>
References: <20120330195823.GA31857@kroah.com>
 <20120330194844.399828645@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120330194844.399828645@linuxfoundation.org>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In March, Greg KH wrote:

> 3.2-stable review patch.  If anyone has any objections, please let me know.

Sorry, I'm a little late.  This seems to be causing spurious wakeups
after shutdown on some systems just like v1 did. :/

Janne Boman reports[1], using an HP EliteBook 8530w:

| I'm unable to shutdown my system via normal means. The system
| completes the shutdown process, all hardware lights are off, but then
| somehow it restarts.

Based on a quick web search, Heinz Wiesinger, using the same model,
ran into the same problem and bisected it to this patch:

  https://bugzilla.kernel.org/show_bug.cgi?id=44261

Janne confirmed the same by testing kernels closely based on 3.2.13
and 3.2.14 --- 3.2.13 shut down fine, while on 3.2.14 "shutdown -h
now" behaved roughly speaking like "reboot".  A kernel close to 3.6.4
was also affected.

Known problem?  An acpidump and kernel log can be found at [2].

Looking forward to your thoughts,
Jonathan

[1] http://bugs.debian.org/691902
[2] http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=78;bug=691902
