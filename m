Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab0EQPAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:00:10 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:25471 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab0EQPAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:00:08 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zz1432P98dN1b0bMzz1202hzz5eeePz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L2KKBR-03-60C-02
X-M-MSG: 
Date: Mon, 17 May 2010 16:59:43 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Yuhong Bao <yuhongbao_386@hotmail.com>
CC: venkatesh.pallipadi@intel.com, markh@compro.net, dmarkh@cfl.rr.com,
       andi@firstfloor.org, Linus Torvalds <torvalds@linux-foundation.org>,
       alain@knaff.lu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Disable HPET MSI on ATI SB700/SB800
Message-ID: <20100517145943.GV5888@alberich.amd.com>
References: <87bphpd4rt.fsf@basil.nowhere.org>
 <4B32565E.6000501@compro.net>
 <20091223191806.GA3336@linux-os.sc.intel.com>
 <4B3270FE.5090607@compro.net>
 <1261600243.16916.56.camel@localhost.localdomain>
 <4B476E8D.1030308@compro.net>
 <20100121190952.GA32523@linux-os.sc.intel.com>
 <SNT125-W12BC46C506A5BB777A06B5C3610@phx.gbl>
 <20100125171059.GB5041@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20100125171059.GB5041@alberich.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 06:10:59PM +0100, Andreas Herrmann wrote:
> On Fri, Jan 22, 2010 at 11:21:06PM -0800, Yuhong Bao wrote:
> > 
> > > HPET MSI on platforms with ATI SB700/SB800 as they seem to have some
> > > side-effects on floppy DMA. Do not use HPET MSI on such platforms.
> 
> Argh, will see what information I can find about this problem ...

FYI. I've tried to trigger the publication of errata information for that
chipset. Finally this has happened.

The discussed problem is indeed due to an erratum. See erratum #27 in
http://support.amd.com/us/Embedded_TechDocs/46837.pdf

The suggested workaround for this is to disable HPET MSI if LPC
devices are used. I doubt that there is a convenient way for Linux to
find out whether LPC devices are used. Thus I think the only solution
to safely avoid the problem is the currently implemented quirk to
disable HPET MSI on this chipset.


Regards,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Einsteinring 24, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


