Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab1ANQHO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 11:07:14 -0500
Received: from ausxippc101.us.dell.com ([143.166.85.207]:1943 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab1ANQHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 11:07:10 -0500
X-Loopcount0: from 10.175.216.250
From: <Narendra_K@Dell.com>
To: <sedat.dilek@gmail.com>
CC: <jbarnes@virtuousgeek.org>, <lenb@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        <sfr@canb.auug.org.au>, <Matt_Domsch@Dell.com>,
        <Charles_Rose@Dell.com>, <Surya_Prabhakar@Dell.com>
Date: Fri, 14 Jan 2011 21:36:06 +0530
Subject: RE: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Thread-Topic: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Thread-Index: Acuz/98RjuOH8I1DTZqGNSLdkkO/vwAA5EdQ
Message-ID: <E31FB011129F30488D5861F3839049151D10FD013E@BLRX7MCDC201.AMER.DELL.COM>
References: <20110112203414.GA5657@fedora14-r610.oslab.blr.amer.dell.com>
	<20110112160229.7b8d82c1@jbarnes-desktop>
	<alpine.LFD.2.02.1101122217370.19754@x980>
	<20110113075556.789ac3c3@jbarnes-vaio.home>
	<20110113162755.GA5872@fedora14-r610.oslab.blr.amer.dell.com>
	<20110114154458.GA18289@fedora14-r610.oslab.blr.amer.dell.com>
 <AANLkTimba7FFowzVV6KxwvXGis4d0FmxcxZA6NL0saNM@mail.gmail.com>
In-Reply-To: <AANLkTimba7FFowzVV6KxwvXGis4d0FmxcxZA6NL0saNM@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0EG7NpQ005779

> Subject: Re: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
> allmodconfig
> 
> On Fri, Jan 14, 2011 at 4:22 PM,  <Narendra_K@dell.com> wrote:
> > On Thu, Jan 13, 2011 at 09:33:56PM +0530, K, Narendra wrote:
> >> On Thu, Jan 13, 2011 at 09:25:56PM +0530, Jesse Barnes wrote:
> >> > On Wed, 12 Jan 2011 22:23:55 -0500 (EST)
> >> > Len Brown <lenb@kernel.org> wrote:
> >> > > > So there's no other ACPI code that depends on this function?
> Â I'd hate
> >> > > > to make PCI depend on NLS, so assuming ACPI doesn't need it
> (in which
> >> > > > case the select or depend should be there), I guess it should
> be pulled
> >> > > > into a common file that will always be included.
> >> > >
> >> > > No, nothing in the ACPI code uses utf16s_to_utf8s.
> >> > >
> >> > > I don't know anything about NLS, but it appears to be
> >> > > something that file systems (befs, cifs, fat, hfs, isofs, jfs,
> etc)
> >> > > use to to support native languages.
> >> > >
> >> > > BTW. I don't understand why pci-label.o appears twice above.
> >> > > It used to be just the 2nd one, that depends on CONFIG_DMI.
> >> >
> >> > Ok, I'll drop this patch for now then since I haven't seen a fix
> yet
> >> > and need to get Linus the rest of the changes.
> >>
> >> Jesse,
> >>
> >> I just compile tested a fix on the following lines without any
> failure.
> >> If it is acceptable, i will send a patch in half an hour. It builds
> >>
> >
> > Hello,
> >
> > This patch addresses the build failure described in this thread by
> > compiling fs/nls/nls_base.c always into vmlinux, thus making the base
> > nls functions available always.
> >
> > Please consider this patch for inclusion if there are no concerns
> with
> > this approach.
> >
> 
> So NLS is built always?
> You thought of embedded devices like router platforms which want to
> reduce their kernel (size) by not building NLS?

Only nls_base.c is built always and not the other files under fs/nls/ dir. I considered moving 'utf16s_to_utf8s' to a new file nls_common.c, but 'utf16s_to_utf8s' requires 'utf32_to_utf8' also. I suppose nls_base.c has only the minimum required functions and moving out two functions out of it might not be the right approach. Sorry if I am missing something here.

Please let me know if this can be addressed in an alternative way.

With regards,
Narendra K



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
