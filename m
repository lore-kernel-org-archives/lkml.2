Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab2AMLwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 06:52:07 -0500
Received: from smtp.nokia.com ([147.243.128.26]:36353 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab2AMLwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 06:52:03 -0500
From: <leonid.moiseichuk@nokia.com>
To: <rientjes@google.com>
CC: <gregkh@suse.de>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <cesarb@cesarb.net>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <emunson@mgebm.net>, <penberg@kernel.org>, <aarcange@redhat.com>,
        <riel@redhat.com>, <mel@csn.ul.ie>, <dima@android.com>,
        <rebecca@android.com>, <san@google.com>, <akpm@linux-foundation.org>,
        <vesa.jaaskelainen@nokia.com>
Subject: RE: [PATCH 3.2.0-rc1 3/3] Used Memory Meter pseudo-device module
Thread-Topic: [PATCH 3.2.0-rc1 3/3] Used Memory Meter pseudo-device module
Thread-Index: AQHMyxrzw3V52zxEQkmaiNpKEK9QnpYDzM3g///5tgCAABJ9kIAAofQAgAKqrWCAAIfZAIAAwQMggADDYwCAAOLXsIAACxEAgAAYpmA=
Date: Fri, 13 Jan 2012 11:51:02 +0000
Message-ID: <84FF21A720B0874AA94B46D76DB982690455759C@008-AM1MPN1-003.mgdnok.nokia.com>
References: <cover.1325696593.git.leonid.moiseichuk@nokia.com>
 <ed78895aa673d2e5886e95c3e3eae38cc6661eda.1325696593.git.leonid.moiseichuk@nokia.com>
 <20120104195521.GA19181@suse.de>
 <84FF21A720B0874AA94B46D76DB9826904554AFD@008-AM1MPN1-003.mgdnok.nokia.com>
 <alpine.DEB.2.00.1201090203470.8480@chino.kir.corp.google.com>
 <84FF21A720B0874AA94B46D76DB9826904554B81@008-AM1MPN1-003.mgdnok.nokia.com>
 <alpine.DEB.2.00.1201091251300.10232@chino.kir.corp.google.com>
 <84FF21A720B0874AA94B46D76DB98269045568A1@008-AM1MPN1-003.mgdnok.nokia.com>
 <alpine.DEB.2.00.1201111338320.21755@chino.kir.corp.google.com>
 <84FF21A720B0874AA94B46D76DB9826904556CB7@008-AM1MPN1-003.mgdnok.nokia.com>
 <alpine.DEB.2.00.1201121247480.17287@chino.kir.corp.google.com>
 <84FF21A720B0874AA94B46D76DB9826904557417@008-AM1MPN1-003.mgdnok.nokia.com>
 <alpine.DEB.2.00.1201130253560.15417@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1201130253560.15417@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.25.32.157]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 13 Jan 2012 11:51:09.0164 (UTC) FILETIME=[A3BE3AC0:01CCD1E9]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: ext David Rientjes [mailto:rientjes@google.com]
> Sent: 13 January, 2012 12:06
> To: Moiseichuk Leonid (Nokia-MP/Helsinki)
...
> > Why? That is expected that product tested and tuned properly,
> > applications fixed, and at least no apps installed which might consume
> > 100 MB in second or two.
> 
> I'm trying to make this easy for you, if you haven't noticed.
Thanks, I did.

> Your memory threshold, as proposed, will have values that are tied directly to the
> implementation of the VM in the kernel when its under memory pressure
> and that implementation evolves at a constant rate.

Not sure that I understand this statement. Free/Used/Active page sets are properties of any VM.
I have a new implementation but it is in testing now. I do not see any relation to VM implementation except statistics and it could be extended with 
"virtual values" which are suitable for user-space e.g. active page set. It could be extended with something else  if someone needs it. 
 The thresholds are set by user-space and individual for applications which likes to be informed.

> mlock() the memory that your userspace monitoring needs to send signals to
> applications, whether those signals are handled to free memory internally or
> its SIGTERM or SIGKILL.

Mlocked memory should be avoid as much as possible because efficiency rate is lowest possible and makes situation for non-mlocked pages even worse.
You cannot mlock whole UI only most critical parts.
Thus, handling time in case of 3rd party apps will be not controllable, User will observe it as device jam/hang/freeze. 
