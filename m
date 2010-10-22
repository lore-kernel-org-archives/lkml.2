Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab0JVPWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 11:22:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755180Ab0JVPWQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 11:22:16 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=M3fpiqii_0qoZawRiZfw1=WZPOhLgKesjFaTu@mail.gmail.com>
References: <AANLkTi=M3fpiqii_0qoZawRiZfw1=WZPOhLgKesjFaTu@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 Oct 2010 08:21:15 -0700
Message-ID: <AANLkTinm8okUNs8P_iFfnaG0d5g2DGTpphTVC766ofmm@mail.gmail.com>
Subject: Re: 2.6.37-git1
To: Anca Emanuel <anca.emanuel@gmail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 12:35 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
>  CC [M]  drivers/net/wireless/hostap/hostap_cs.o
> drivers/staging/comedi/drivers/ni_daq_700.c: In function ‘dio700_config’:
> drivers/staging/comedi/drivers/ni_daq_700.c:499: error: ‘win_req_t’
> undeclared (first use in this function)

Looks like the PCMCIA win_req_t fixup missed a driver or two.

Dominik?

And if somebody else wants to help out, look at commit cdb138080b78
("pcmcia: do not use win_req_t when calling pcmcia_request_window()")
for guidance about what it is all about. That shows other drivers
being converted.

Anyway, in this case, it looks like the problem is literally that
_unused_ declaration of 'win_req_t req'. Just remove that line. Does
it compile and work then?

                Linus
