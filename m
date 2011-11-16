Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab1KPQz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:55:57 -0500
Received: from mx3.utsp.utwente.nl ([130.89.2.14]:4802 "EHLO mx.utwente.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756830Ab1KPQzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:55:54 -0500
X-Greylist: delayed 2443 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Nov 2011 11:55:54 EST
Subject: Routing problem on PTPP server since kernel 2.6.39
From: Jeroen van Ingen <jeroen@zijndomein.nl>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Nov 2011 17:14:59 +0100
Message-ID: <1321460099.3366.49.camel@icts-sp-039>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-UTwente-MailScanner-Information: Scanned by MailScanner. Contact icts.servicedesk@utwente.nl for more information.
X-UTwente-MailScanner: Found to be clean
X-UTwente-MailScanner-From: jeroen@zijndomein.nl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We're in the process of upgrading our Linux-based (Ubuntu) VPN servers
and running into a problem with PPTP connections.

So far, we have been able to narrow it down to the following:


Problem:

* First PPTP client connects successfully, consecutive PPTP clients
can't connect. Cause seems to be: RADIUS authentication times out
because DHCP address allocation fails, because somehow the DHCPDISCOVER
to 255.255.255.255 is routed out ppp0 and not out of eth0.

* Routing tables look fine, both before and after first PPTP client is
connected.

* Route cache however shows an entry for 255.255.255.255. pointing
towards ppp0 and we can't explain how it got there. After flushing the
route cache this entry quickly reappears.


Last kernel working OK:
* 2.6.38

Kernels where we hit this issue:
* First: 2.6.39
* Most recent one tested: 3.1.1
* All tested kernels are from Ubuntu repository.


Questions:

* Is this the correct list to assist in troubleshooting / narrowing down
the cause? If not, which one is? Netdev or some other?

* What specific info is needed? Already gathered is output from "ip rule
list", "ip route show table" for the various tables and "ip route show
cache", both with kernel 2.6.38 and kernel 2.6.39.


Thanks in advance for any advice, insights or assistance.


Regards,

Jeroen van Ingen
ICT Service Centre
University of Twente, P.O.Box 217, 7500 AE Enschede, The Netherlands
Telephone +31 53 489 2526, Fax +31 53 489 2383
J.vanIngenSchenau@utwente.nl; http://www.utwente.nl/icts

