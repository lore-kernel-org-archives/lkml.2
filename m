Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab1H1Pp6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 11:45:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43502 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1H1Ppv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 11:45:51 -0400
Message-ID: <4E5A6353.5020202@gmail.com>
Date: Sun, 28 Aug 2011 21:48:35 +0600
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110817 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: =?UTF-8?B?SmFuIEt1bmRyw6F0?= <jkt@flaska.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: IPv6: metrics of default routes on different interfaces (Ethernet
 vs. wifi)
References: <4E5A586E.90509@flaska.net>
In-Reply-To: <4E5A586E.90509@flaska.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

28.08.2011 21:02, Jan Kundrát wrote:
> I'm assuming here that the metrics of the default routes are somehow
> derived from the "kind" of the underlying network interface, so that a
> gigabit Ethernet is preferred over a 100Mbps one, which is preferred
> over a 10Mbps one, etc. Please correct me if I'm wrong and the metrics
> have a different origin, or if the wired-ethernet-preference it's just a
> pure luck.

> I've tried grepping my kernel sources, but wasn't able to find out the
> place where the interface type is used in metric assignment.

It is not in the kernel. You have to grep through the source of whatever 
utility you are using to configure your interfaces. For dhcpcd, the code 
is around line 200 in net.c:

         /* We reserve the 100 range for virtual interfaces, if and when
          * we can work them out. */
         iface->metric = 200 + if_nametoindex(iface->name);
         if (getifssid(ifname, iface->ssid) != -1) {
                 iface->wireless = 1;
                 iface->metric += 100;
         }

but this doesn't match the metrics that you have. So I assume you use 
some other tool.

-- 
Alexander E. Patrakov
