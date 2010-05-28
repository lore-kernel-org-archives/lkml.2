Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab0E1Num (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 09:50:42 -0400
Received: from smtp.nokia.com ([192.100.122.230]:53892 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab0E1Nuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 09:50:40 -0400
Message-ID: <4BFFCF39.3010507@nokia.com>
Date: Fri, 28 May 2010 17:12:09 +0300
From: Igor Stoppa <igor.stoppa@nokia.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: ext Brian Swetland <swetland@google.com>
CC: ext Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "tytso@mit.edu" <tytso@mit.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>	<20100527220949.GB10602@srcf.ucam.org>	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>	<20100527223605.GB11364@srcf.ucam.org>	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>	<20100528043114.GC26177@thunk.org>	<20100528103713.0a7952d9@lxorguk.ukuu.org.uk>	<20100528114123.GA22947@srcf.ucam.org>	<4BFFB681.1000105@nokia.com>	<AANLkTim04ZfMcPHRB2D_bqcAuguaGwySH2b6repuYLkk@mail.gmail.com>	<4BFFC5DF.5030504@nokia.com> <AANLkTikKGeGHHL6AYC7uBuT7Zihj7lozfidWQ8zRHwab@mail.gmail.com>
In-Reply-To: <AANLkTikKGeGHHL6AYC7uBuT7Zihj7lozfidWQ8zRHwab@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2010 13:49:02.0136 (UTC) FILETIME=[87C6DB80:01CAFE6C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Brian Swetland wrote:

> How is it flawed?  Serious question.
>   

I would avoid repeating all the good arguments given so far, but to make 
it short:

* I believe runtime PM is a much better starting point (at least for the 
type of HW targeted at mobile devices) because it mimics an always-on 
system toward userspace, which requires less disruption in the way apps 
are designed

* QoS is closer to the apps pov: fps if it is a media player or a game, 
transfer speed if it is a file manager, bandwidth if it is a network 
app, etc
The app is required to express its opinion by using a format that it 
understands better and is less system dependent.
Actually the kernel should only be concerned with 2 parameters at most 
for any given operation: latency and bandwidth/throughput

* Some form of resource management is needed as trust mechanism to 
discriminate "trusted" vs untrusted apps that can give reliable info 
(but in your case you should give trust to whom prevents the suspend)

* Most of this could be done in userspace with the kernel merely 
providing the means to enforce the decisions taken by the userspace manager.

* The kernel wouldn't even have to try to outsmart the "evil application 
writer"

igor
