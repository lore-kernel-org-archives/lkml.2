Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab2EBUyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:54:39 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35836 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756407Ab2EBUyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:54:38 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/yreFYW2vyTYAV6v68Wtivbm/s8lCbkmwOQrwlXa
	Iesd+VD216HLY2
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Bryan Freed <bfreed@chromium.org>
Subject: Re: [PATCH] CHROMIUM: tpm: tpm_tis_i2c: Lock the I2C adapter for a sequence of requests.
Date: Wed, 2 May 2012 22:54:33 +0200
User-Agent: KMail/1.13.7 (Linux/3.3.3; KDE/4.7.4; x86_64; ; )
Cc: Peter Huewe <peter.huewe@infineon.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>, tpmdd@selhorst.net,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
References: <1335967293-7728-1-git-send-email-peter.huewe@infineon.com> <20120502181435.GF16981@andi> <CAEYUcX06hvTb1YP=9vCpK9Z19dtZgNTjUcSRnrUvjc3bu-D--Q@mail.gmail.com>
In-Reply-To: <CAEYUcX06hvTb1YP=9vCpK9Z19dtZgNTjUcSRnrUvjc3bu-D--Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205022254.33707.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 02 Mai 2012, 21:06:14 schrieb Bryan Freed:
> We could (in the unmodified version of this driver) replace all the
> iic_tpm_read() calls of one byte (which sends an address byte before
> reading a data byte) with an i2c_smbus_read_byte_command() call which
> does the same thing.

Unfortunately we have to use two seperate transfers (write/read) for a single 
byte read as the device does not support "repeated start" conditions and will 
simply fail to respond.

The device has some quirks that the driver has to workaround,
one is the repeated start problem, the other is the locking of the device.
If you can come up with a better solution I'd like to try it out if it's 
compatible with the device.

Thanks,
Peter
