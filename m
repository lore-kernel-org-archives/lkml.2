Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab0FOLig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:38:36 -0400
Received: from poutre.nerim.net ([62.4.16.124]:51581 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab0FOLie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:38:34 -0400
Date: Tue, 15 Jun 2010 13:38:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
       linux-bluetooth@vger.kernel.org, clemens@ladisch.de,
       debora@linux.vnet.ibm.com, dri-devel@lists.freedesktop.org,
       linux-i2c@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       linux-media@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH 7/8]ieee1394/sdp2 Fix warning: variable
 'unit_characteristics' set but not used
Message-ID: <20100615133830.55afdddf@hyperion.delvare>
In-Reply-To: <1276547208-26569-8-git-send-email-justinmattock@gmail.com>
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
	<1276547208-26569-8-git-send-email-justinmattock@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010 13:26:47 -0700, Justin P. Mattock wrote:
> Temporary fix until something is resolved

This is wrong by design, sorry. Warnings aren't blocking, and thus need
no "temporary fix". Such temporary fixes would be only hiding the
warning, cancelling the good work of gcc developers. Nack nack nack.

> to fix the below warning:
>   CC [M]  drivers/ieee1394/sbp2.o
> drivers/ieee1394/sbp2.c: In function 'sbp2_parse_unit_directory':
> drivers/ieee1394/sbp2.c:1353:6: warning: variable 'unit_characteristics' set but not used
>  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/ieee1394/sbp2.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
> index 4565cb5..fcf8bd5 100644
> --- a/drivers/ieee1394/sbp2.c
> +++ b/drivers/ieee1394/sbp2.c
> @@ -1356,6 +1356,8 @@ static void sbp2_parse_unit_directory(struct sbp2_lu *lu,
>  
>  	management_agent_addr = 0;
>  	unit_characteristics = 0;
> +	if (!unit_characteristics)
> +		unit_characteristics = 0;
>  	firmware_revision = SBP2_ROM_VALUE_MISSING;
>  	model = ud->flags & UNIT_DIRECTORY_MODEL_ID ?
>  				ud->model_id : SBP2_ROM_VALUE_MISSING;


-- 
Jean Delvare
