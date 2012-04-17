Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab2DQNk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 09:40:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50502 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab2DQNkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 09:40:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v3 1/3] USB: Add driver for NXP ISP1301 USB transceiver
Date: Tue, 17 Apr 2012 13:40:06 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, stern@rowland.harvard.edu,
        linux-arm-kernel@lists.infradead.org
References: <1334666424-2277-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1334666424-2277-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204171340.06788.arnd@arndb.de>
X-Provags-ID: V02:K0:EV67mf7SkzzuL7Di/WmcrU7nEzzBhl48w5lfUNvZEhC
 vafoENgrvt9nYfjaAncCleU1Va00sMQGhzAmjKwO7NMhaKafwz
 B5JVwL5kRhROuHxa4d9Mfj7hAWLOygH6yavd2MeWcZVqF4Jfj6
 X+aJT1sVLfPoG6fzHO+Dxk8F/BRqyLIz0oT7N+yNolEw4gvpFK
 UqC5pGdMFMsVfYJWS8O7JnXs8yrn+ZM6KK/hkUsGyMGA3dLUAm
 zMomd5GY7X9EvnnCs2HRIwGOtfn6Y8ciEqj8WsSIbxpHOex87/
 548vm/6xl4U+X/T1N2S6KpGa1dyfe/DBoTxcuew22qbgVgvyIP
 iXdT2M4nTbnBSBhYEkgM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2012, Roland Stigge wrote:
> +static int match(struct device *dev, void *data)
> +{
> +       struct device_node *node = (struct device_node *)data;
> +       return dev->of_node == node ? 1 : 0;
> +}

One small correction: you should probably check if the device
is actually bound to isp1301_driver:

	return (dev->of_node == node) && (dev->driver == &isp1301_driver.driver);

Otherwise, the changes from last version look all good.

	Arnd
