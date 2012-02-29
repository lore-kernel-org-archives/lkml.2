Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030711Ab2B2KIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:08:31 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42766 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030619Ab2B2KI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:08:29 -0500
Date: Wed, 29 Feb 2012 10:08:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mattias NILSSON <mattias.i.nilsson@stericsson.com>,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: RFC: what do we do with system controllers?
Message-ID: <20120229100810.GH18045@n2100.arm.linux.org.uk>
References: <CACRpkdY1W-RGE0JL4Sx5UcPY-EGieu8vo7H0fp9xyXtegpaaKw@mail.gmail.com> <20120228083833.GB18045@n2100.arm.linux.org.uk> <CACRpkdaTJFL0A3caA4mNjxHTuXLC5u87OZ2yR=1ChiCFQL7c2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaTJFL0A3caA4mNjxHTuXLC5u87OZ2yR=1ChiCFQL7c2A@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 10:59:23AM +0100, Linus Walleij wrote:
> On Tue, Feb 28, 2012 at 9:38 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Tue, Feb 28, 2012 at 06:48:12AM +0100, Linus Walleij wrote:
> >> Mainly addressed to Greg but anyone is welcome to join the
> >> discussion...
> >>
> >> Several ARM platforms have system controllers. In this I
> >> include all custom terminology such as:
> >>
> >> - System Control
> >> - Chip Controller
> >> - Core Module control registers
> >> - Power Reset Control Management Units
> >> - Multimedia Communications Port
> >
> > Why do you include this?  If you include this, you should include things
> > like SSP/SPI ports, I2C and other such buses.
> 
> Mainly because it has these specific MCP controller oddity
> functions:
> 
> mcp_set_telecom_divisor()
> mcp_set_audio_divisor()
> 
> i.e. it has some "strangeness" of system controller type
> (telecom? que?) But it's quite little and no big deal, drop
> it off the list.

MCP = Multimedia Communication Port.  It is designed to work with the
UCB1200 and UCB1300 codec devices, which have two parts to them: a
telecom / pots interface and an audio interface.

The host side needs to be programmed with the appropriate sample rate -
it's the host side which controls the sample rate not the codec.
