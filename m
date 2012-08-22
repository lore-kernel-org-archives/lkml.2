Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab2HVGk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 02:40:58 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:33421 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752385Ab2HVGkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 02:40:55 -0400
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2012 02:40:55 EDT
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Feng Tang <feng.tang@intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: i2c-eg20t: regression since i2c_add_numbered_adapter change
Date: Wed, 22 Aug 2012 08:30:35 +0200
Message-ID: <4401854.hVfHzgeqjT@ws-stein>
User-Agent: KMail/4.8.5 (Linux/3.3.8-gentoo; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I just noticed the 3.4 linux kernel fails to sucessfully probe the i2c-eg20t 
driver. I returns with EBUSY error. It worked on the 3.0 kernel. To my view it 
is caused the commit 07e8a51ff68353e01d795cceafbac9f54c49132b ( i2c-eg20t: use 
i2c_add_numbered_adapter to get a fixed bus number).
The reason it actually fails is that the i2c-isch driver is registered 
beforehand which gets bus number 0. But this one is the bus number the eg20t 
driver wants to register.
A possibility is that if i2c_add_numbered_adapter failed with EBUSY just use 
i2c_add_adapter to get at least the driver working, but with a non-fixed bus 
number. Opinions?

Best regards,
Alexander

