Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab2C0WZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:25:10 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:31614 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756026Ab2C0WZJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:25:09 -0400
X-SpamScore: -16
X-BigFish: VS-16(zz9371I542M1432N98dK4015Izz1202hzz8275dhz2fh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14MLTC104.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] net/hyperv: Add flow control based on hi/low
 watermark
Thread-Topic: [PATCH 1/1] net/hyperv: Add flow control based on hi/low
 watermark
Thread-Index: AQHNDGcrP2ipc95FY0ig5urgrbLA6ZZ+tuaAgAABG5A=
Date: Tue, 27 Mar 2012 22:25:00 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0DD17B5A@TK5EX14MBXC222.redmond.corp.microsoft.com>
References: <1332886987-11613-1-git-send-email-haiyangz@microsoft.com>
 <1332886987-11613-2-git-send-email-haiyangz@microsoft.com>
 <20120327222045.GA469@kroah.com>
In-Reply-To: <20120327222045.GA469@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Tuesday, March 27, 2012 6:21 PM
> To: Haiyang Zhang
> Cc: davem@davemloft.net; netdev@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/1] net/hyperv: Add flow control based on hi/low
> watermark
> 
> On Tue, Mar 27, 2012 at 03:23:07PM -0700, Haiyang Zhang wrote:
> > --- a/include/linux/hyperv.h
> > +++ b/include/linux/hyperv.h
> > @@ -274,6 +274,35 @@ struct hv_ring_buffer_debug_info {
> >  	u32 bytes_avail_towrite;
> >  };
> >
> > +/* Amount of space to write to */
> > +#define BYTES_AVAIL_TO_WRITE(r, w, z) \
> > +	(((w) >= (r)) ? ((z) - ((w) - (r))) : ((r) - (w)))
> > +
> 
> That's a very bad #define to use in a .h file, please do not do that.
> 
> > +
> > +/*
> > + *
> > + * hv_get_ringbuffer_availbytes()
> > + *
> > + * Get number of bytes available to read and to write to
> > + * for the specified ring buffer
> > + */
> > +extern inline void
> > +hv_get_ringbuffer_availbytes(struct hv_ring_buffer_info *rbi,
> > +			  u32 *read, u32 *write)
> 
> What does "extern inline" mean?
> 
> Please fix.

Will do.

Thanks,
- Haiyang

