Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913Ab0E0MFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:05:33 -0400
Received: from smtp.nokia.com ([192.100.105.134]:24454 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab0E0MFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:05:31 -0400
Message-ID: <4BFE6546.9070300@nokia.com>
Date: Thu, 27 May 2010 15:27:50 +0300
From: Igor Stoppa <igor.stoppa@nokia.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: ext Florian Mickler <florian@mickler.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux@smtp1.linux-foundation.org" <Linux@smtp1.linux-foundation.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
References: <20100526151945.1b3813ac@schatten.dmk.lab>	<Pine.LNX.4.44L0.1005261033440.1961-100000@iolanthe.rowland.org> <20100527125605.2855f980@schatten.dmk.lab>
In-Reply-To: <20100527125605.2855f980@schatten.dmk.lab>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2010 12:04:48.0454 (UTC) FILETIME=[CDE0F660:01CAFD94]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Florian Mickler wrote:

>
> Converting a driver to using any constraint-API would require analysing
> what makes a driver refuse suspending in the old suspend handler and
> then specify any "no suspend" (or whatever) constraint before those
> conditions arise and clearing of the constraints when it is no longer critical.  
> (Much work.)
>   

That's not really true.
Nothing prevents using from the beginning a sane approach where drivers 
are required to specify constraints.

The way it has been done for the N900 was to let driver developers 
specify _very_ conservative constraints, during the conversion phase.

Then each driver has been optimized.

If you have as requirement for driver developers that their driver must 
be working properly when compiled as module, it is possible to test the 
system with a minimalistic kernel which enters the lowest power state as 
soon as possible, plus only those modules that are being optimized.

This allows also to identify parasitic drivers, which fail to apply the 
proper constraint and instead rely on some other driver to keep the 
system alive.

igor
