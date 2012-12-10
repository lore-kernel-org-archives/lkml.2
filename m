Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab2LJIzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:55:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51479 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2LJIzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:55:46 -0500
Date: Mon, 10 Dec 2012 11:55:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Cyril Roelandt <tipecaml@gmail.com>
Cc: devel@driverdev.osuosl.org, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, yongjun_wei@trendmicro.com.cn,
        marcos.souza.org@gmail.com, Larry.Finger@lwfinger.net
Subject: Re: [PATCH] staging: rtl8712: avoid a useless call to memset().
Message-ID: <20121210085516.GO6568@mwanda>
References: <1354670522-27144-1-git-send-email-tipecaml@gmail.com>
 <20121205071156.GL6568@mwanda>
 <50C3DBF6.2080103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C3DBF6.2080103@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2012 at 01:31:50AM +0100, Cyril Roelandt wrote:
> On 12/05/2012 08:11 AM, Dan Carpenter wrote:
> >On Wed, Dec 05, 2012 at 02:22:02AM +0100, Cyril Roelandt wrote:
> >>In r8711_wx_get_wap(), make sure we do not call memcpy() on a memory area that
> >>has just been zeroed by a call to memset().
> >>
> >
> >I look at it like the original code is fine.  Your version is also
> >fine but is it worth the churn?  Also the curly braces are not
> >needed.
> >
> 
> Sorry about the braces.
> 
> I just thought the code would be easier to understand this way, but
> it's probably OK to leave it as it currently is too.
> 

Ah.  I'd buy that.  I like readability fixes.  The indenting is also
messed up and confusing.  It should be:

	if (check_fwstate(pmlmepriv, _FW_LINKED | WIFI_ADHOC_MASTER_STATE |
				     WIFI_AP_STATE))
		memcpy(wrqu->ap_addr.sa_data, pcur_bss->MacAddress, ETH_ALEN);
	else
		memset(wrqu->ap_addr.sa_data, 0, ETH_ALEN);

regards,
dan carpenter
