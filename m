Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520Ab1CXAYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 20:24:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43838 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933494Ab1CXAYE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 20:24:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e0jv6F1nPqQHWbmq52zAnX6WW6GK4mQ8MzQKHORZz8z7IgxIj7s8cDLUzamoQQUy7i
         SBcH1E+qFACp7bASeUgygHnGZgl/F/YwV5v+8V+vMet9qYx+PDnwHj9ZAhqQcAfo27cW
         dxA6v/8+u+0mvyfx/YM/BQrVB14NvVTIkBXlo=
MIME-Version: 1.0
In-Reply-To: <1300919616-6780-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <091F7EC1-5D33-4C90-AFC1-D6E24EF3EEC6@boeing.com>
	<1300919616-6780-1-git-send-email-Kyle.D.Moffett@boeing.com>
Date: Wed, 23 Mar 2011 19:24:04 -0500
Message-ID: <AANLkTin14WSZsc7+B-rK1dSn=XShNrF63k_47RXu-3G6@mail.gmail.com>
Subject: Re: [RFC PATCH] et1011c: Replaced PHY driver by a small dm646x board fixup
From: Andy Fleming <afleming@gmail.com>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
Cc: netdev@vger.kernel.org, Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "David J. Choi" <david.choi@micrel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 5:33 PM, Kyle Moffett <Kyle.D.Moffett@boeing.com> wrote:

> -
> -static struct phy_driver et1011c_driver = {
> -       .phy_id         = 0x0282f014,
> -       .name           = "ET1011C",
> -       .phy_id_mask    = 0xfffffff0,
> -       .features       = (PHY_BASIC_FEATURES | SUPPORTED_1000baseT_Full),
> -       .flags          = PHY_POLL,
> -       .config_aneg    = et1011c_config_aneg,
> -       .read_status    = et1011c_read_status,
> -       .driver         = { .owner = THIS_MODULE,},
> -};


Might I suggest that you not eliminate the whole driver?  If you leave
just this part (and the init stuff below it), and convert the
config_aneg and read_status pointers to use the genphy versions, the
kernel will, at least, be able to report what type of PHY it is.  And
maybe one day, someone who is familiar with the inner workings of this
PHY will fill in a more correct driver.

Andy
