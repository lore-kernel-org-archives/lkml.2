Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab1F1Alf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 20:41:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43213 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab1F1Ak6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 20:40:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f96W5RMnLBZPEeOENA3b9Gc8kRfjNnDIQVDsxAKrFj4rBu82kk1tzfCAMxhU9khTsT
         sJDXJ8hVUOQrp4hDWn47HbqeZPJ17AYHPNW99b53SMsy1/FoozlKvUFecF480cw2XHbQ
         GrdyLFWWif8Uro56OonyptVy+/AusrYQgNX50=
MIME-Version: 1.0
In-Reply-To: <20110627111259.GA13620@linux-mips.org>
References: <20110627111259.GA13620@linux-mips.org>
Date: Tue, 28 Jun 2011 09:40:56 +0900
Message-ID: <BANLkTikDxsOJKpiJs0NpMXbjVOFMHL7RZw@mail.gmail.com>
Subject: Re: [PATCH v2] NET: AX88796: Tighten up Kconfig dependencies
From: Magnus Damm <magnus.damm@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Paul Mundt <lethal@linux-sh.org>, Jeff Garzik <jeff@garzik.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, netdev@vger.kernel.org,
        linux-mips@linux-mips.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf,

On Mon, Jun 27, 2011 at 8:13 PM, Ralf Baechle <ralf@linux-mips.org> wrote:
> In def47c5095d53814512bb0c62ec02dfdec769db1 [[netdrvr] Fix dependencies for
> ax88796 ne2k clone driver] the AX88796 driver got restricted to just be
> build for ARM and MIPS on the sole merrit that it was written for some ARM
> sytems and the driver had the misfortune to just build on MIPS, so MIPS was
> throw into the dependency for a good measure.  Later
> 8687991a734a67f1638782c968f46fff0f94bb1f [ax88796: add superh to kconfig
> dependencies] added SH but only one in-tree SH system actually has an
> AX88796.
>
> Tighten up dependencies by using an auxilliary config sysmbol
> HAS_NET_AX88796 which is selected only by the platforms that actually
> have or may have an AX88796.  This also means the driver won't be built
> anymore for any MIPS platform.
>
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> ---
> v2: fixed Sergei's complaints about the log message

I'm the one who added the SuperH bits a few years ago. Judging by the
text above it seems like you prefer not to build this driver for MIPS.
Which is totally fine with me.

As for SH and SH-Mobile ARM, unless explicitly requested we usually
don't restrict our platform drivers. Allowing them to build on any
system helps to catch compile errors. It also makes it possible to add
board support by simply adding platform data to the board file and
then updating the kconfig. Keeping the amount of code at the bare
minimum makes back porting rather easy too.

I'm not sure if the ax88796 driver does something non-standard to
require special symbols, but usually platform drivers are rather clean
and can be compiled for any architecture or platform. At least in
theory. =)

Cheers,

/ magnus
