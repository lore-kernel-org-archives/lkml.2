Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab2KUKAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:00:49 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:37302 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab2KUKAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:00:46 -0500
Date: Wed, 21 Nov 2012 11:00:22 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: [RFC/PATCH 0/1] ubi: Add ubiblock driver
Message-ID: <20121121110022.35db364f@skate>
In-Reply-To: <CALF0-+WuaUn5b=2XrzqW7pvM=N1MfQf=sFwLFOrokTkHbOXh3w@mail.gmail.com>
References: <CALF0-+WuaUn5b=2XrzqW7pvM=N1MfQf=sFwLFOrokTkHbOXh3w@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Ezequiel Garcia,

On Tue, 20 Nov 2012 19:39:38 -0300, Ezequiel Garcia wrote:

> * Read/write support
> 
> Yes, this implementation supports read/write access.

While I think the original ubiblk that was read-only made sense to
allow the usage of read-only filesystems like squashfs, I am not sure a
read/write ubiblock is useful.

Using a standard block read/write filesystem on top of ubiblock is going
to cause damage to your flash. Even though UBI does wear-leveling, your
standard block read/write filesystem will think it has 512 bytes block
below him, and will do a crazy number of writes to small blocks. Even
though you have a one LEB cache, it is going to be defeated quite
strongly by the small random I/O of the read/write filesystem.

I am not sure letting people use read/write block filesystems on top of
flashes, even through UBI, is a good idea.

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
