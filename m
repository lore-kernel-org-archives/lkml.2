Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab0INMOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 08:14:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63925 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab0INMOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 08:14:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=r4rEmAKr4m12kr3z6r4U3xOJOrAoP8LmjCLTtonQHQGTjF21cRsEi/nKDiEX2BTJIa
         5JVBnlai/yDcuxoXC+dKSrXSuru1fUi4xo8Tel/nfu01XVdo0EicYto1SBcy2xgrZTsC
         O6BgBL0gBFbwhWm4YP4qdTgddZiUMOsg2nrwc=
Message-ID: <4C8F672E.6050504@suse.cz>
Date: Tue, 14 Sep 2010 14:14:38 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100824 SUSE/3.1.3 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: James.Bottomley@suse.de, iscsi-driver@qlogic.com,
        linux-scsi@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Ravi Anand <ravi.anand@qlogic.com>,
        Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [PATCH] SCSI: fix qla4xxx build on PPC
References: <1284466375-9501-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1284466375-9501-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2010 02:12 PM, Jiri Slaby wrote:
> We use read/write[bslq] but do not include linux/io.h. This causes
> build failures on PPC. Include that file.

Just in case you want to include the failure:
drivers/scsi/qla4xxx/ql4_nx.c: In function 'qla4_8xxx_pci_mem_read_direct':
drivers/scsi/qla4xxx/ql4_nx.c:716:3: error: implicit declaration of
function 'readq'
drivers/scsi/qla4xxx/ql4_nx.c: In function 'qla4_8xxx_pci_mem_write_direct':
drivers/scsi/qla4xxx/ql4_nx.c:787:3: error: implicit declaration of
function 'writeq'

> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Ravi Anand <ravi.anand@qlogic.com>
> Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> ---
>  drivers/scsi/qla4xxx/ql4_nx.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
> index 5d4a382..449256f 100644
> --- a/drivers/scsi/qla4xxx/ql4_nx.c
> +++ b/drivers/scsi/qla4xxx/ql4_nx.c
> @@ -5,6 +5,7 @@
>   * See LICENSE.qla4xxx for copyright and licensing details.
>   */
>  #include <linux/delay.h>
> +#include <linux/io.h>
>  #include <linux/pci.h>
>  #include "ql4_def.h"
>  #include "ql4_glbl.h"

thanks,
-- 
js
suse labs
