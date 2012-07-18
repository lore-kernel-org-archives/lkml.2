Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab2GROm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 10:42:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50150 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab2GROmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 10:42:23 -0400
MIME-Version: 1.0
Date: Wed, 18 Jul 2012 10:42:22 -0400
Message-ID: <CAMUfR_vogZUgJB5QBr-QrYqFEM71J_pyvc=cFRV6apvb=pVJuQ@mail.gmail.com>
Subject: QUESTION: Why might Linux suddenly stop replying to pings for no
 apparent reason?
From: Terry Phelps <tgphelps50@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have this strange recurring problem with SEVERAL machines, all
running the Oracle "Unbreakable Enterprise Kernel", which is based on
the 3.0.16 kernel.

Here is a quick description, while I still have your attention:

I have server S1, and two desktops, D1 and D2, separated by a router.
The D1 and D2 boxes are side by side, on the same IPv4 subnet,
different from S1's subnet. Maybe once a day, or oftener, I find that
D1 cannot ping S1, but D2 can. There are many possible causes for
that, of course, BUT:

I can SSH to S1 from D2, and S1 can ping both D1 and D2 just fine.
TCPDUMP shows that the ICMP request packets from D1 ARE arriving at
S1. S1 is siimply not replying!

Even stranger:
>From S1, I can traceroute to D2, but cannot traceroute to D1. A
traceroute to D1 gets an ENETDOWN returned from sendto(). But there is
only one NIC in the S1, and it certainly isn't down!

One more thing: If I enter "ip route flush cache" on S1, the problem
clears up immediately.

And another: If I leave D1 pinging S1 every 5 seconds, say, the
problem will NEVER clear up by itself. But if D1 stops pinging S1 for
a few minutes, it works again!

No, there's no firewall or selinux running on any machine involved,
and no firewall between the boxes.

I'm totally confused. Can anyone suggest what to look at?
