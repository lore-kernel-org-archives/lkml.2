Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389Ab1EBO3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 10:29:09 -0400
Received: from nocko.org ([173.245.73.87]:52940 "EHLO nocko.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136Ab1EBO3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 10:29:05 -0400
From: Shawn Nock <nock@nocko.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: rtlwifi: regression 39-rc5 (rtl8192ce)
References: <fa.edeGRjft5wqQRP07grcwfUVPlIA@ifi.uio.no>
	<fa.0KaksBH9ogj3psmzYEvXzvHxClw@ifi.uio.no>
Date: Mon, 02 May 2011 10:26:01 -0400
In-Reply-To: <fa.0KaksBH9ogj3psmzYEvXzvHxClw@ifi.uio.no> (Larry Finger's
	message of "Sun, 01 May 2011 20:12:21 UTC")
Message-ID: <m3d3k1b2me.fsf@nocko.org>
User-Agent: Gnus/5.110016 (No Gnus v0.16) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 05/01/2011 12:59 PM, Shawn Nock wrote:
>> During heavy network traffic (esp. flash video) I see the attached
>> NULL pointer dereference in 2.6.39-rc5 on an IBM Thinkpad
>> x120e. Immediately afterward a "scheduling while atomic" bug is
>> reported and the system becomes unresponsive. I am unable to produce
>> this problem in 2.6.38.4.
>> See attached backtrace and dmesg. Please let me know what I can
>> collect to make this problem easier to troubleshoot.
>
> Could you also supply the instruction byte sequence for the oops? It
> is the "Code:" line of the dump.

I had not been able to capture that, as the scheduler oops was triggered
during the call stack dump (before the Code line).

> I think you are using a 32-bit system. Is that correct?

Correct.

> Is there one URL that exposes this problem? If so, please sent that as
> well.

It had been speedtest.net (which *used* to crash this all the
time). I've since re-configured the kernel to allow it to build faster
(fedora .config trimmed to remove a lot of the unneeded modules). I can
no longer trigger this BUG.

I originally thought that this may be because I enabled the 8192CU
driver, but clean kernel without it also doesn't trigger the bug. My new
hypothesis is that building the kernel for the AMD processor type was a
mistake (the only other significant change was that I went back to
Pentium Pro as the CPU target).

As far as I can tell this problem is resolved (20+ hours without issue,
less than 20 min previously) and probably due to GCC not being aware of
this (newish) AMD processor.

Sorry for the false alarm and thanks,
Shawn

-- 
Shawn Nock (OpenPGP: 0x8132E623)
