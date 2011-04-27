Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab1D0MnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 08:43:21 -0400
Received: from mx0.aculab.com ([213.249.233.131]:53555 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753834Ab1D0MnU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 08:43:20 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V4] POWER: perf_event: Skip updating kernel counters if register value shrinks
Date: Wed, 27 Apr 2011 13:42:30 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AD04@saturn3.aculab.com>
In-Reply-To: <20110427121902.GA2936@mgebm.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V4] POWER: perf_event: Skip updating kernel counters if register value shrinks
Thread-Index: AcwE1TlhanNrGd06Q5mcue/9oB8W8QAAr++w
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric B Munson" <emunson@mgebm.net>
Cc: <benh@kernel.crashing.org>, <a.p.zijlstra@chello.nl>, <paulus@samba.org>,
        <mingo@elte.hu>, <acme@ghostprotocols.net>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <anton@samba.org>, <stable@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> +	if (prev > val && (prev - val) < 256)
> +		delta = 0;
> +
> +	return delta;

Also, 'prev' is a true 64bit value, but 'val' is only ever 32bits.
So once the 64bit 'prev' exceeds 2^32+256 both 'prev > val'
and 'prev - val' are true regardless of the value of 'val'.
This will lead to jumps in the value ....

	David


