Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423124Ab2I1VDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:03:21 -0400
Received: from listserv2.niif.hu ([193.225.14.155]:55052 "EHLO
	listserv2.niif.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423097Ab2I1VC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:02:56 -0400
X-Greylist: delayed 1020 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2012 17:02:55 EDT
From: Ferenc Wagner <wferi@niif.hu>
To: netdev@vger.kernel.org
Cc: Matt Carlson <mcarlson@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        wferi@niif.hu
Subject: tg3 driver upgrade (Linux 2.6.32 -> 3.2) breaks IBM Bladecenter SoL
Date: Fri, 28 Sep 2012 22:45:28 +0200
Message-ID: <87txuhho5z.fsf@lant.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Upgrading the kernel on our HS20 blades resulted in their SoL (serial
over LAN) connection being broken.  The disconnection happens when eth0
(the interface involved in SoL) is brought up during the boot sequence.
If I later "ip link set eth0 down", then the connection is restored, but
"ip link set eth0 up" breaks it again on 3.2.  ethtool -a, -c, -g, -k
and -u show no difference; ethtool -i on the 2.6.32 kernel reports:

driver: tg3
version: 3.116
firmware-version: 5704s-v3.38, ASFIPMIs v2.47
bus-info: 0000:05:01.0

In the 3.2 kernel the driver version is 3.121.  In the output of lspci
-vv only the Interrupt line shows variability.  I'd be grateful for any
workaround suggestion; I understand that is't not easy given the lack of
information about the SoL implementation, but maybe somebody can guess
what changed in the driver which could affect it this way.
-- 
Regards,
Feri.
