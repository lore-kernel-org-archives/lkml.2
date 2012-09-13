Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab2IMWnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 18:43:12 -0400
Received: from smtp12.ono.com ([62.42.230.20]:30019 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751074Ab2IMWnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 18:43:10 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Sep 2012 18:43:10 EDT
Message-ID: <5052603D.90802@ono.com>
Date: Fri, 14 Sep 2012 00:37:49 +0200
From: =?UTF-8?B?SkEgTWFnYWxsw7Nu?= <jamagallon@ono.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120909 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Question on /proc/cpuinfo
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

Probably it is a stupid question, but... I wan to count the number of
processors, cores and threads on a linux system. I do it by reading /proc/cpuinfo.

The problem is that the meaning of 'cpu cores' and 'siblings' seems to have changed
over time. Nowadays, it looks like this:

Dual P4 Xeon with HT:
processor	: 0
   siblings	: 1
   cpu cores	: 1
processor	: 1
   siblings	: 1
   cpu cores	: 1
processor	: 2
   siblings	: 1
   cpu cores	: 0
processor	: 3
   siblings	: 1
   cpu cores	: 0

Single Atom N450
processor	: 0
   siblings	: 1
   cpu cores	: 1
processor	: 1
   siblings	: 1
   cpu cores	: 0

So it just sets logical 'fake' processors that have no core but one thread.
And process would just be count 'processor' lines, add up 'cpu cores' lines
and also add 'siblings' lines. Values of the latter ones are associated
with the ligical processor, no the physical one.

Bu I have seen in google that in old docs and mail threads the values were
associated with physical_id's, so in fact for the atom you would get something
like

processor	: 0
   siblings	: 2
   cpu cores	: 1
processor	: 1
   siblings	: 2
   cpu cores	: 1

because both processors were in the same physical one.

Since when is it safe to read things the modern way (kernel version ?).
Is there a better procedure to get this info ?

-- 
J.A. Magallon <jamagallon()ono!com>        \               Winter is coming...
