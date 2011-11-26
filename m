Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab1KZXJw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 18:09:52 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:64076 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab1KZXJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 18:09:49 -0500
Date: Sat, 26 Nov 2011 23:53:32 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: jic23@kernel.org
Cc: linux-iio@vger.kernel.org, greg@kroah.com, linux-kernel@vger.kernel.org,
        federico.vaga@gmail.com, dcobas@cern.ch, siglesia@cern.ch,
        manohar.vanga@cern.ch
Subject: Re: [RFC PATCH 1/7] Documentation: add docs for drivers/zio
Message-ID: <20111126225332.GA17001@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <4ED1654D.8020702@kernel.org>
References: <4ED1654D.8020702@kernel.org>
  <cover.1322328073.git.rubini@gnudd.com>
 <136508309048abae5ff23c5230e9344c51442849.1322328075.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zio readme:
>> +    Ctrl: version 0.2, trigger timer, dev zzero, cset 0, chan 2
>> +    Ctrl: seq 102, n 4, size 1, bits 8, flags 01000001 (little-endian)
>> +    Ctrl: stamp 4066.519285605 (0)
>> +    Data: 60 61 62 63

Jonathan  Cameron:
> Interesting approach to meta data handling.  It's kind of 'partly' out
> of band as it can apply to large chunks of data.

Exactly. Then, you can ignore the metadata if you want. It's like
having a line of packed food, with detailed labels. You can read the
label before getting each content blob, or just read the blob and
discard the label.  Or you can pass everything to someone else, for
off-line handling.

We are aware there is a serious overhead if blocks are small, but the
use case is different, as said.

> How does it map if you have triggers causing single captures from each
> channel?  I would imagine you will then store a whole meta data set per
> sample?

Yes. Worse: csets are acquired (or output) concurrently, so there's
one control structure per channel (actually, gain and offset may be
different in each channel, so there's a reason).

But when blocks are acquired by a hardware card with 256MB of internal
memory and then transferred in a single DMA burst for offline
analysis, then the overhead is negligible and I see an advantage in
simplicity.

Actually, we are considering a buffer that reassembles samples,
returning bigger blocks on demand, so we get rid of some of the
overhead.  But that's more a stress-test for the buffer concept than
for real use cases.

Sure we lack any in-kernel users and don't want to have them in the
future, that's helping us a lot.

> I know this isn't your use case, but I'm currious to see where
> the overlap lies between this and IIO as you can imagine!

Yes, we are too. Federico has an ad7888 driver working, both for IIO
and ZIO (and Comedi, but that's out of the game already), and we are
going to write for a few more IIO-supported devices. In this way we
both validate (or not) our design and compare with IIO.

Thank you for your feedback, both here and in the off-list email.

/alessandro
