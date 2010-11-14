Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab0KNI5b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 03:57:31 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45415 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab0KNI52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 03:57:28 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CDFA2FC.40603@s5r6.in-berlin.de>
Date: Sun, 14 Nov 2010 09:51:08 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Bruno Randolf <br1@einfach.org>, Andrew Morton <akpm@linux-foundation.org>,
        randy.dunlap@oracle.com, peterz@infradead.org, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        kevin.granade@gmail.com, "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v6] Add generic exponentially weighted moving average
 (EWMA) function
References: <4CDC333E.4070104@s5r6.in-berlin.de> <201011121044.40274.br1@einfach.org> <20101114133029.E008.A69D9226@jp.fujitsu.com>
In-Reply-To: <20101114133029.E008.A69D9226@jp.fujitsu.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>>> Why do ewma_init() and ewma_add() return their first argument?  They look
>>> to me like they can be straight-forward void functions.
>> You are right, for ewma_init() it does not make sense.
>>
>> For ewma_add() I think it does. This has been discussed before (e.g. 
>> http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-10/msg09124.html).
>> Some people might want to get the value when they add a sample by using 
>> ewma_get(ewma_add(&ewma, val));
> 
> 	ewma_add(&ewma, val);
> 	ewma_get(&ewma);
> 
> is enough simpler and cleaner. I don't oppse this :)

There are more candidate colors for the bike shed: :-)
  - an ewma_add_return could do what ewma_get(ewma_add(...)) is meant for,
  - or ewma_add itself could return the result.

BTW, isn't "get" more usually used as a prefix for these kinds of functions in
kernel APIs?  "get" as a suffix more often means "get a reference" alias
increase reference count rather than "get the value".
-- 
Stefan Richter
-=====-==-=- =-== -===-
http://arcgraph.de/sr/
