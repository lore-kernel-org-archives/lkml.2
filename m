Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab2K0Nsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:48:47 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:48415 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab2K0Nsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:48:43 -0500
MIME-Version: 1.0
In-Reply-To: <1353912241.30446.1257.camel@edumazet-glaptop>
References: <1353900555-5966-1-git-send-email-ling.ma.program@gmail.com>
	<1353912241.30446.1257.camel@edumazet-glaptop>
Date: Tue, 27 Nov 2012 21:48:42 +0800
Message-ID: <CAOGi=dPQWC8hgt4jhMEHcVPb6j+jMTguNAchiLjdvvHjarCW4Q@mail.gmail.com>
Subject: Re: [PATCH RFC] [INET]: Get cirtical word in first 64bit of cache line
From: Ling Ma <ling.ma.program@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> networking patches should be sent to netdev.
>
> (I understand this patch is more a generic one, but at least CC netdev)
Ling: OK, this is my first inet patch, I will send to netdev later.

> You give no performance numbers for this change...
Ling: after I get machine, I will send out test result.

> I never heard of this CWF/ER, where are the official Intel documents
> about this, and what models really benefit from it ?
Ling:
Arm implemented it.
http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0388f/Caccifbd.html
AMD also used it.
http://classes.soe.ucsc.edu/cmpe202/Fall04/papers/opteron.pdf

> Also, why not moving skc_net as well ?
>
> BTW, skc_daddr & skc_rcv_saddr are 'critical' as well, we use them in
> INET_MATCH()
Ling: in the looking-up routine, hash value is the most important key,
if it is matched,  the other values have most possibility to be
satisfied, and CFW is limited by memory bandwidth(64bit usually), so
we only move hash value as critical first word.

Thanks
Ling
