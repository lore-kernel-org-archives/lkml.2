Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab2EHQ2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:28:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36301 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab2EHQ2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:28:04 -0400
MIME-Version: 1.0
In-Reply-To: <CA+1xoqenmuF+K7SAajM5L7zSkKxVKbN7GAdhMJmNjCNW1VQ3Yg@mail.gmail.com>
References: <1336004953.4240.9.camel@mop> <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+1xoqdk_yGQyX+6yHyvHsQ1hXiraOzbhVZAgmLmmtMtVTPeGQ@mail.gmail.com>
 <CAPXgP11882vP5GtMmwdsw-w6-D6q9NXHNsHem3Ump17__r2xOQ@mail.gmail.com>
 <CAPXgP11G9Tv37qTy_kLcYphosUXc+2uQDzU6BYekGdVt3Oye4A@mail.gmail.com> <CA+1xoqenmuF+K7SAajM5L7zSkKxVKbN7GAdhMJmNjCNW1VQ3Yg@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 8 May 2012 18:27:42 +0200
Message-ID: <CAPXgP12eWBFcONpYCxHdoED1sy21GYuBdfr46JzgRgXy2EL=+w@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 5:57 PM, Sasha Levin <levinsasha928@gmail.com> wrote:

> What about PRINTK_TIME? Are there plans to enable it on console output?

Yeah, we should restore the old behaviour. The timestamp is always
stored internally, regardless of the CONFIG_PRINTK_TIME or tunable
setting. At the moment, seems they are only (conditionally) added to
the syslog() output and (unconditionally) to the /dev/kmsg export.

I guess we just re-define CONFIG_PRINTK_TIME and the tunable as: "show
time in syslog() and on the console output".

Karel will likely extend dmesg(1) to use /dev/kmsg instead of syslog()
when it's readable and dmesg(1) can still show the time stamps read
from /dev/kmsg, even when CONFIG_PRINTK_TIME is not set, so the old
tunable basically becomes a "show timestamps on the console" flag. :)

Kay
