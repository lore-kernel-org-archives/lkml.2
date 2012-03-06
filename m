Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031425Ab2CFVOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:14:36 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:52002 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031211Ab2CFVOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:14:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Andersson <eric.andersson@unixphere.com>
Subject: Re: [PATCHv2 3/3] misc: rename bmp085 to bmp18x
Date: Tue, 6 Mar 2012 21:14:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, zhengguang.guo@bosch-sensortec.com,
        peter.moeller@cn.bosch.com
References: <1331068084-17911-1-git-send-email-eric.andersson@unixphere.com> <1331068084-17911-4-git-send-email-eric.andersson@unixphere.com>
In-Reply-To: <1331068084-17911-4-git-send-email-eric.andersson@unixphere.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203062114.30998.arnd@arndb.de>
X-Provags-ID: V02:K0:Fani4IQHEsEyp9l7sicVaMpICM1CiUiLn2zjbszpIRZ
 p86izTUPVBXM/sbhzTf2TM9jzQ9aauN/QsM2anIJmDmfxUCmNl
 qRbxhhjdpc99bnEDDAuzWcE4ykNakZQLNRHMxjtpvLsA4C2B3v
 hUH8Kj5sWqUAyL7n18zy1FWiRI3iKOREE2fHtOajMgcuk7Yo2e
 1ElqvjJBBvIAsYLqpU+5U/2GQDo+p4WJ7m3QZimW9BqMVPq5SQ
 tVBUZdckwRhMAD0Q48XCCHh4Kq2l8Mh3VJFZxUwHvj2+b+q70+
 QtQFliV1/5w1kj1t1MS32PMMw+K4vxcngqi4AJC/1TbgXb2uNd
 RiGyTPXYDh4jms/Vtxqg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2012, Eric Andersson wrote:
> The bmp085 chip has been deprecated by the newer bmp18x chip family from
> Bosch Sensortec.
> 
> Reviewed-by: Stefan Nilsson <stefan.nilsson@unixphere.com>
> Signed-off-by: Eric Andersson <eric.andersson@unixphere.com>
> ---
>  drivers/misc/Kconfig       |   18 +-
>  drivers/misc/Makefile      |    6 +-
>  drivers/misc/bmp085.c      |  514 --------------------------------------------
>  drivers/misc/bmp18x-i2c.c  |  132 +++++++++++
>  drivers/misc/bmp18x-spi.c  |  140 ++++++++++++
>  drivers/misc/bmp18x.c      |  512 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c/bmp085.h |   63 ------
>  include/linux/i2c/bmp18x.h |   63 ++++++
>  8 files changed, 859 insertions(+), 589 deletions(-)

Please use 'git format-patch -M' when sending a rename patch, to make it obvious
that there are no code changes in the rename. It's a bit suspicous that
the files are different size and that you remove one .c file but add three
other ones.

You should also try give a better explanation why the rename is actually a
good idea. Simply listing the old model as deprecated does not sound like
a strong enough reason, given that some people might rely on the existing
name in user space interfaces.

	Arnd
