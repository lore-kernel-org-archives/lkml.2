Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427Ab1CDPZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:25:10 -0500
Received: from mga03.intel.com ([143.182.124.21]:39444 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758483Ab1CDPZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:25:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,264,1297065600"; 
   d="scan'208";a="397627930"
Date: Fri, 4 Mar 2011 15:02:05 +0000
From: Alan Cox <alan@linux.intel.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ken Mills <ken.k.mills@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Usage of the n_gsm line discipline
Message-ID: <20110304150205.7805f406@bob.linux.org.uk>
In-Reply-To: <20110304152348.5d03c8ef@surf>
References: <20110304152348.5d03c8ef@surf>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, maybe I misconfigured n_gsm, or I didn't understand how to use it.
> Would it be possible to have a few details on how it is supposed to be
> used ? I haven't been able to find any userspace code that currently
> makes use of n_gsm. Is it available somewhere ?

Check dmesg but if your modem doesn't start up in multiplex mode you
will need to issue an AT+CMUX command first. So the usual sequence is

	write AT+CMUXblah [see GSM spec/modem command info]
	TIOCSETD
	GSMIOC_GETCONF
		[modify anything needed]
	GSMIOC_SETCONF

The defaults uses are the T1/T2/N2 from the spec, we are not the
initiator, and using encoding 1 (ie HDLC/LAP like), 64byte MRU/MTU.

So at the very least you'll want to set initiator to 1 so that we start
issuing SABM messages at the modem to enter mux mode.

> If I can get it to work, I am willing to contribute a
> Documentation/n_gsm.txt document.

That would be good.

Alan
