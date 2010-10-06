Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab0JFHnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 03:43:47 -0400
Received: from mx1.melware.net ([78.47.171.162]:51977 "EHLO mx1.melware.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758666Ab0JFHno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 03:43:44 -0400
X-Greylist: delayed 1078 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Oct 2010 03:43:43 EDT
Date: Wed, 6 Oct 2010 09:25:44 +0200 (CEST)
From: Armin Schindler <armin@melware.de>
To: Dan Carpenter <error27@gmail.com>
cc: Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] eicon: make buffer larger
In-Reply-To: <20101004192459.GE5692@bicker>
Message-ID: <alpine.DEB.2.00.1010060923120.29107@justus.melware.de>
References: <20101004192459.GE5692@bicker>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Organization: Cytronics & Melware
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Oct 2010, Dan Carpenter wrote:
> In diva_mnt_add_xdi_adapter() we do this:
>  strcpy (clients[id].drvName,     tmp);
>  strcpy (clients[id].Dbg.drvName, tmp);
>
> The "clients[id].drvName" is a 128 character buffer and
> "clients[id].Dbg.drvName" was originally a 16 character buffer but I've
> changed it to 128 as well.  We don't actually use 128 characters but we
> do use more than 16.

I don't see any reason for that change. The driver names here do not use 
more than 16 characters and when filled, the length is checked anyway.
Please avoid changing the size of that structure.

Armin

> I've also changed the size of "tmp" to 128 characters instead of 256.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
>
> diff --git a/drivers/isdn/hardware/eicon/debuglib.h b/drivers/isdn/hardware/eicon/debuglib.h
> index 8ea5877..02eed6b 100644
> --- a/drivers/isdn/hardware/eicon/debuglib.h
> +++ b/drivers/isdn/hardware/eicon/debuglib.h
> @@ -249,7 +249,7 @@ typedef struct _DbgHandle_
>  }     regTime ;  /* timestamp for registration       */
>  void               *pIrp ;   /* ptr to pending i/o request       */
>  unsigned long       dbgMask ;  /* current debug mask               */
> - char                drvName[16] ; /* ASCII name of registered driver  */
> + char                drvName[128] ; /* ASCII name of registered driver  */
>  char                drvTag[64] ; /* revision string     */
>  DbgEnd              dbg_end ;  /* function for debug closing       */
>  DbgLog              dbg_prt ;  /* function for debug appending     */
> diff --git a/drivers/isdn/hardware/eicon/debug.c b/drivers/isdn/hardware/eicon/debug.c
> index 33ce89e..3626401 100644
> --- a/drivers/isdn/hardware/eicon/debug.c
> +++ b/drivers/isdn/hardware/eicon/debug.c
> @@ -862,7 +862,7 @@ void diva_mnt_add_xdi_adapter (const DESCRIPTOR* d) {
>   diva_os_spin_lock_magic_t old_irql, old_irql1;
>   dword sec, usec, logical, serial, org_mask;
>   int id, best_id = 0, free_id = -1;
> -  char tmp[256];
> +  char tmp[128];
>   diva_dbg_entry_head_t* pmsg = NULL;
>   int len;
>   word size;
>
