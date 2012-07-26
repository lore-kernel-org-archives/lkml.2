Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab2GZWEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 18:04:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43054 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753045Ab2GZWEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 18:04:36 -0400
Message-ID: <5011BD8C.4010301@zytor.com>
Date: Thu, 26 Jul 2012 14:58:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Kent Yoder <key@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        m.selhorst@sirrix.com, safford@us.ibm.com,
        Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2/2] hw_random: add support for the TPM chip as a hardware
 RNG source
References: <1339094567.21398.2.camel@key-ThinkPad-W510> <1339094862.21398.6.camel@key-ThinkPad-W510>
In-Reply-To: <1339094862.21398.6.camel@key-ThinkPad-W510>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 11:47 AM, Kent Yoder wrote:
> This driver will make use of any available TPM chip on the system as a
> hwrng source.
>
> Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
> ---
>   drivers/char/hw_random/Kconfig   |   13 +++++++++
>   drivers/char/hw_random/Makefile  |    1 +
>   drivers/char/hw_random/tpm-rng.c |   55 ++++++++++++++++++++++++++++++++++++++
>   3 files changed, 69 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/char/hw_random/tpm-rng.c
>

So I just noticed this patch being pushed.

/dev/hw_random is used by rngd, which already has support for the TPM 
directly.  However, the TPM support in rngd conflict with tcsd (from 
TrouSerS).

Does this driver solve the coexistence problem?  If so, this is a Very 
Good Thing and should be accepted (and the TPM support in rngd 
deprecated/removed.)

If it does *not* solve the coexistence problem, then it just prevents a 
user space solution and the patch really should be rejected.

It would be great to get that clarified as soon as possible.

Thanks,

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

