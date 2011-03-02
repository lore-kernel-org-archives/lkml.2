Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab1CBU0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 15:26:33 -0500
Received: from exprod7og124.obsmtp.com ([64.18.2.26]:38825 "EHLO
	exprod7og124.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398Ab1CBU0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 15:26:31 -0500
Message-ID: <4D6EA7C0.1020702@genband.com>
Date: Wed, 02 Mar 2011 14:25:36 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mikael Abrahamsson <swmike@swm.pp.se>
CC: Eric Dumazet <eric.dumazet@gmail.com>, Albert Cahalan <acahalan@gmail.com>,
        David Miller <davem@davemloft.net>, johnwheffner@gmail.com,
        linville@tuxdriver.com, jussi.kivilinna@mbnet.fi,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: txqueuelen has wrong units; should be time
References: <20110228165501.GC2515@tuxdriver.com>  <AANLkTinj5szpStmA+fZ1xggdyTS+sd8Y9jXaYquDNEjs@mail.gmail.com>  <AANLkTinFZu5AgfhO6PoA7C1NTGSfD8HH0KXq_o-mHEJF@mail.gmail.com>  <20110228.201852.193726064.davem@davemloft.net>  <AANLkTi=eDQh9Kvr9N_dTC5Cnbcfb+DbO-6tLxkZiEp9v@mail.gmail.com> <1298964381.2676.58.camel@edumazet-laptop> <alpine.DEB.1.10.1103020358010.7942@uplift.swm.pp.se>
In-Reply-To: <alpine.DEB.1.10.1103020358010.7942@uplift.swm.pp.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Mar 2011 20:25:38.0366 (UTC) FILETIME=[FE45E5E0:01CBD917]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17988.001
X-TM-AS-Result: No--8.792500-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 09:10 PM, Mikael Abrahamsson wrote:

> For the case when we're ourselves originating the traffic (for instance to 
> a wifi card with varying speed and jitter due to retransmits on the wifi 
> layer), I think it's taking the too easy way out to use the same 
> mechanisms (dropping packets or marking ECN for our own originated packets 
> seems really weird), here we should be able to pushback information to the 
> applications somehow and do prioritization between flows since we're 
> sitting on all information ourselves including the application.

Doesn't the socket tx buffer give all the app pushback necessary?
(Assuming it's set to a sane value.)

We should certainly do prioritization between flows.  Perhaps if no
other information is available the scheduler priority could be used?

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
