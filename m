Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab0HCElV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 00:41:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61285 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab0HCElT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 00:41:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=wEBIAJl40p/WC4eIDK3JKOJQ7+C6Zu9IGregiDVTQpk9lvhoTDmF8dLGEwLmn4z6r
	Azwx8i7YxI14TDAJ84eFQ==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008020200450.25170@asgard.lang.hm>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<20100731215214.2543c07e@infradead.org>
	<20100801054816.GI2470@linux.vnet.ibm.com>
	<20100731230101.7cc1d8c7@infradead.org>
	<20100801191228.GL2470@linux.vnet.ibm.com>
	<20100801204026.GH31324@thunk.org>
	<20100802030304.GU2470@linux.vnet.ibm.com>
	<20100801210548.23f77ff6@infradead.org>
	<alpine.DEB.2.00.1008012153300.25170@asgard.lang.hm>
	<20100802074429.73a9dfd9@schatten.dmk.lab>
	<alpine.DEB.2.00.1008012303160.25170@asgard.lang.hm>
	<20100802084003.1c4c2bdb@schatten.dmk.lab>
	<20100802085332.23dd22f6@schatten.dmk.lab>
	<alpine.DEB.2.00.1008012355210.25170@asgard.lang.hm>
	<20100802092347.692dac32@schatten.dmk.lab>
	<alpine.DEB.2.00.1008020200450.25170@asgard.lang.hm>
Date: Mon, 2 Aug 2010 21:41:17 -0700
Message-ID: <AANLkTinGjktpuNi8062BQPegr4mofF6bx2EfBAsbOhCe@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: Paul Menage <menage@google.com>
To: david@lang.hm
Cc: Florian Mickler <florian@mickler.org>,
        Arjan van de Ven <arjan@infradead.org>, paulmck@linux.vnet.ibm.com,
        "Ted Ts'o" <tytso@mit.edu>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, arve@android.com, mjg59@srcf.ucam.org,
        pavel@ucw.cz, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 2:06 AM,  <david@lang.hm> wrote:
>
> yes, it could mean a doubleing in the number of cgroups that you need on a
> system. and if there are other features like this you can end up in a
> geometric explosion in the number of cgroups.

No, it would be additive - you can mount different subsystems on
separate hierarchies. So if you had X divisions for memory, Y
divisions for CPU and Z divisions for suspend-blocking (where Z=2,
probably?) you could mount three separate hierarchies and have X+Y+Z
complexity, not X*Y*Z.

(Not that I have a strong opinion on whether cgroups is an appropriate
mechanism for solving this problem - just that the problem you forsee
shouldn't occur in practice).

Paul
