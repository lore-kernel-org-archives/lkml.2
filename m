Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375Ab0DJHBx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 03:01:53 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:42628 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab0DJHBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 03:01:51 -0400
Date: Sat, 10 Apr 2010 08:34:32 +0200
From: Harald Welte <laforge@gnumonks.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 08/16] viafb: Do not probe for LVDS/TMDS on OLPC XO-1.5
Message-ID: <20100410063431.GR14576@prithivi.gnumonks.org>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
 <1270746946-12467-9-git-send-email-corbet@lwn.net>
 <4BBF9EE7.50707@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBF9EE7.50707@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

On Fri, Apr 09, 2010 at 11:40:55PM +0200, Florian Tobias Schandinat wrote:

> >The i2c transactions involved in detecting LVDS (9 seconds) and TMDS
> >(16 seconds) add an extra 25 seconds to viafb load time on the XO-1.5.
> 
> I don't like the idea of OLPC specific code. Isn't there any way to
> speed this up in general?

I'm quite sure it can be sped up at least a bit... however:

> There is not yet even an option for OLPC_XO_1_5 (in contrast to
> CONFIG_OLPC) in mainline. Is such a thing planned?
> I can't really see anything that would speak for accepting this
> patch now in current mainline, sorry.

I think there is little choice in this matter.  It is a _very_ uncommon
hardware design decision to attach anything but the DDC to one of the
I2C ports of the graphics chip, and the assumption that there is only
DDC connected is made in VIA's BIOS (not used in OLPC), the linux
framebuffer driver, as well as VIA's own Xorg driver and I believe as
well in OpenChrome, too :(

OLPC has told me that the particular chip that is attached to I2C is
also very timing sensitive and not 100% I2C compliant, so I think it is
the safe choice to not try to do DDC on that port for the OLPC 1.5.

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
