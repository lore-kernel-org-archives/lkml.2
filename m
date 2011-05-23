Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab1EWROJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:14:09 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:58608 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756324Ab1EWROI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:14:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=EIkMDGqafLiKhN52Q2fphtY1qMCsdXdqlkdd/+C01ZjGC/Gir9mFJjGdsiLn81AkapdEEIF8uqqfEh0Rtg9QwIeMFvvaJuf+xhzhJnYbtf33NVnh8TzMFVGhpUG7z4pJ;
Date: Mon, 23 May 2011 10:14:05 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Micha Nelissen <micha@neli.hopto.org>, lud <linux-usb@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: USB stick as root device does not work
Message-Id: <20110523101405.e3ccafe9.rdunlap@xenotime.net>
In-Reply-To: <4DD919FD.9090000@neli.hopto.org>
References: <4DD919FD.9090000@neli.hopto.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding cc: of linux-usb mailing list]

On Sun, 22 May 2011 16:13:17 +0200 Micha Nelissen wrote:

> Hi,
> 
> Using USB stick as root device does not work for me. I specify
> 'root=/dev/sdb1 rootwait' on the kernel commandline, but the kernel does
> not wait for the USB stick to be scanned and its partitions found. I
> have a harddisk which is /dev/sda, and this USB stick would be /dev/sdb.
> 
> I think blk_lookup_devt returns the block device number even if it does
> not exist yet, and init/do_mounts.c:473 therefore skips waiting:
> 
>         if ((ROOT_DEV == 0) && root_wait) {
> 
> due to ROOT_DEV having become non-zero already.
> 
> If I use the commandline: 'root=/dev/sdb1 rootdelay=5' then it does
> mount and boot properly. However, using rootwait seems safer and faster
> to me, that it's meant for this use case.
> 
> Thanks for any pointers,
> 
> Micha
> --

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
