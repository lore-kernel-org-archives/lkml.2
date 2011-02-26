Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab1BZLqY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 06:46:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60846 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab1BZLqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 06:46:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=KMkNOmz4/ysXr1A5l9wlPceZV1PFGUtKPXq7J9DEZrZ8uo6s41T/eJPfCAMGxNQ3rY
         INjsl0uoLLrkNZGDGjOg9NNk5UJgZ0hsMXQE1IoaPXea2ptV/uWBhMcZEW0QPCkhDJwa
         kawTBngtNTcPI9sDhV/LF7yYJ0LgljPdDNe5I=
Message-ID: <4D68E80B.90001@gmail.com>
Date: Sat, 26 Feb 2011 12:46:19 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
CC: preining@logic.at,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        "debora@linux.vnet.ibm.com" <debora@linux.vnet.ibm.com>
Subject: Re: [PATCH] tpm_tis: Re-enable interrupts upon resume
References: <1298404199.25819.15.camel@d941e-10>
In-Reply-To: <1298404199.25819.15.camel@d941e-10>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 08:49 PM, Stefan Berger wrote:
> Below patch applies to the tip of the git tree.
> 
> This patch makes sure that if the TPM TIS interface is run in interrupt
> mode (rather than polling mode) that the interrupts are enabled in the
> TPM's interrupt enable register which may either have been cleared by
> the TPM's TIS loosing its state during device sleep in ACPI S3 (suspend)
> or by the BIOS, which upon resume sends a TPM_Startup() command to the
> TPM, and may run the TPM in polling mode and leave the TIS interrupts
> disabled once it transfers control to the OS again.
> 
> Problem is, I don't currently have a machine running the TPM in
> interrupt mode. I found this through a self-built TPM device model for
> Qemu and SeaBIOS patches, where this does resolve a problem upon resume.
> 
> You may want to check if your TPM runs with interrupts by doing
> 
> cat /proc/interrupts | grep -i tpm

No, this is empty output.

regards,
-- 
js
