Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab1IIBkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:40:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52448 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758112Ab1IIBkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:40:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [RFC PATCH v2] support ioctl for tunable user request
Date: Thu, 8 Sep 2011 17:47:52 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jaxboe@fusionio.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lin Ming <lxy@ss.pku.edu.cn>
References: <4E5B4AAF.2040101@samsung.com> <201109051704.12040.arnd@arndb.de> <CAH9JG2XST45QSmkbu4kqmuQ-vOS-xdwwz_w_CLepHYpA7z01cA@mail.gmail.com>
In-Reply-To: <CAH9JG2XST45QSmkbu4kqmuQ-vOS-xdwwz_w_CLepHYpA7z01cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109081747.52518.arnd@arndb.de>
X-Provags-ID: V02:K0:oCPMg1hbt6MQtTOUCmP1E0ee1/dYxPvSB8ob7mGgBFi
 +7WKY1FPDDFLKDaXHWB7e3NSdtUM7402vKMwqNd9BN4p8ZVpI6
 8qpq//U6pcHY5U8AczmvJHkfgdBUtIG134wobvVA+YN5WXIaKi
 sghQ7Yv+jdiW0h1jNIkPLPdyDSWLOjPUoqfEP0fEZ8K0ARy9Mq
 K0Mdd1IHRhDnc1HZBA2FxIlP3GCkGV2St1RKKcnmErZ3OUmz+M
 Hxmre18uUDnx4y3ZmXN9kvVfrXTi9T3sQCIklFYTrFl8CjPyiU
 hozJ3fz0/q/QyPt40uu65YEbYlGrGCuzcp2ZBN9w7JLBsotjUk
 vp9NIO/+gt7KE6fYht/U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 September 2011, Kyungmin Park wrote:
> > Would __REQ_GC as a shortcut for garbage collection fit? Right now,
> > I also think TUNE is not at all describing what we expect the drive
> > to do, but it's hard to come up with a term that is generic enough
> > to cover similar concepts in other hardware while still describing
> > what the drive does.
> No problem to use the REQ_GC. BTW, does it acceptable to GC request? I
> hope each devices can do own optimization if REQ_GC is requested, if
> no need to these one, just ignore it at driver level.

I would suggest that you specify exactly what you mean with REQ_GC at the
point where it is defined, e.g.

/*
 * REQ_GC -- force garbage collection on the device 
 *
 * The drive is forced to perform a "garbage collection" on data that it
 * has recently written. This will keep the device busy within a short
 * time span (up to 60 seconds) during which its performance may be
 * significantly reduced. After the garbage collection has finished,
 * the device is expected to provide optimum write performance again.
 *
 * User applications that expect expect high continious write throughput
 * (such as video recording) should issue a REQ_GC before they start
 * recording. A system daemon may occasionally call this during times
 * of relative inactivity in order to improve overall performance.
 *
 * Examples for hardware that should support this include
 * - eMMC 4.6 (background operations)
 * - SD 3.01 (speed class recording)
 * - PCIe based SSD 
 * - Shingled Hard drives
 *
 * Drivers that does not require or support garbage collection will
 * silently ignore this request.
 */

I'm not sure if that's the definition you need, but I think it should
be at this level of detail.

	Arnd
