Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab2GQJfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 05:35:09 -0400
Received: from tharradin.pu-pm.univ-fcomte.fr ([194.57.85.210]:56839 "EHLO
	tharradin.pu-pm.univ-fcomte.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330Ab2GQJfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 05:35:07 -0400
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Jul 2012 05:35:07 EDT
Message-ID: <50052FFE.2060109@pu-pm.univ-fcomte.fr>
Date: Tue, 17 Jul 2012 11:27:26 +0200
From: Eugen Dedu <Eugen.Dedu@pu-pm.univ-fcomte.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: getsockopt/setsockopt with SO_RCVBUF and SO_SNDBUF "non-standard"
 behaviour
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I looked on Internet and at the old thread 
http://lkml.indiana.edu/hypermail/linux/kernel/0108.0/0275.html, but the 
issue is still not settled as far as I see.

I need to have the highest memory available for snd/rcv buffer and I 
need to know/confirm how much it allocated for my process (how much I 
can use).

So with Linux we need to do something like:
setsockopt (..., SO_RCVBUF, 256000, ...)
getsockopt (..., SO_RCVBUF, &i, ...)
i /= 2;

where i is the size I am looking for.

Now, to make this code work for other OSes it should be changed to:
setsockopt (..., SO_RCVBUF, 256000, ...)
getsockopt (..., SO_RCVBUF, &i, ...)
#ifdef LINUX
i /= 2;
#endif

First question, is this code correct?  If not, what code gives the 
amount of memory useable for my process?

Second, it seems to me that linux is definitely "non-standard" here. 
Saying that linux uses twice as memory has nothing to do with that, 
since getsockopt should return what the application can count on, not 
what is the internal use.  It is like a hypothetical malloc (10) would 
return not 10, but 20 (including meta-information).  Is that right?

Cheers,
-- 
Eugen Dedu
http://eugen.dedu.free.fr
