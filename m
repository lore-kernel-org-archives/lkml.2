Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab2CLJiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 05:38:52 -0400
Received: from mx0.aculab.com ([213.249.233.131]:47363 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755054Ab2CLJit convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 05:38:49 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/3] netxen: qlogic ethernet : Fix Endian Bug.
Date: Mon, 12 Mar 2012 09:37:47 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6E99@saturn3.aculab.com>
In-Reply-To: <CAOD=uF4Vx581zvpAT0dHKjUkrdsiZo-DTNR352V8tALM_P2roA@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/3] netxen: qlogic ethernet : Fix Endian Bug.
Thread-Index: Acz/Z7HuzNgx7t4MRgqSnnQP4EbZQAAy4ABQ
From: "David Laight" <David.Laight@ACULAB.COM>
To: "santosh prasad nayak" <santoshprasadnayak@gmail.com>,
        "Rajesh Borundia" <rajesh.borundia@qlogic.com>
Cc: "Sony Chacko" <sony.chacko@qlogic.com>, "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
X-OriginalArrivalTime: 12 Mar 2012 09:37:47.0519 (UTC) FILETIME=[C8C358F0:01CD0033]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: netdev-owner@vger.kernel.org 
> [mailto:netdev-owner@vger.kernel.org] On Behalf Of santosh 
> prasad nayak
> Sent: 11 March 2012 09:17
> To: Rajesh Borundia
> Cc: Sony Chacko; netdev; linux-kernel; kernel-janitors@vger.kernel.org
> Subject: Re: [PATCH 3/3] netxen: qlogic ethernet : Fix Endian Bug.
> 
> Thanks Rajesh for clarification.
> Included all your inputs in the following patch.
> This is for review not a formal one. Once review is done I will send a
> formal patch.

I'm not sure of the exact nature of the issues here,
but whenever I see code that casts between the addresses
of integer types large bells start ringing - such code
tends to have unwanted dependencies against the sizes
and endiannesses of the relevant fields.
This code might be ok, but lines like:
> +	if (*(__le64 *)mac == cpu_to_le64(~0ULL)) {
rather give me the willies.

	David


