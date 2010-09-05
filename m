Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab0IEQkJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 12:40:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47822 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab0IEQkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 12:40:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=uptdlievYsYAbK9CQGiSW1vPi+yyy/lRXqVIrJgKtZTdySRXEC07K+grCDitviiWVD
         Aq+OM16++GiMYQP1w+Fmawy02o+AuNchuRoouhBk0TAS7JWXQTcXB0YMGArexo1zqztP
         VOU/OM0LEH59+Czky48Mng4LuSkLIpIQfLyNk=
MIME-Version: 1.0
In-Reply-To: <8u3s8d$jg1fmi@orsmga001.jf.intel.com>
References: <1283588234-2514-1-git-send-email-penberg@kernel.org>
	<89k83a$9hv9li@azsmga001.ch.intel.com>
	<AANLkTi=_OW5NvnS1oWzt3DW9CPPwNX_sAkPh_QOuXzhv@mail.gmail.com>
	<alpine.LSU.2.00.1009041244440.3044@sister.anvils>
	<87vd6ls0jd.fsf@turtle.gmx.de>
	<4C83C124.8050408@kernel.org>
	<8u3s8d$jg1fmi@orsmga001.jf.intel.com>
Date: Sun, 5 Sep 2010 19:40:06 +0300
X-Google-Sender-Auth: iay3n7xWBXXLizozYiaQsN_lLAI
Message-ID: <AANLkTikjBztwp5rcGKGWc_6DLkFu5CTXAbePTbjEfyML@mail.gmail.com>
Subject: Re: [PATCH] Revert "drm/i915: fix vblank wait test condition"
From: Pekka Enberg <penberg@kernel.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Sven Joachim <svenjoac@gmx.de>, Hugh Dickins <hughd@google.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 05 Sep 2010 19:11:16 +0300, Pekka Enberg <penberg@kernel.org> wrote:
>> Is someone picking this patch up or am I supposed to send it to Linus?

On Sun, Sep 5, 2010 at 7:23 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> I have applied this patch to
>
> http://cgit.freedesktop.org/~ickle/drm-intel/
>
> Thanks.

The "drm-intel" branch on top of 2.6.36-rc3 works OK on my machine. I
do see the following errors in dmesg but they seem to be harmless:

[    1.004937] render error detected, EIR: 0x00000010
[    1.004981] page table error
[    1.005018]   PGTBL_ER: 0x00000102
[    1.005058] [drm:i915_report_and_clear_eir] *ERROR* EIR stuck:
0x00000010, masking
[    1.005139] render error detected, EIR: 0x00000010
[    1.005194] page table error
[    1.005244]   PGTBL_ER: 0x00000102
[    1.660043] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
plane, expect flickering: entries required = 36, available = 31.

[snip]

[    4.950117] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
plane, expect flickering: entries required = 36, available = 31.
[    5.176515] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
plane, expect flickering: entries required = 36, available = 31.
[    5.420040] usb 5-1: new full speed USB device using uhci_hcd and address 3
[    5.570066] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
plane, expect flickering: entries required = 36, available = 31.
[    5.776699] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
plane, expect flickering: entries required = 36, available = 31.
[    7.830162] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
plane, expect flickering: entries required = 36, available = 31.
[    8.036329] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
plane, expect flickering: entries required = 36, available = 31.
[    8.412362] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
plane, expect flickering: entries required = 36, available = 31.
[    8.616325] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
plane, expect flickering: entries required = 36, available = 31.
[    8.992369] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
plane, expect flickering: entries required = 36, available = 31.
[    9.196325] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
plane, expect flickering: entries required = 36, available = 31.
[   14.250106] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
plane, expect flickering: entries required = 36, available = 31.
[   14.456280] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
plane, expect flickering: entries required = 36, available = 31.
[   14.852445] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
plane, expect flickering: entries required = 36, available = 31.
[   15.054263] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
plane, expect flickering: entries required = 36, available = 31.
[   15.432298] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
plane, expect flickering: entries required = 36, available = 31.
[   15.636248] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
plane, expect flickering: entries required = 36, available = 31.
[   16.560078] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
plane, expect flickering: entries required = 36, available = 31.
[   16.766246] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for
plane, expect flickering: entries required = 36, available = 31.

                        Pekka
