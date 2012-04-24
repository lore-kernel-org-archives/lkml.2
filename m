Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab2DXLTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 07:19:42 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:40159 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2DXLTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 07:19:40 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai6ZACCLlk9V5qnhPGdsb2JhbABEiiqmKgSBEBkBAQEBHhkNJ4IJAQEEATocEwEPBQsIAw44FCUKGhOICgm6exOLDYVLYwSVeYYEg1WJUQ
X-IronPort-AV: E=Sophos;i="4.75,473,1330902000"; 
   d="scan'208";a="97506757"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 24 Apr 2012 13:23:19 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 03/14 v3] Input: atmel_mxt_ts - refactor
 mxt_read/write_reg to take a length
Message-ID: <20120424112319.GA9688@polaris.bitmath.org>
References: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
 <1334755319-21365-4-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334755319-21365-4-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> The i2c bus requires 5 bytes to do a 1 byte read (1-byte i2c address + 2
> byte offset + 1-byte i2c address + 1 byte data), or 4 bytes to do a
> 1-byte write (1 byte i2c address + 2 byte offset + 1 byte data).
> 
> By taking a length with reads and writes, the driver can amortize
> transaction overhead by performing larger transactions where appropriate.
> 
> This patch just sets up the new API.  Later patches refactor reads/writes
> to take advantage of the larger transactions.
> 
> These functions are also now return any errors reported by the i2c layer.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---

In the cyttsp a dedicate tx buffer is used, which is a bit easier on
the eyes. OTOH, the write operation seems infrequent enough to not
matter much, so

    Acked-by: Henrik Rydberg <rydberg@euromail.se>

Thanks for your patience,
Henrik
