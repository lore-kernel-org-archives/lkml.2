Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423019Ab2CPPUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:20:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:12351 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422646Ab2CPPUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:20:17 -0400
Subject: Re: [patch v2] x86, efi: fix pointer math issue in
 handle_ramdisks()
From: Matt Fleming <matt.fleming@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20120305180614.GA26880@elgon.mountain>
References: <20120305180614.GA26880@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Fri, 16 Mar 2012 15:20:04 +0000
Message-ID: <1331911204.4041.13.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 21:06 +0300, Dan Carpenter wrote:
> "filename" is a efi_char16_t string so this check for reaching the end
> of the array doesn't work.  We need to cast the pointer to (u8 *) before
> doing the math.
> 
> This patch changes the "filename" to "filename_16" to avoid confusion in
> the future.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: Rename "filename" to "filename_16"
>     Also changed cast from (char *) to (u8 *) because it's not a C
>     character string.  Ingo suggested (void *) but that's a GCCism
>     I think.

Looks good to me. Is someone going to pick this up?

