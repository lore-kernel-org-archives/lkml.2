Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab2FHTNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 15:13:23 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:52185 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab2FHTNT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 15:13:19 -0400
Message-ID: <1339182786.2297.10.camel@localhost.localdomain>
Subject: Re: [PATCH 0/2] Move the tpm_get_random api and add an hwrng driver
 for it
From: David Safford <safford@linux.vnet.ibm.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        m.selhorst@sirrix.com, David Safford <safford@us.ibm.com>
Date: Fri, 08 Jun 2012 15:13:06 -0400
In-Reply-To: <1339094567.21398.2.camel@key-ThinkPad-W510>
References: <1339094567.21398.2.camel@key-ThinkPad-W510>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.2 (3.4.2-1.fc17) 
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060819-7408-0000-0000-000005B295E6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 13:42 -0500, Kent Yoder wrote:
> These patches move the tpm_get_random API out of the trusted keys code
> and into the tpm device driver itself.  Then a hwrng driver is added that
> makes use of the API to provide a H/W RNG source.

Very nice! checkpatch complained a bit on patch 1, but otherwise,
Acked-by: David Safford <safford@linux.vnet.ibm.com>

>   These are based off the latest upstream kernel.
> 
> Thanks,
> Kent
> 
> Kent Yoder (2):
>   tpm: Move tpm_get_random api into the TPM device driver
>   hw_random: add support for the TPM chip as a hardware RNG source
> 
>  drivers/char/hw_random/Kconfig   |   13 +++++++++
>  drivers/char/hw_random/Makefile  |    1 +
>  drivers/char/hw_random/tpm-rng.c |   55 ++++++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm.c           |   53 ++++++++++++++++++++++++++++++++----
>  drivers/char/tpm/tpm.h           |   23 ++++++++++++++++
>  include/linux/tpm.h              |    4 +++
>  security/keys/trusted.c          |   47 +++++++-------------------------
>  7 files changed, 153 insertions(+), 43 deletions(-)
>  create mode 100644 drivers/char/hw_random/tpm-rng.c
> 

