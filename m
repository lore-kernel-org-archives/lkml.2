Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab0EHNqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 09:46:19 -0400
Received: from b.painless.aaisp.net.uk ([81.187.30.52]:37924 "EHLO
	b.painless.aaisp.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0EHNqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 09:46:18 -0400
X-Greylist: delayed 1115 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 May 2010 09:46:18 EDT
Subject: option.ko: ZTE MF636 support
From: Peter Hicks <peter.hicks@poggs.co.uk>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 May 2010 14:27:38 +0100
Message-ID: <1273325258.15521.38.camel@angel>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I've discovered that the ZTE MF636 USB HSUPA modem (USB ID 19d2:0033)
doesn't play well with option.ko.  This seems to be a similar problem to
the 4G W14 stick (commit a74171005f2f6474e05bdfccb05c9f0d68224a49).

The symptom of this problem is that the first three serial ports on the
MF636 take around 10s to open with modem-manager, and fail to open with
Minicom.  The fourth serial port is fine.

Blacklisting the first three interfaces in option.c results in them
opening immediately.  This reduces modem detection time in modem-manager
from 20-30 seconds to around five.

As there is only a single blacklisted device in option.c at present,
what is the best way to work around this problem?  Can somebody help me
with writing a patch to submit to fix the problem in the kernel?

Regards,


Peter


