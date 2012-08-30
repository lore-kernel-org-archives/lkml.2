Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab2H3KM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 06:12:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48243 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab2H3KM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 06:12:27 -0400
Date: Thu, 30 Aug 2012 12:12:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Adko Branil <adkobranil@yahoo.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: HDD problem, software bug, bios bug, or hardware ?
Message-ID: <20120830101225.GE24680@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Adko Branil <adkobranil@yahoo.com>,
	"linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <1345901771.8871.YahooMailNeo@web124706.mail.ne1.yahoo.com>
 <20120826130152.GA20021@liondog.tnic>
 <1346086872.65665.YahooMailNeo@web124704.mail.ne1.yahoo.com>
 <20120827215952.GA18719@liondog.tnic>
 <1346261503.91611.YahooMailNeo@web124703.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1346261503.91611.YahooMailNeo@web124703.mail.ne1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 10:31:43AM -0700, Adko Branil wrote:
> And one more thing i forgot - during kernel compilation i noticed this:
> 
> WARNING: modpost: Found 1 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> 
> 
> 
> And when i compiled with "make CONFIG_DEBUG_SECTION_MISMATCH=y", somewhere at the end was:
> 
> 
> WARNING: drivers/scsi/fcoe/libfcoe.o(.init.text+0x1f): Section mismatch in reference from the function libfcoe_init() to the function .exit.text:fcoe_transport_exit()
> The function __init libfcoe_init() references
> a function __exit fcoe_transport_exit().
> This is often seen when error handling in the init function
> uses functionality in the exit path.
> The fix is often to remove the __exit annotation of
> fcoe_transport_exit() so it may be used outside an exit section.
> 
> 
> 
> It should not be related with the crash during "make modules_install", as the default slackware kernel 3.2.27 also crashes during it, but it may be important for any other things, i don't know.

Nope, not important and is probably already fixed. If you don't get it
with 3.5.2, then it has been fixed.

-- 
Regards/Gruss,
    Boris.
