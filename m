Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab1DOG5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 02:57:18 -0400
Received: from fep21.mx.upcmail.net ([62.179.121.41]:63295 "EHLO
	fep21.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab1DOG5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 02:57:17 -0400
X-Greylist: delayed 1082 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Apr 2011 02:57:12 EDT
X-SourceIP: 77.58.148.40
Message-ID: <4DA7E83A.8080007@odi.ch>
Date: Fri, 15 Apr 2011 08:39:54 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Thunderbird/3.1.9
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: High latency in wine after suspend
References: <4D89E99F.30808@odi.ch> <20110415054026.GA1484@ucw.cz>
In-Reply-To: <20110415054026.GA1484@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=vUpxTctd+kpWCBtSXXIkt5ll4Z8E5Qu9nLREXC/hfIo= c=1 sm=0 a=I24HDECOQz4A:10 a=XV0QBAHWQGoA:10 a=8nJEP1OIZ-IA:10 a=ULRV9qDADAjPEBY8bRcA:9 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> After a suspend/resume cycle I see intermittent high latency in
>> poll_schedule_timeout (latencytop). This leads to the mouse cursor
>> freezing for several seconds sometimes when switching to/from a window
>> of a wine process. The problem never occurs before suspend, but always
>> occurs after. Any ideas what could cause such behaviour? Kernel is
>> vanilla 2.6.38 x86_64 running on a recent HP laptop with Intel chipset.
> 
> Was this solved somehow? Can you try to  find "smaller" testcase --
> anything less complex than wine? What about hibernation?

Yes, I made an educated guess and applied

84ac7c
x86, mtrr, pat: Fix one cpu getting out of sync during resume

With that the problem is gone.



