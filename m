Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab1EDNMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 09:12:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53668 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab1EDNMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 09:12:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
Date: Wed, 4 May 2011 15:11:53 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        "Wolfgang Grandegger" <wg@grandegger.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, Netdev@vger.kernel.org,
        nsekhar@ti.com, "open list" <linux-kernel@vger.kernel.org>,
        "CAN NETWORK DRIVERS" <socketcan-core@lists.berlios.de>,
        m-watkins@ti.com
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com> <201104271525.28512.arnd@arndb.de> <15AD189F851849F69A011B6F4D1DDB6C@subhasishg>
In-Reply-To: <15AD189F851849F69A011B6F4D1DDB6C@subhasishg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105041511.54095.arnd@arndb.de>
X-Provags-ID: V02:K0:UD1KzxAVSqoFabcipBEO6aNI7Hrx10CbdxRmbJvdKZp
 oEtTkilRqt9mf7nkzNigl5CH98UpuL200zt51PpiGxh2sq89Mo
 34lXVJktbrwCVdJrWAQGJVboYfYDs13zbt9E1Nl2soaGwu3yTR
 uFyxp33wToW7POkb6f8MatsdRR6+4yQgt9ACubdN0/iJjTGRDo
 LH3r5W669u5hS/2kspoXQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 May 2011, Subhasish Ghosh wrote:
> CAN requires mail box IDs to be programmed in. But, the socket
> CAN subsystem supports only software filtering of the mail box IDs.
> 
> So, the mail box IDs programmed into socket CAN during initialization
> does not propagate into the hardware. This is planned to be a future
> implementation in Socket CAN.
> 
> In our case, we support hardware filtering, to work around with this,
> Wolfgang (Socket CAN owner) suggested that we implement
> this using sysfs.
> 
> These setting are not for debugging, but to program the mail box IDs
> into the hardware. 

Ok, I see. Can you point me to that discussion?

Wolfgang, I'm a bit worried by the API being split between sockets and sysfs.
The problem is that once the sysfs API is established, users will start
relying on it, and you can no longer migrate away from it, even when
a later version of the Socket CAN also supports setting through a different
interface. What is the current interface to set mail box IDs in software?
How hard would it be to implement that feature in Socket CAN?

Is that something that Subhasish or someone else could to as a prerequisite
to merging the driver?

	Arnd
