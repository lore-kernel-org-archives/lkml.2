Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360Ab0E0UMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:12:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50274 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab0E0UMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:12:14 -0400
Date: Thu, 27 May 2010 21:11:56 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527201155.GB7449@srcf.ucam.org>
References: <20100527160714.GB31937@srcf.ucam.org> <20100527174131.18fd1c72@lxorguk.ukuu.org.uk> <20100527165210.GA1062@srcf.ucam.org> <20100527190204.14546caa@lxorguk.ukuu.org.uk> <20100527181239.GF3543@srcf.ucam.org> <20100527194840.5bca973f@lxorguk.ukuu.org.uk> <20100527185658.GA5703@srcf.ucam.org> <20100527202538.7d2d7f3c@lxorguk.ukuu.org.uk> <20100527192926.GA6977@srcf.ucam.org> <20100527205333.676ad65e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527205333.676ad65e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 08:53:33PM +0100, Alan Cox wrote:
> On Thu, 27 May 2010 20:29:26 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > But wakeup events won't be delivered to STOPped processes, and there's 
> 
> Try the following
> 
> 	cat <pipe
> 	kill -STOP catpid
> 
> 	echo "wombats are cool" > pipe
> 	kill -CONT catpid
> 
> it will echo "wombats are cool"
> 
> The event was not lost.

Not lost, but not delivered. So you need your policy agent to send 
SIGCONT when you receive any wakeup event, which either means proxying 
all your network traffic through your policy agent or having some 
mechanism for alerting the policy agent whenever you leave the deep idle 
state.

> > also the race of an application being in the middle of handling a wakeup 
> > event when you send it the signal.
> 
> sigmask()

Doesn't help - I may be hit by the signal between the poll() unblocking 
and me having the opportunity to call sigmask().

-- 
Matthew Garrett | mjg59@srcf.ucam.org
