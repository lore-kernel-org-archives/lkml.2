Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab0FCObE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 10:31:04 -0400
Received: from ist.d-labs.de ([213.239.218.44]:59915 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab0FCObB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 10:31:01 -0400
Date: Thu, 3 Jun 2010 16:30:49 +0200
From: Florian Mickler <florian@mickler.org>
To: markgross@thegnar.org
Cc: 640e9920@gmail.com,
       Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100603163049.4eba1574@schatten.dmk.lab>
In-Reply-To: <20100603132449.GA15595@gvim.org>
References: <20100531232617.GF31155@gvim.org>
	<20100601090737.4bc243d9@schatten.dmk.lab>
	<20100601140519.GC1281@gvim.org>
	<AANLkTikF-B23_UWG1O3tlBl4m8NStAJllGhhevNhYZT6@mail.gmail.com>
	<20100602133910.GA9106@gvim.org>
	<AANLkTilSU79cnBODXFokzIPB1hRcZBxbwTgTQ59MeKcK@mail.gmail.com>
	<20100603031842.GB11311@gvim.org>
	<AANLkTiks7sQBbDnN6QrtGVqSXLob1qCs7VA12LZAWnfM@mail.gmail.com>
	<20100603054018.GE11311@gvim.org>
	<AANLkTikvuqtcGS1UdePRxipSk4S5Vmci2uPfFtzZgx6X@mail.gmail.com>
	<20100603132449.GA15595@gvim.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010 06:24:49 -0700
mark gross <640e9920@gmail.com> wrote:

> On Thu, Jun 03, 2010 at 12:10:03AM -0700, Arve Hjønnevåg wrote:

> ok I'm not getting it.
> is this a fancy com-sci algorithm I should know about?
> 
> --mgross

I think you are at an advantage if you have studied fancy com-sci for
this? Here is an example:

say you have 5 constraints: 
qos1 with a value of 10
qos2 with 5
qos3 with 10
qos4 with 11

Now, you hash that list by the qos-values:

11    ---- 10 	----- 5 
|	   |  	      |
qos4	   qos3       qos2
	   |
	   qos1


To compute the maximum you just walk the "----" list.

To reduce qos4 from 11 to 5 you remove it from its "|" list and
prepend it to the corresponding "|" list.  (4 Pointer adjustments +
searching the "-----" list for the right place to insert.  

result:

10 ---- 5
|	|
qos3	qos4
|	|
qos1	qos2

Cheers,
Flo
