Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab0HDQfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:35:41 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49076 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab0HDQfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:35:39 -0400
Date: Wed, 4 Aug 2010 17:35:09 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100804163509.GA31523@srcf.ucam.org>
References: <20100731175841.GA9367@linux.vnet.ibm.com> <20100731215214.2543c07e@infradead.org> <20100801054816.GI2470@linux.vnet.ibm.com> <20100731230101.7cc1d8c7@infradead.org> <20100801191228.GL2470@linux.vnet.ibm.com> <20100801154708.19817b75@infradead.org> <20100802011006.GS2470@linux.vnet.ibm.com> <AANLkTi=a-1hn_oL=i-=RKK9xOur+4mQjTRut+aiXtYkE@mail.gmail.com> <20100803183447.0275c134@infradead.org> <20100804163216.GB24163@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804163216.GB24163@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 09:32:16AM -0700, Paul E. McKenney wrote:

> If this doesn't work for the Android folks for whatever reason, another
> approach would be to do the freeze in user code, which could track
> whether any user-level resources (pthread mutexes, SysV semas, whatever)
> where held, and do the freeze on a thread-by-thread basis within each
> "victim" application as the threads reach safe points.

The main problem I see with the cgroups solution is that it doesn't seem 
to do anything to handle avoiding loss of wakeup events.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
