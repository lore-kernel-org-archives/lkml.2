Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab0HJLVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 07:21:07 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55462 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab0HJLVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 07:21:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=b55Y2rhj8qf3g2UtmUvffTIVy5at3k+w8kfvILCGcEdBApHkymOa9N1PXDihq6ZES1
         Kz5c13fqTiA4nX7d90zQAqAilm/viJI2Vvx7v02WJOo5xYxITja6zbnxFoMsVRNLRY06
         ikrczyEr1mKpRlQ3YQds5R8AoTr++t3cUkaF0=
Message-ID: <4C613619.30309@gmail.com>
Date: Tue, 10 Aug 2010 13:20:57 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org
CC: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Fan runs full speed after S3 sometimes (regression)
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

till I was running on 2.6.34-rc5-mm1 (mmotm) and earlier everything was
fine. Now, I'm running 2.6.35-rc6-mm1 (.35-rc5-mm1 was the same) and
sometimes when the computer (desktop) returns from S3, the CPU fan is
running at full speed making a big noise.

I don't know how to debug that. Bisection is out of question -- it
happens once in 10 or 20 cases. There are no fan entries in /sys.

The load is as follows:
$ while :; do cat /proc/loadavg; sleep 3; done
0.37 0.33 0.32 1/325 21358
0.42 0.34 0.32 1/325 21362
0.42 0.34 0.32 1/326 21366
0.38 0.33 0.32 1/330 21386
0.38 0.33 0.32 1/331 21391
0.35 0.33 0.32 1/331 21394
0.32 0.32 0.32 1/331 21397
0.32 0.32 0.32 1/331 21400
0.30 0.32 0.32 1/331 21403
...

I can boot into 34-rc5 to compare that if this is of relevance.

290 kB kernel log since boot over several S3 sleep till now where the
fan is noisy:
http://www.fi.muni.cz/~xslaby/sklad/panics/boot.msg-fan_fullspeed

Should you need DSDT, it's there too:
http://www.fi.muni.cz/~xslaby/sklad/panics/DSDT

Any ideas what could have caused this?

thanks,
-- 
js
