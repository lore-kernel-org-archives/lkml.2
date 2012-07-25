Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab2GYIQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 04:16:52 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:60587 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712Ab2GYIQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 04:16:50 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFJjy0PE3ns
X-RZG-CLASS-ID: mo00
Date: Wed, 25 Jul 2012 10:16:47 +0200
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com
Subject: Re: [PATCH 1/1] Drivers: hv: Cleanup the guest ID computation
Message-ID: <20120725081647.GB22443@aepfle.de>
References: <1343171518-15189-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1343171518-15189-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, K. Y. Srinivasan wrote:


> +/*
> + * The guest OS needs to register the guest ID with the hypervisor.
> + * The guest ID is a 64 bit entity and the structure of this ID is
> + * specified in the Hyper-V specification:
> + *
> + * http://msdn.microsoft.com/en-us/library/windows/
> + * hardware/ff542653%28v=vs.85%29.aspx
> + *
> + * While the current guideline does not specify how Linux guest ID(s)
> + * need to be generated, our plan is to publish the guidelines for
> + * Linux and other guest operating systems that currently are hosted
> + * on Hyper-V. The implementation here conforms to this yet
> + * unpublished guidelines.
> + *
> + *
> + * Bit(s)
> + * 63 - Indicates if the OS is Open Source or not; 1 is Open Source
> + * 62:56 - Os Type; Linux is 0x100
> + * 55:48 - Distro specific identification
> + * 47:16 - Linux kernel version number
> + * 15:0  - Distro specific identification
> + *
> + *
> + */
> +
> +#define HV_LINUX_VENDOR_ID		0x8100

I suggest to drop bit 63, why would the hypervisor care about that
weird detail?

Olaf
