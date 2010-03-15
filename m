Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936894Ab0COVkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:40:04 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38803 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab0COVkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:40:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B9EA92B.1020404@s5r6.in-berlin.de>
Date: Mon, 15 Mar 2010 22:39:55 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Thomas Weber <swirl@gmx.li>
CC: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 2/4] Fix typo: udpate => update
References: <1268686738-28293-1-git-send-email-swirl@gmx.li> <1268686738-28293-3-git-send-email-swirl@gmx.li>
In-Reply-To: <1268686738-28293-3-git-send-email-swirl@gmx.li>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Weber wrote:
> Signed-off-by: Thomas Weber <swirl@gmx.li>
> ---
>  Documentation/kbuild/kconfig.txt            |    2 +-
>  drivers/firewire/ohci.c                     |    2 +-

The firewire part is of course
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

>  drivers/infiniband/hw/ipath/ipath_iba6110.c |    2 +-
>  drivers/infiniband/hw/ipath/ipath_iba6120.c |    4 ++--
>  drivers/infiniband/hw/ipath/ipath_iba7220.c |    2 +-
>  drivers/isdn/hisax/hfc4s8s_l1.c             |    2 +-
>  drivers/staging/rtl8187se/r8180_core.c      |    4 ++--

See comment on this part below.

>  drivers/staging/rtl8187se/r8180_dm.c        |    2 +-
>  drivers/staging/rtl8187se/r8185b_init.c     |    2 +-

Ditto.

>  fs/jfs/jfs_dmap.c                           |    2 +-
>  10 files changed, 12 insertions(+), 12 deletions(-)
> 
[...]
> --- a/drivers/staging/rtl8187se/r8180_core.c
> +++ b/drivers/staging/rtl8187se/r8180_core.c
> @@ -2364,7 +2364,7 @@ void rtl8180_wmm_param_update(struct work_struct * work)
>  				u8		u1bAIFS;
>  				u32		u4bAcParam;
>  				pAcParam = (PAC_PARAM)(&AcParam);
> -				// Retrive paramters to udpate.
> +				// Retrive paramters to update.
>  				u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN *(((mode&IEEE_G) == IEEE_G)?9:20) + aSifsTime;
>  				u4bAcParam = ((((u32)(pAcParam->f.TXOPLimit))<<AC_PARAM_TXOP_LIMIT_OFFSET)|
>  					      (((u32)(pAcParam->f.Ecw.f.ECWmax))<<AC_PARAM_ECW_MAX_OFFSET)|

"Retrieve" and "parameters".
(You are fixing "parameters" in patch 3/4 --- why not right here?)

> @@ -2400,7 +2400,7 @@ void rtl8180_wmm_param_update(struct work_struct * work)
>  			u8		u1bAIFS;
>  			u32		u4bAcParam;
>  
> -			// Retrive paramters to udpate.
> +			// Retrive paramters to update.
>  			eACI = pAcParam->f.AciAifsn.f.ACI;
>  			//Mode G/A: slotTimeTimer = 9; Mode B: 20
>  			u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * (((mode&IEEE_G) == IEEE_G)?9:20) + aSifsTime;

Ditto.

> --- a/drivers/staging/rtl8187se/r8185b_init.c
> +++ b/drivers/staging/rtl8187se/r8185b_init.c
> @@ -1128,7 +1128,7 @@ ActUpdateChannelAccessSetting(
>  				u8		u1bAIFS;
>  				u32		u4bAcParam;
>  
> -				// Retrive paramters to udpate.
> +				// Retrive paramters to update.
>  				eACI = pAcParam->f.AciAifsn.f.ACI;
>  				u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * ChnlAccessSetting->SlotTimeTimer + aSifsTime;
>  				u4bAcParam = (	(((u32)(pAcParam->f.TXOPLimit)) << AC_PARAM_TXOP_LIMIT_OFFSET)	|

Ditto.

By the way, some of the staging drivers are undergoing heavy
reformatting, hence it may be better to submit spelling fixes in those
separately from non-staging code.  (I don't know if this is the case
with rtl8187se in particular.)
-- 
Stefan Richter
-=====-==-=- --== -====
http://arcgraph.de/sr/
