Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab1IPRs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:48:57 -0400
Received: from host-215.commandprompt.net ([207.173.203.215]:59903 "EHLO
	lists.commandprompt.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab1IPRsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:48:54 -0400
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Sep 2011 13:48:54 EDT
Content-Type: text/plain; charset=UTF-8
Cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
        viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        robertmhaas <robertmhaas@gmail.com>,
        Pg Hackers <pgsql-hackers@postgresql.org>
Subject: Re: [HACKERS] Improve lseek scalability v3
From: Alvaro Herrera <alvherre@commandprompt.com>
To: Andres Freund <andres@anarazel.de>
In-reply-to: <201109161927.34472.andres@anarazel.de>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <201109161616.50004.andres@anarazel.de> <20110916153620.GA9913@parisc-linux.org> <201109161927.34472.andres@anarazel.de>
Date: Fri, 16 Sep 2011 14:39:50 -0300
Message-Id: <1316194619-sup-2946@alvh.no-ip.org>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Assp-Version: 2.0.1(3.2.15) on assp.commandprompt.com
X-Assp-Client-TLS: yes
X-Assp-ID: assp.commandprompt.com m1-94793-11293
X-Assp-Original-Subject: Re: [HACKERS] Improve lseek scalability v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Excerpts from Andres Freund's message of vie sep 16 14:27:33 -0300 2011:
> Hi,
> On Friday 16 Sep 2011 17:36:20 Matthew Wilcox wrote:

> > Does the query planner need to know the exact number of bytes in the file,
> > or is it after an order-of-magnitude?  Or to-the-nearest-gigabyte?
> It depends on where the information is used. For some of the uses it needs to 
> be exact (the assumed size is rechecked after acquiring a lock preventing 
> extension) at other places I guess it would be ok if the accuracy got lower 
> with bigger files (those files won't ever get bigger than 1GB).

One other thing we're interested in is portability.  I mean, even if
Linux were to introduce a new hypothetical syscall that was able to
return the file size at a ridiculously low cost, we probably wouldn't
use it because it'd be Linux-specific.  So an improvement of lseek()
seems to be the best option.

-- 
Álvaro Herrera <alvherre@commandprompt.com>
The PostgreSQL Company - Command Prompt, Inc.
PostgreSQL Replication, Consulting, Custom Development, 24x7 support
