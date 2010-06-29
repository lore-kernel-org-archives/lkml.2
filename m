Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab0F2OIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 10:08:52 -0400
Received: from n5.bullet.mail.gq1.yahoo.com ([67.195.9.85]:39923 "HELO
	n5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754631Ab0F2OIv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 10:08:51 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 450495.93767.bm@omp128.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=OjfSy7lC2tS0CnpK7uSCFiam/HA/QimJVUzVehuzL+oS20e/Fqe5q5oE6ixxAjSbJa5yGyhV4y5w98aJ3cN1yzQXy0o5MBQm7aMbxtHaeQ+nET8w9PnzD4VM19tbGe9HmP5aw6P1fknPX8mGMTNICeSvgnWe4h6muzq+cXopOJ0=;
Message-ID: <326628.87627.qm@web180310.mail.gq1.yahoo.com>
X-YMail-OSG: X5zNTCAVM1k.58mroUkxsuSNvK5j3cJRuX0d8Jk6M2qrnIu
 G5C8sOcoMHig2xa_wiFG63kQ6C5q1du_zdI2zLU1UfIwuej7rT_6zw5bXR5o
 DonvYUgHqEmjsQcslkl1vzJvHB.LM0DkCVp_qK0GFBtmXOV5vyB.3.P2P5_a
 JAHtpvGOt00Xe.XUaNk87LxWaDFf058OednpvVo2Hk7GpvIVb32bTuyBsX6w
 MXDXa6F1yLHywo5bobesm6ISSn5O14qqSPz10wOwc7xehcxeEKChwoMSiV4p
 JI07GAccvh6wTbR__kPKB9nlrptaY.A9b_0p4uqQbf8OYTlsop__Q6impSpU
 IUmtN15aKCSOfcMRB
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.104.274457
Date: Tue, 29 Jun 2010 07:08:49 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 5/6] usb/gadget: Do not take BKL for gadget->ops->ioctl
To: Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
       =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       David Brownell <dbrownell@users.sourceforge.net>
In-Reply-To: <op.veh043ad7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Date: Friday, June 18, 2010, 6:59 AM
> On Tue, 01 Jun 2010 23:04:44 +0200,
> Arnd Bergmann <arnd@arndb.de>
> wrote:
> > There is no gadget driver in the tree that
> > actually implements the ioctl operation, so
> > obviously it is not necessary to hold the
> > BKL around the call.

The original gadgetfs code used it as a
passthrough to controller-specific ops, as
I recall.  Not much used, right.

And yes, I suspect someone just threw
some BKL stuff here without actually
analysing whether it was necessary.


