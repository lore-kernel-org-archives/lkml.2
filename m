Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab1BCRZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:25:43 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:49109 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab1BCRZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:25:41 -0500
Date: Thu, 3 Feb 2011 18:25:39 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@amd64.org>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EDAC-AMD64] Display correct RAM sizes in ganged mode on F10 CPUs
Message-ID: <20110203172539.GA1581@gentoo.trippels.de>
References: <20110129211531.GA1874@gentoo.trippels.de>
 <20110201185114.GD8418@aftab>
 <20110201192752.GA1589@gentoo.trippels.de>
 <20110203151721.GD24755@aftab>
 <20110203155951.GA1594@gentoo.trippels.de>
 <20110203163600.GA26261@aftab>
 <20110203164203.GB1594@gentoo.trippels.de>
 <20110203170932.GB26261@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110203170932.GB26261@aftab>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.02.03 at 18:09 +0100, Borislav Petkov wrote:
> On Thu, Feb 03, 2011 at 11:42:03AM -0500, Markus Trippelsdorf wrote:
> > > Of course it doesn't, doh!, we need the DRAM chip selects from the
> > > second DCT too. Can you please run this little script as root so that I
> > > can verify that BIOS is actually programming sensible values in those in
> > > ganged mode? (Yeah, leave your DCT setting to ganged in BIOS).
> > > 
> > > --
> > > #!/bin/bash
> > > 
> > > i=0x140
> > > 
> > > while (( $i <= 0x15c )); do
> > >         reg=$(printf "0x%x" $i)
> > >         setpci -s 18.2 $reg.l
> > >         i=$(($i+4))
> > > done
> > 
> > 00000000
> > 00000000
> > 00000000
> > 00000000
> > 00000000
> > 00000000
> > 00000000
> > 00000000
> 
> Ok, can you please try the following one,

Looks good, many thanks Boris.

EDAC amd64: F10h detected (node 0).
EDAC MC: DCT0 chip selects:
EDAC amd64: MC: 0:  1024MB 1:  1024MB
EDAC amd64: MC: 2:  1024MB 3:  1024MB
EDAC amd64: MC: 4:     0MB 5:     0MB
EDAC amd64: MC: 6:     0MB 7:     0MB
EDAC MC: DCT1 chip selects:
EDAC amd64: MC: 0:  1024MB 1:  1024MB
EDAC amd64: MC: 2:  1024MB 3:  1024MB
EDAC amd64: MC: 4:     0MB 5:     0MB
EDAC amd64: MC: 6:     0MB 7:     0MB

BTW another thing, while I have your attention:

cat /sys/devices/system/edac/mc/mc0/csrow0/edac_mode
prints "S4ECD4ED" aka Chipkill on my system.
But I'm using a revision C Phenom that only supports a x4 symbol size,
while the Kingston ECC DIMMs have a width of x8. So according to
table 77 (page 174) of the "BIOS and Kernel Developer’s Guide" the
system is actually running in SECDED mode and does not provide Chipkill.

-- 
Markus
