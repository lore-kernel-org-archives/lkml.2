Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab3AITi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 14:38:57 -0500
Received: from mout.gmx.net ([212.227.17.21]:60053 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab3AITi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 14:38:56 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18TGyVhuhYTT0Qcr6Ut7dMNY13KW0U/7/Yjbq9YSY
	1inUHIiJiWoKCm
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics ST33 I2C KERNEL 3.x.x OOPS!
Date: Wed, 9 Jan 2013 20:41:18 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.1; KDE/4.9.3; x86_64; ; )
Cc: Mathias LEBLANC <Mathias.LEBLANC@st.com>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        "Jean-Luc BLANC" <jean-luc.blanc@st.com>,
        "Sirrix@jasper.es" <Sirrix@jasper.es>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kent Yoder <shpedoikal@gmail.com>
References: <1353363322-2923-1-git-send-email-mathias.leblanc@st.com> <20130108172053.GA11223@ennui.austin.ibm.com> <35286B1AE75A7C47BFF0870081A31B4B3A9E2CB82D@SAFEX1MAIL4.st.com>
In-Reply-To: <35286B1AE75A7C47BFF0870081A31B4B3A9E2CB82D@SAFEX1MAIL4.st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301092041.18888.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Do you have the I2C configuration activated ?
> I have this error when I add the driver in a kernel with no I2C activated

I2C works fine on my beaglebone, however  I did not add the platform data to my 
boardfile.
a) as I don't use board files anymore but device trees ;)
b) it's perfectly legit to load a driver without the platform data and probe 
it at runtime (which then in doubt fails to probe).

In my opinion a driver should never ever oops, even if the user does something 
stupid (e.g. like probing from userspace ;)

The fix is as simple as adding a simple 
if (!platform_data) return -ENODEV;
or something similar.

Thanks,
Peter

