Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab2EIFuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:50:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46167 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab2EIFuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:50:15 -0400
Date: Tue, 8 May 2012 22:50:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 03/14 v3] Input: atmel_mxt_ts - refactor
 mxt_read/write_reg to take a length
Message-ID: <20120509055009.GF10514@core.coreip.homeip.net>
References: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
 <1334755319-21365-4-git-send-email-djkurtz@chromium.org>
 <20120424112319.GA9688@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424112319.GA9688@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Tue, Apr 24, 2012 at 01:23:19PM +0200, Henrik Rydberg wrote:
> Hi Daniel,
> 
> > The i2c bus requires 5 bytes to do a 1 byte read (1-byte i2c address + 2
> > byte offset + 1-byte i2c address + 1 byte data), or 4 bytes to do a
> > 1-byte write (1 byte i2c address + 2 byte offset + 1 byte data).
> > 
> > By taking a length with reads and writes, the driver can amortize
> > transaction overhead by performing larger transactions where appropriate.
> > 
> > This patch just sets up the new API.  Later patches refactor reads/writes
> > to take advantage of the larger transactions.
> > 
> > These functions are also now return any errors reported by the i2c layer.
> > 
> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> > ---
> 
> In the cyttsp a dedicate tx buffer is used, which is a bit easier on
> the eyes.

Cyttsp needs a cacheline aligned buffer because it can be wired over
SPI, that is why it has a dedicate buffer.

-- 
Dmitry
