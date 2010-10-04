Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab0JDIqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 04:46:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656Ab0JDIq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 04:46:29 -0400
Message-ID: <4CA99462.5050707@redhat.com>
Date: Mon, 04 Oct 2010 10:46:26 +0200
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100908 Fedora/3.1.3-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: chich21@mail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux kernel 2.6.34.7 lvm error
References: <8CD30F86F2A0A2B-BE8-179A8@web-mmc-m02.sysops.aol.com>
In-Reply-To: <8CD30F86F2A0A2B-BE8-179A8@web-mmc-m02.sysops.aol.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 3.10.2010 11:56, chich21@mail.com napsal(a):
> With Linux kernel 2.6.34.7 from www.kernel.org the following error occurs.
> 
> Issuing this command produces error.
> 
> vgchange -ay
> 
> outputs:
> Internal error: Maps lock 14317216 < unlock 14321312
> 
> vgchange is part of lvm-tools.
> 
> This doesn't happen with kernel 2.6.34 or 2.6.34.1 from www.kernel.org.
> 
> Is there a patch for 2.6.34.x series coming for this error. As there is one
> for 2.6.35.x series.
> 
> Please CC email me related posts.


Bug is related to stack guard fix - kernel 2.6.36-rc4 has this problem fixed.
Bug is present in 2.6.36-rc3 - so something between them fixes the problem.

It looks like the [stack] mapping loses 1 page after each mlock/munlock cycle.
I'm probably going to play bisect game to find out missing fix.

https://bugzilla.redhat.com/show_bug.cgi?id=638525

Meanwhile lvm tools were also updated to read whole mapping table before
locking pages to avoid reading some mapping lines twice.

Zdenek.

