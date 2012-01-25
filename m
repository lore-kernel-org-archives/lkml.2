Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab2AYIUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 03:20:16 -0500
Received: from smtp.nokia.com ([147.243.128.26]:42583 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab2AYIUP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 03:20:15 -0500
From: <leonid.moiseichuk@nokia.com>
To: <penberg@kernel.org>, <mtosatti@redhat.com>
CC: <rhod@redhat.com>, <riel@redhat.com>, <minchan@kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <mel@csn.ul.ie>,
        <rientjes@google.com>, <kosaki.motohiro@gmail.com>,
        <hannes@cmpxchg.org>, <akpm@linux-foundation.org>,
        <kosaki.motohiro@jp.fujitsu.com>
Subject: RE: [RFC 1/3] /dev/low_mem_notify
Thread-Topic: [RFC 1/3] /dev/low_mem_notify
Thread-Index: AQHM1PAILpEwsgBJQ0+ebltvcfq8MpYQOdkAgAB3jICAACXvgIAA9v4A///6iYCAABO3AIAAA+QAgAARAJCAAMdZAIAAg3iAgAAcKICAAAFDAIAAAtAAgAASS5CACDMHgIAACPYAgAEemaA=
Date: Wed, 25 Jan 2012 08:19:11 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB9826904562B60@008-AM1MPN1-003.mgdnok.nokia.com>
References: <CAOJsxLGiG_Bsp8eMtqCjFToxYAPCE4HC9XCebpZ+-G8E3gg5bw@mail.gmail.com>
	 <84FF21A720B0874AA94B46D76DB98269045596EA@008-AM1MPN1-003.mgdnok.nokia.com>
	 <CAOJsxLG4hMrAdsyOg6QUe71SPqEBq3eZXvRvaKFZQo8HS1vphQ@mail.gmail.com>
	 <84FF21A720B0874AA94B46D76DB982690455978C@008-AM1MPN1-003.mgdnok.nokia.com>
	 <4F175706.8000808@redhat.com>
	 <alpine.LFD.2.02.1201190922390.3033@tux.localdomain>
	 <4F17DCED.4020908@redhat.com>
	 <CAOJsxLG3x_R5xq85hh5RvPoD+nhgYbHJfbLW=YMxCZockAXJqw@mail.gmail.com>
	 <4F17E058.8020008@redhat.com>
	 <84FF21A720B0874AA94B46D76DB9826904559D46@008-AM1MPN1-003.mgdnok.nokia.com>
	 <20120124153835.GA10990@amt.cnet> <1327421440.13624.30.camel@jaguar>
In-Reply-To: <1327421440.13624.30.camel@jaguar>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.23.171]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 25 Jan 2012 08:19:12.0446 (UTC) FILETIME=[04F20DE0:01CCDB3A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: ext Pekka Enberg [mailto:penberg@kernel.org]
> Sent: 24 January, 2012 18:11
> To: Marcelo Tosatti
....
> On Tue, 2012-01-24 at 13:38 -0200, Marcelo Tosatti wrote:
> > Having userspace specify the "sample period" for low memory
> > notification makes no sense. The frequency of notifications is a
> > function of the memory pressure.
> 
> Sure, it makes sense to autotune sample period. I don't see the problem
> with letting userspace decide it for themselves if they want to.
> 
> 			Pekka
Good point, but you must take into account that reaction time in user-space depends how SW stack is organized.
So for some components 1s is good enough update time,  for another cases 10ms.
If changes on VM happened too often they had no sense for user-space.

Thus from practical point of view having sampling period is not a bad idea.
