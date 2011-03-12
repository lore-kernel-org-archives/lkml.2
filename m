Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab1CLI3L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 03:29:11 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44234 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab1CLI3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 03:29:09 -0500
Date: Sat, 12 Mar 2011 01:29:06 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2-RESEND] mcp23s08: support mcp23s17 variant
Message-ID: <20110312082906.GC9347@angua.secretlab.ca>
References: <1299689790-11426-1-git-send-email-jacmet@sunsite.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299689790-11426-1-git-send-email-jacmet@sunsite.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 05:56:30PM +0100, Peter Korsgaard wrote:
> mpc23s17 is very similar to the mcp23s08, except that registers are 16bit
> wide, so extend the interface to work with both variants.
> 
> The s17 variant also has an additional address pin, so adjust platform
> data structure to support up to 8 devices per SPI chipselect.
> 
> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>

Merged, thanks.

g.

> ---
> Resend without any changes since v2 on Feb 15th.
> 
> Changes since v1:
> - Add mcp23s08_ops callbacks for 8 and 16 bit instead of handling both
>   in the same accessor function as requested by Grant.
> - Don't use a temporary buffer for 8bit version of read_regs -
>   Stack addresses are not DMA safe.
> 
>  drivers/gpio/Kconfig         |    6 +-
>  drivers/gpio/mcp23s08.c      |  191 +++++++++++++++++++++++++++++++-----------
>  include/linux/spi/mcp23s08.h |   15 ++--
>  3 files changed, 155 insertions(+), 57 deletions(-)
> 
