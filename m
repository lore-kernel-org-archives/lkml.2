Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab1C3QP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:15:58 -0400
Received: from tex.lwn.net ([70.33.254.29]:34956 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab1C3QP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:15:56 -0400
Date: Wed, 30 Mar 2011 10:15:55 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Luis Rossi <luisf.rossi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Help with dma on PCI driver
Message-ID: <20110330101555.573491e1@bike.lwn.net>
In-Reply-To: <AANLkTimkss168HfsPtJPpF1MiYAbHty3csW=R10P+=JA@mail.gmail.com>
References: <AANLkTim3eMR+5VQT9Cbew70bLZ_3P7eo3FXx_TxMuP1=@mail.gmail.com>
	<20110330092307.4a8deb79@bike.lwn.net>
	<AANLkTimkss168HfsPtJPpF1MiYAbHty3csW=R10P+=JA@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.24.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 13:11:40 -0300
Luis Rossi <luisf.rossi@gmail.com> wrote:

> should i stop the inti function on the device register,
> and make all the rest inside probe? It makes a lot of sense as the
> rest should be called just if the device is connected...

Yes, you should.  Also, please look at your cdev_add() call and bear in
mind that your device can be accessed immediately after that call.  You
should not call cdev_add() until the device is completely initialized and
ready to go.

Some thought given to locking would also not be misplaced.

Thanks,

jon
