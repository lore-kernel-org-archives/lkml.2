Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab0JGTtT convert rfc822-to-quoted-printable (ORCPT
	<rfc822;w@1wt.eu>); Thu, 7 Oct 2010 15:49:19 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55546 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab0JGTtR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 15:49:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=SKF426U3lJDCx8t17H65YUNu0/cwM25VEm1o1lonE5lZlZwbxel38IHLwCeejbWqpI
         7GjgwQCoVEKxOPYxNPQLgUcHjd0D4FDKh2enzqa576pUTuWdJtfj+aBoI67uIbEkfj4F
         mQnCEWslaEJvsv7+YkN+cxVXf6h8nd+KcVZm8=
MIME-Version: 1.0
In-Reply-To: <1286480364.23836.17.camel@c-dwalke-linux.qualcomm.com>
References: <1286476616-3373-1-git-send-email-dwalker@codeaurora.org>
 <AANLkTinxorq2XhJdGDNQuUghxzr1q6OW=S1VjupOu5nH@mail.gmail.com> <1286480364.23836.17.camel@c-dwalke-linux.qualcomm.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 7 Oct 2010 15:48:54 -0400
X-Google-Sender-Auth: mVqIbgg6F-dh5cGP6QLPDom3oK8
Message-ID: <AANLkTi=8Et=Z6zrzbZa3L0MO=cBjjh7L=XU2=PDEbzWW@mail.gmail.com>
Subject: Re: [PATCH] serial: DCC(JTAG) serial and console emulation support
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, "Hyok S. Choi" <hyok.choi@samsung.com>,
        Tony Lindgren <tony@atomide.com>, Jeff Ohlstein <johlstei@quicinc.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ben Dooks <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Feng Tang <feng.tang@intel.com>, Tobias Klauser <tklauser@distanz.ch>,
        Jason Wessel <jason.wessel@windriver.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from QUOTED-PRINTABLE to 8bit by mail.home.local id o97JoQNV031930

On Thu, Oct 7, 2010 at 15:39, Daniel Walker wrote:
> On Thu, 2010-10-07 at 15:25 -0400, Mike Frysinger wrote:
>> On Thu, Oct 7, 2010 at 14:36, Daniel Walker wrote:
>> > Many of JTAG debuggers for ARM support DCC protocol over JTAG
>> > connection, which is very useful to debug hardwares which has no
>> > serial port. This patch adds DCC serial emulation and the console
>> > support. System timer based polling method is used for the
>> > emulation of serial input interrupt handling.
>>
>> why use serial_core at all ?  seems like you could just use the tty
>> layer directly.  i did that with drivers/char/bfin_jtag_comm.c.
>>
>> although, there's the suggestion in the air that my jtag driver could
>> be converted to the HVC framework to even further simplify things.
>> but no one thinks it should be serial_core :).
>
> It will actually create a serial port on ttyS* if you want it to.. It
> could be debatable if that's useful, but I didn't rip that out because
> Hyok had that in his original code (he thought it was useful) ..

i dont think hijacking the "ttyS" namespace is acceptable, even if
it's behind a Kconfig.  other people have tried in the past (myself
included) and been shot down.  sounds like a shim for crappy userspace
apps that blindly assume /dev/ttyS*.  is that really an issue anymore
though now that things like /dev/ttyUSB* are so common and people are
used to picking between multiple serial sources ?
-mike
