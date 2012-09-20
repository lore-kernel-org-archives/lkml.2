Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab2ITJaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:30:20 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:52549 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547Ab2ITJaP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:30:15 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Amit Shah <amit.shah@redhat.com>
Date: Thu, 20 Sep 2012 11:29:27 +0200
Subject: RE: [PATCHv2] virtio_console: Add support for remoteproc serial
Thread-Topic: [PATCHv2] virtio_console: Add support for remoteproc serial
Thread-Index: Ac2W9oQb8eo2K2hCQ3eN9iPSVrm2CQACOG0g
Message-ID: <81C3A93C17462B4BBD7E272753C1057923BD6DF285@EXDCVYMBSTM005.EQ1STM.local>
References: <1348073458-17592-1-git-send-email-sjur.brandeland@stericsson.com>
 <20120920061057.GD5721@redhat.com>
In-Reply-To: <20120920061057.GD5721@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Michael S. Tsirkin [mailto:mst@redhat.com]
> sjur.brandeland@stericsson.com wrote:
> > From: Sjur Brændeland <sjur.brandeland@stericsson.com>
> >
> > Add a simple serial connection driver called
> > VIRTIO_ID_RPROC_SERIAL (0xB) for communicating with a
> > remote processor in an asymmetric multi-processing
> > configuration.
> >
> > This implementation reuses the existing virtio_console
> > implementation, and adds support for DMA allocation
> > of data buffers and disables use of tty console and
> > the virtio control queue.
> 
> Can't repoteproc work with control queue?
> Reason I ask, there are known races when
> using config space and I was working on
> a spec change that uses control queue for
> all config accesses.

In my case rproc-serial will be used for transferring boot
image or crash-dump to a modem. In these scenarios the
execution environment is very limited (no OS) and  the size
and complexity of the virtio code at the modem should be kept
to a minimum.

The usage pattern in this case is also very simple,
the virtio device is opened only once, and only reopened
after a complete modem cold-start.

So the control queue is not appropriate for my use-case,
simplicity is the most important requirement.
(And currently the virtio config-space is not supported
by remoteproc anyway).

I don't know if other potential users of rproc_serial have more
complex use-cases in mind?

Regards,
Sjur



