Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab2AELWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 06:22:09 -0500
Received: from mga07.intel.com ([143.182.124.22]:57196 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751591Ab2AELWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 06:22:07 -0500
Subject: Re: [PATCH 4/5] x86: efi: add basic error handling
From: Matt Fleming <matt.fleming@intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
In-Reply-To: <1325610682-24811-5-git-send-email-olof@lixom.net>
References: <1325610682-24811-1-git-send-email-olof@lixom.net>
	 <1325610682-24811-5-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Thu, 05 Jan 2012 11:21:59 +0000
Message-ID: <1325762519.3635.22.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-03 at 09:11 -0800, Olof Johansson wrote:
> It's not perfect, but way better than before. Mark efi_enabled as false in
> case of error and at least stop dereferencing pointers that are known to
> be invalid.
> 
> The only significant missing piece is the lack of undoing the
> memblock_reserve of the memory that efi marks as in use. On the other
> hand, it's not a large amount of memory, and leaving it unavailable for
> system use should be the safer choice anyway.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>  arch/x86/platform/efi/efi.c |   89 ++++++++++++++++++++++++++++--------------
>  1 files changed, 59 insertions(+), 30 deletions(-)

Seems straight forward and better than what was there previously. Have
you tested this error handling?

Acked-by: Matt Fleming <matt.fleming@intel.com>

