Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab2KLMPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 07:15:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab2KLMPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 07:15:12 -0500
Date: Mon, 12 Nov 2012 13:15:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH] HID: microsoft, do not use compound literal
In-Reply-To: <CAMuHMdUEW9K6cfpcUNphte_VzBCL_Oa_od3892DQ3QbX5xMMnA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1211121314270.27271@pobox.suse.cz>
References: <1352711769-28911-1-git-send-email-jslaby@suse.cz> <CAMuHMdUEW9K6cfpcUNphte_VzBCL_Oa_od3892DQ3QbX5xMMnA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012, Geert Uytterhoeven wrote:

> On Mon, Nov 12, 2012 at 10:16 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> > In patch "HID: microsoft: fix invalid rdesc for 3k kbd" I fixed
> > support for MS 3k keyboards. However the added check using memcmp and
> > a compound statement breaks build on architectures where memcmp is a
> > macro with parameters. The error looks there like (m68k-linux-gnu-gcc
> > 4.1.2):
> > hid-microsoft.c:51:18: error: macro "memcmp" passed 6 arguments, but takes just 3
> > hid-microsoft.c: In function ‘ms_report_fixup’:
> > drivers/hid/hid-microsoft.c:50: error: ‘memcmp’ undeclared (first use in this function)
> > hid-microsoft.c:50: error: (Each undeclared identifier is reported only once
> > /hid-microsoft.c:50: error: for each function it appears in.)
> 
> The above 3 lines were actually from a build with a different config
> --- which I didn't
> notice at that time --- where <linux/string.h> was not indirectly included.

Still the patch needs string.h include addition, otherwise you still are 
able to come up with m68k config that doesn't build, do I understand it 
correctly?

Thanks,

-- 
Jiri Kosina
SUSE Labs
