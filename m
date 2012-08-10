Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab2HJRIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 13:08:45 -0400
Received: from bente.schedom-europe.net ([193.109.184.68]:46200 "EHLO
	bente.schedom-europe.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab2HJRIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 13:08:44 -0400
Message-ID: <50254019.1030304@telenet.be>
Date: Fri, 10 Aug 2012 19:08:41 +0200
From: Janpieter Sollie <janpieter.sollie@telenet.be>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: POI: nvidia forcedeth phy id not present
References: <50243237.9040704@telenet.be> <50244458.5040906@telenet.be>
In-Reply-To: <50244458.5040906@telenet.be>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A primary concern seems to be solved (4k frame size).
However, it is not really a patch yet, just a dirty workaround (just replaced ETH_DATA_LEN with
a value 4000, my switch is limited to 4k)

486c486
< #define NV_PKTLIMIT_1_ETH_DATA_LEN /* hard limit not known */
---
> #define NV_PKTLIMIT_1 4000 /* hard limit not known */

I will try to improve the MTU detection in driver, but it can take some time before I really
understand what each function does. I do not know if this workaround forces a value to the
'initiated' phy, or just forces a wrong MTU to be used on standard nvidia cards.
the results are worth considering: dd -if=//server/share of=/dev/null went from 91 to 112 mbps
(and this is no file cache, the pc has 2gb ram (>50% used by GUI) and the source file is 30 ...)
any help developing a patch may be useful.  Is there some documentation about this driver module?
