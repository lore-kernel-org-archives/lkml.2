Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab1DEQEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:04:33 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43405 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab1DEQEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:04:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:organization:message-id:in-reply-to
         :user-agent;
        b=QzrOxJ7VIIZB5askqLYbRxmMhjeA2ebyUvgKund2cyTAuoZOMeW3SIcHV3ssiXlzIS
         mQtVWoESFS83ilWpJN3Zp9M2lw5dRVTpGls096CKGSs4FmdqcKM1SvaoyFelhKjMx8uf
         Xe9bdSG/fqjouAxJcRTo502ViLNM7t6DLzoCQ=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: gregkh@suse.de, "Roger Quadros" <roger.quadros@nokia.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] usb: gadget: f_mass_storage: If 'ro'/'cdrom'
 specified, open file as read-only
References: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com>
 <1302017802-16614-3-git-send-email-roger.quadros@nokia.com>
Date: Tue, 05 Apr 2011 18:04:28 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Organization: Google
Message-ID: <op.vtg2xqrt3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1302017802-16614-3-git-send-email-roger.quadros@nokia.com>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Apr 2011 17:36:39 +0200, Roger Quadros  
<roger.quadros@nokia.com> wrote:
> If we don't need Write access then attempt to open backing file in Read  
> Only mode instead of bailing out too soon.
>
> Signed-off-by: Roger Quadros <roger.quadros@nokia.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> --- a/drivers/usb/gadget/f_mass_storage.c
> +++ b/drivers/usb/gadget/f_mass_storage.c
> @@ -2810,6 +2810,7 @@ static struct fsg_common *fsg_common_init(struct  
> fsg_common *common,
>  	for (i = 0, lcfg = cfg->luns; i < nluns; ++i, ++curlun, ++lcfg) {
>  		curlun->cdrom = !!lcfg->cdrom;
>  		curlun->ro = lcfg->cdrom || lcfg->ro;
> +		curlun->initially_ro = curlun->ro;
>  		curlun->removable = lcfg->removable;
>  		curlun->dev.release = fsg_lun_release;
>  		curlun->dev.parent = &gadget->dev;

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
