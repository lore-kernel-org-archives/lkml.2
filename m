Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab1DMXgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 19:36:49 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59504 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005Ab1DMXgs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 19:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=avvYIP/4wEGTBJnPE2kfqG+h6lM1YCinNy8TUCKOPuJZFyEmHw5dlbemntR/Wp5jaD
         bs3KpJIMbGbzEsiZ6LRSZWm9j37EAYwRisUhL466RbAuU4YEQC6yN3kOstYIDBNpGW1O
         IoL19sV1Se3Kt13TJCpL3G9Y0j1LebE+V6GmU=
MIME-Version: 1.0
In-Reply-To: <BANLkTinLn4Ug=gX4coHJbSzrkxdSMjgGeg@mail.gmail.com>
References: <1302634375-2378-1-git-send-email-zajec5@gmail.com>
 <20110413163113.GA24015@kroah.com> <BANLkTin-4HrJzNrLOxRy_-a98S3ZF4aSQw@mail.gmail.com>
 <1302726703.8015.1.camel@dev.znau.edu.ua> <BANLkTimwZOJ0a5kVfaUzEcsMc39H999u0A@mail.gmail.com>
 <1302727516.8015.9.camel@dev.znau.edu.ua> <BANLkTi=wzzzeF-PmqLt9o8arW7nRaFRRJw@mail.gmail.com>
 <1302729243.8479.1.camel@dev.znau.edu.ua> <BANLkTinLn4Ug=gX4coHJbSzrkxdSMjgGeg@mail.gmail.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Thu, 14 Apr 2011 01:36:27 +0200
Message-ID: <BANLkTimcy16ggC0C66V-fbuaJwg4Sna4Qw@mail.gmail.com>
Subject: Re: [RFC][PATCH V4] axi: add AXI bus driver
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: George Kashperko <george@znau.edu.ua>, Greg KH <greg@kroah.com>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        b43-dev@lists.infradead.org,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Arend van Spriel <arend@broadcom.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 April 2011 23:19, Rafał Miłecki <zajec5@gmail.com> wrote:
> 2011/4/13 George Kashperko <george@znau.edu.ua>:
>>> I had no idea what you were referring to. We do not dig into PCIe
>>> functions yet, so I believe for now we need this "if".
>> You are already deep inside. Your host code drives pci function.
>
> But I don't use multiple PCIe functions, do not focus on that at all.

I think what George meant is the following (please correct me if I
understood you wrong) and has nothing to do with PCIe functions:
<http://lxr.free-electrons.com/source/drivers/staging/brcm80211/util/aiutils.c#L522>

The chipcommon and PCIe core registers seem to be always available on
PCIe and no core switching is necessary for them. So as long as you
only access the core registers of chipcommon, PCIe + one other core,
you never need to do any switching (except for the initial switch to
the other core)

But If you need to access the agent registers you do have to do adapt
the PCIe windows.

(This seems to apply also to PCI cards with a PCI core revision >= 13,
but this is probably only relevant for SSB - unless Arend says there
are/were also PCI cards with AMBA AXI backplanes ;-).


Jonas
