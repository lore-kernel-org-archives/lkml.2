Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab2DVT2J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 15:28:09 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:60297
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298Ab2DVT2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 15:28:07 -0400
X-IronPort-AV: E=Sophos;i="4.75,463,1330902000"; 
   d="scan'208";a="141109069"
Date: Sun, 22 Apr 2012 21:28:03 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Sean MacLennan <seanm@seanm.ca>
cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/staging/rtl8192u/ieee80211/ieee80211_module.c:
 add missing free_netdev
In-Reply-To: <20120422152514.60e66f04@lappy.seanm.ca>
Message-ID: <alpine.DEB.2.02.1204222127520.2065@localhost6.localdomain6>
References: <1335096133-16951-1-git-send-email-Julia.Lawall@lip6.fr> <20120422152514.60e66f04@lappy.seanm.ca>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 Apr 2012, Sean MacLennan wrote:

> On Sun, 22 Apr 2012 14:02:13 +0200
> Julia Lawall <Julia.Lawall@lip6.fr> wrote:
>
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> Free dev on failure as done elsewhere in the function.
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> ---
>>  drivers/staging/rtl8192u/ieee80211/ieee80211_module.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
>> b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c index
>> e3d47bc..82d4bf6 100644 ---
>> a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c +++
>> b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c @@ -161,7
>> +161,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv) if
>> (ieee->pHTInfo == NULL) {
>>  		IEEE80211_DEBUG(IEEE80211_DL_ERR, "can't alloc
>> memory for HTInfo\n");
>> -		return NULL;
>> +		goto failed;
>>  	}
>>  	HTUpdateDefaultSetting(ieee);
>>  	HTInitializeHTInfo(ieee); //may move to other place.
>
> It looks like the rtl8192e/rtllib_module.c alloc_rtllib has the same
> error. They probably where based on the same function.

Thanks for the pointer.  I will take a look.

julia
