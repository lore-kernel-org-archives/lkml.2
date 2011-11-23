Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1KWOzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 09:55:14 -0500
Received: from mx0.aculab.com ([213.249.233.131]:40212 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756101Ab1KWOzN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 09:55:13 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/2] ax25: integer overflows in ax25_setsockopt()
Date: Wed, 23 Nov 2011 14:53:18 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AEDB@saturn3.aculab.com>
In-Reply-To: <20111123143913.50fbcc8c@lxorguk.ukuu.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/2] ax25: integer overflows in ax25_setsockopt()
Thread-Index: Acyp7YFEC94i3lHvScy4lmNOHQyg3gAARdtg
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Xi Wang" <xi.wang@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, "Joerg Reuter" <jreuter@yaina.de>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        "David Miller" <davem@davemloft.net>, <linux-hams@vger.kernel.org>,
        <netdev@vger.kernel.org>
X-OriginalArrivalTime: 23 Nov 2011 14:53:18.0826 (UTC) FILETIME=[A3430CA0:01CCA9EF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > All these magic numbers come from net/ax25/sysctl_net_ax25.c, where
> > min/max values of each field are set for sysctl.  Is it okay to use
> > them?
> 
> The sysctl range is the 'standard' range, but it's always historically
> been possible to override them in apps for special cases. I'm wary of
> changing that because people do insane things like AX.25 
> bounced off the moon where you need very long timeouts.

It is a long time since I wrote any of the X.25 protocol
stack layers, but I would agree that limiting timers to the
values defined in the standard is probably not a good idea.

Even normal telco's may have decided to use values that
are outside the nominal range.

These timers are almost certainly either 'guard' timers
for missing responses or retransmit timers for 'keepalive'
messages - so allowing much larger values doesn't matter.
I'd only limit them in order to stop the code breaking.

The lower limit (1 second) will be below the limit for the
protocol - but exists to stop the code breaking.

	David


