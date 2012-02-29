Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966085Ab2B2S1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:27:31 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:60134 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965944Ab2B2S13 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:27:29 -0500
Date: Wed, 29 Feb 2012 13:25:13 -0500 (EST)
Message-Id: <20120229.132513.1607879808995168004.davem@davemloft.net>
To: jwboyer@gmail.com
Cc: dhdang@apm.com, benh@kernel.crashing.org, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] powerpc/44x: Add more changes for APM821XX EMAC
 driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+5PVA5hciQSvfkodX-oP_kUZueiTp=0+t8X_0iHQ+ehU0ecOQ@mail.gmail.com>
References: <1329466058-15969-1-git-send-email-dhdang@apm.com>
	<CA+5PVA5hciQSvfkodX-oP_kUZueiTp=0+t8X_0iHQ+ehU0ecOQ@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 29 Feb 2012 10:25:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@gmail.com>
Date: Wed, 29 Feb 2012 08:43:46 -0500

> On Fri, Feb 17, 2012 at 3:07 AM, Duc Dang <dhdang@apm.com> wrote:
>> This patch includes:
>>
>>  Configure EMAC PHY clock source (clock from PHY or internal clock).
>>
>>  Do not advertise PHY half duplex capability as APM821XX EMAC does not
>> support half duplex mode.
>>
>>  Add changes to support configuring jumbo frame for APM821XX EMAC.
>>
>> Signed-off-by: Duc Dang <dhdang@apm.com>
> 
> This should have been sent to netdev.  CC'ing them now.
> 
> Ben and David, I can take this change through the 4xx tree if it looks OK to
> both of you.  The pre-requisite DTS patch will go through my tree, so it might
> make sense to keep them together.

Well the patch has coding style problems, for one:

>> +			dev->features |= (EMAC_APM821XX_REQ_JUMBO_FRAME_SIZE
>> +					| EMAC_FTR_APM821XX_NO_HALF_DUPLEX
>> +					| EMAC_FTR_460EX_PHY_CLK_FIX);

Should be:

>> +			dev->features |= (EMAC_APM821XX_REQ_JUMBO_FRAME_SIZE |
>> +					  EMAC_FTR_APM821XX_NO_HALF_DUPLEX |
>> +					  EMAC_FTR_460EX_PHY_CLK_FIX);

And this:

>> +		dev->phy_feat_exc = (SUPPORTED_1000baseT_Half
>> +					| SUPPORTED_100baseT_Half
>> +					| SUPPORTED_10baseT_Half);

Should be:

>> +		dev->phy_feat_exc = (SUPPORTED_1000baseT_Half |
>> +				     SUPPORTED_100baseT_Half |
>> +				     SUPPORTED_10baseT_Half);
