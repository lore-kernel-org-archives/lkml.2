Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab2IMXSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 19:18:52 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35908 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab2IMXSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 19:18:50 -0400
Message-ID: <505269D5.30601@gmail.com>
Date: Fri, 14 Sep 2012 01:18:45 +0200
From: =?UTF-8?B?SkEgTWFnYWxsw7Nu?= <jamagallonn@gmail.com>
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
processor    : 0
   siblings    : 1
   cpu cores    : 1
processor    : 1
   siblings    : 1
   cpu cores    : 1
processor    : 2
   siblings    : 1
   cpu cores    : 0
processor    : 3
   siblings    : 1
   cpu cores    : 0

Single Atom N450
processor    : 0
   siblings    : 1
   cpu cores    : 1
processor    : 1
   siblings    : 1
   cpu cores    : 0

So it just sets logical 'fake' processors that have no core but one thread.
And process would just be count 'processor' lines, add up 'cpu cores' lines
and also add 'siblings' lines. Values of the latter ones are associated
with the ligical processor, no the physical one.

Bu I have seen in google that in old docs and mail threads the values were
associated with physical_id's, so in fact for the atom you would get something
like

processor    : 0
   siblings    : 2
   cpu cores    : 1
processor    : 1
   siblings    : 2
   cpu cores    : 1

because both processors were in the same physical one.

Since when is it safe to read things the modern way (kernel version ?).
Is there a better procedure to get this info ?

-- 
J.A. Magallon <jamagallonn()gmail!com>     \               Winter is coming...
