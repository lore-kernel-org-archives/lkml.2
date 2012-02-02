Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537Ab2BBWJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:09:42 -0500
Received: from mail2.seas.wustl.edu ([128.252.21.109]:12303 "EHLO
	POSTOFFICE.seas.wustl.edu" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933517Ab2BBWJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:09:41 -0500
Message-ID: <4F2B09A4.7040005@seas.wustl.edu>
Date: Thu, 02 Feb 2012 16:09:40 -0600
From: Professor Berkley Shands <berkley@seas.wustl.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.0.18 tcsetattr on fd 0 when detached freezes system (RCU timeouts)
 (Centos 6.1 x86_64)
References: <4F234498.5070800@seas.wustl.edu> <4F239BE1.4090106@msgid.tls.msk.ru> <4F283B40.1070200@seas.wustl.edu> <4F2A4B22.7020909@msgid.tls.msk.ru>
In-Reply-To: <4F2A4B22.7020909@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2012 22:09:40.0749 (UTC) FILETIME=[5C3BB3D0:01CCE1F7]
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I built my .config from the redhat .config provided in 2.6.32-131 using 
make oldconfig.
that failed miserably. I then used one based on 2.6.39.4, which actually 
booted, but I get these
lockup errors, RCU timeouts, ...

The system died right away on the tcsetattr(), (which also did not 
return any error).
And my simple test case crashed all the time. Looked rather suspicous...
Now after a week, *ALL* my 3.0.18 boxes lock up (other than sitting 
IDLE, any load eventually
causes the system to stop scheduling). That is 32 core 6282's, 3.46GHz 
Nehalems, 2.3 GHz 2374's...
I have to assume the tcsetattr() is an artifact at this point.
Without building all the kernels in between 2.6.32.55 and 3.0.18, I 
needed a starting point
for the .config that works. Usually it is something unnoticed that 
needed to be updated
that make oldconfig didn't point out. Things do change that I can't keep 
current on. :-)

So it appears that it has to be my configuration. Hence the request for 
a .config I can compare against to see
what is wrong / misconfigured / not configured etc.

Berkley

