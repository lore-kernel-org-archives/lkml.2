Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab0IYCIC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 22:08:02 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55554 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754499Ab0IYCIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 22:08:00 -0400
X-Sasl-enc: QCf2nadV/vTvrw05adsJHcyJKAoddmmXCfGjcXhFvUeN 1285380479
Date: Fri, 24 Sep 2010 23:07:53 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Vernon Mauery <vernux@us.ibm.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode driver -v5
Message-ID: <20100925020753.GA31997@khazad-dum.debian.net>
References: <20100921224610.GO13162@lucy>
 <20100923221253.GA4960@lucy>
 <20100923225346.GB4960@lucy>
 <201009241512.39311.arnd@arndb.de>
 <AANLkTimMWAk22gSn2cXA25VNJ1o3OX-mazJfFFd_+MH2@mail.gmail.com>
 <20100924095625.5beedf5a.rdunlap@xenotime.net>
 <20100924210642.GE10777@lucy>
 <20100924142006.a79833ab.rdunlap@xenotime.net>
 <20100924213009.GF10777@lucy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100924213009.GF10777@lucy>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010, Vernon Mauery wrote:
> >>+/* The RTL table as presented by the EBDA: */
> >>+struct ibm_rtl_table {
> >>+	char signature[5];
> >
> >Question:  are all 5 bytes of signature[] used?  It looks like the search code
> >only checks for 32 bits of signature (and the last byte can be garbage?).
> 
> Technically, the 5 bytes are supposed to be "_RTL_", but it is a lot
> easier to just check _RTL since we can do that with a single read.
> I suppose I could do a 64-bit read and mask the bits that matter.

Well, as long as you guys write in stone there at IBM that you will
remember to not have a possible future _RTL2_ that would clash horribly
with an non-up-to-date version of the driver that has no clue about
RTL2 and still would match the signature because it only looks at the first
32 bits...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
