Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab1EFQXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 12:23:12 -0400
Received: from smtpout04.highway.telekom.at ([195.3.96.117]:24974 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751615Ab1EFQXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 12:23:11 -0400
From: Melchior FRANZ <melchior.franz@gmail.com>
To: "Joey Lee" <jlee@novell.com>
Subject: Re: i915/kms/backlight-combo mode problem
Date: Fri, 6 May 2011 18:23:06 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.5; KDE/4.6.2; x86_64; ; )
Cc: chris@chris-wilson.co.uk, dri-devel@lists.freedesktop.org,
        carlos@strangeworlds.co.uk, tiwai@suse.de,
        linux-kernel@vger.kernel.org
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com> <201105061052.06638@rk-nord.at> <4DC47937020000230002C446@novprvlin0050.provo.novell.com>
In-Reply-To: <4DC47937020000230002C446@novprvlin0050.provo.novell.com>
X-Fingerprint: 9FFB C079 5B78 4F27 099C C6C6 7399 02D1 919B D903
X-PGP: http://members.aon.at/mfranz/melchior.franz
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201105061823.07083@rk-nord.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joey Lee -- Friday 06 May 2011:
> 於 五，2011-05-06 於 10:52 +0200，Melchior FRANZ 提到：
> > ... and changing backlight brightness worked with acpi_osi=Linux, too.
> > Unfortunately, that does no longer work now, although I haven't changed
> > anything. Pressing the brightness buttons causes some ACPI debug output,
> > but it doesn't adjust anything.

> hmm........ Takashi's patch works before, but doesn't work now?

Argh ... sorry Takashi. Joey is right. I thought I had tested that,
but apparently not. Indeed, your last patch prevents the backlight
from being turned off, but it also breaks the brightness adjustment
keys at runtime with acpi_osi=Linux. And without that it doesn't
work, anyway, just like before. I'll add some more debug messages ...



> Does that because my new patch for bko#34142 ? Could you please add
> acer-wmi to /etc/modprobe.d/blacklist then reboot machine ?

Done. No, your patch is not involved. But backing out Takashi's
patch and re-applying confirmed that it's that patch.

m.
