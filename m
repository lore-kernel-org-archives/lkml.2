Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165Ab1D0NFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 09:05:22 -0400
Received: from mx0.aculab.com ([213.249.233.131]:53891 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757893Ab1D0NFU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 09:05:20 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V4] POWER: perf_event: Skip updating kernel counters if register value shrinks
Date: Wed, 27 Apr 2011 14:04:25 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AD05@saturn3.aculab.com>
In-Reply-To: <20110427125930.GB2936@mgebm.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V4] POWER: perf_event: Skip updating kernel counters if register value shrinks
Thread-Index: AcwE2t3dH1Kqa4LPRRiF0kc8W0qndAAAHqdA
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric B Munson" <emunson@mgebm.net>
Cc: <benh@kernel.crashing.org>, <a.p.zijlstra@chello.nl>, <paulus@samba.org>,
        <mingo@elte.hu>, <acme@ghostprotocols.net>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <anton@samba.org>, <stable@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> On Wed, 27 Apr 2011, David Laight wrote:
> 
> > > But it isn't, and it doesn't have trouble with 2^32 - 1.  
> > 
> > what about:
> > prev = 0x00000001
> > val  = 0xffffffff
> 
> Result is 0xfffffffe and we are fine.

'delta' will be 0xfffffffe, but you need the function to
return zero - since the underlying counter has decremented
by 2. But 'prev > val' is false so the counter will
be increased by 2^32-2.

	David


