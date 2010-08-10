Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab0HJBTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 21:19:50 -0400
Received: from mail.lang.hm ([64.81.33.126]:49526 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab0HJBTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 21:19:44 -0400
Date: Mon, 9 Aug 2010 18:17:05 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: paulmck@linux.vnet.ibm.com, "Ted Ts'o" <tytso@mit.edu>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
In-Reply-To: <20100809201822.441905f7@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.2.00.1008091812520.23481@asgard.lang.hm>
References: <20100806225453.GA3947@linux.vnet.ibm.com> <alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm> <AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com> <alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm> <20100807061558.GA28087@thunk.org>
 <AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com> <20100808155719.GB3635@thunk.org> <AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com> <20100808213821.GD3635@thunk.org> <20100809112453.77210acc@lxorguk.ukuu.org.uk>
 <20100809181638.GI3026@linux.vnet.ibm.com> <20100809201822.441905f7@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Aug 2010, Alan Cox wrote:

>> But wouldn't an office suite run as a power-oblivious application on an
>> Android device?  After all, office applications do not need to run when
>
> I was waiting for soemone to leap down the pit I dug  Office suites have
> some quite important background activities. Consider the case of a power
> oblivious Open Office. You type a critical document, you suspend, your
> phone battery dies a bit later, you lost your document. Office suites do
> timed backing up as one simple obvious example. That could become a power
> aware behaviour but the truely power oblivious office suite is a myth.

this is a good example of why the office suite should be a privilaged 
application. If the system were to consider it privilaged, it could 
wake up when the timer is scheduled to fire to save the document.

the office suite probably has a periodic timer that would fire every 10 
min no matter what, but if there was a reason to change it, it could be 
modified to only setup the timer when the document is changed. If no 
changes can take place because the system is asleep, the timer never gets 
setup.

David Lang
