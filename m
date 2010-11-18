Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760533Ab0KRVHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:07:39 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35796 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759523Ab0KRVHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:07:38 -0500
Date: Thu, 18 Nov 2010 21:06:42 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-kernel@vger.kernel.org, Eric Youngdale <eric@andante.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Anderson <andmike@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][resend][SCSI] Reduce number of sequential pointer
	derefs in scsi_error.c and reduce size as well
Message-ID: <20101118210642.GA24236@flint.arm.linux.org.uk>
References: <alpine.LNX.2.00.1011181957500.3651@swampdragon.chaosbits.net> <AANLkTi=McRJSHp8==o+=coK0_pK5s9dwUgLmrkohSmTX@mail.gmail.com> <alpine.LNX.2.00.1011182140510.8526@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1011182140510.8526@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 09:49:29PM +0100, Jesper Juhl wrote:
> @@ -617,10 +623,10 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
>  
>  static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
>  {
> -	if (!scmd->device->host->hostt->eh_abort_handler)
> -		return FAILED;
> -
> -	return scmd->device->host->hostt->eh_abort_handler(scmd);
> +    struct scsi_host_template *hostt = scmd->device->host->hostt;
> +    if (!hostt->eh_abort_handler)
> +        return FAILED;
> +    return hostt->eh_abort_handler(scmd);

Not that I have much to do with SCSI anymore... I spotted the above.
Is there any particular reason for using spaces to indent here rather
than our usual tabs?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
