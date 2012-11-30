Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab2K3Rcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:32:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64209 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2K3Rc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:32:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Eli Billauer <eli.billauer@gmail.com>
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA (programmable logic)
Date: Fri, 30 Nov 2012 17:32:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com> <20121130163254.GB4478@kroah.com> <50B8E5A0.1020406@gmail.com>
In-Reply-To: <50B8E5A0.1020406@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211301732.27921.arnd@arndb.de>
X-Provags-ID: V02:K0:1tyqWgOFU18NiprXBm7fD3fFaCLVaYTUxytrcRWxeYv
 zcFoPJPL+Qm58OYcq3W0l/OSI9zD8Gh30TstPPW8mMFfQxMItC
 d9/829Uk3GMsJ5K7nKoN8mFrpbYb358/3alOSMaf2EKq6RFkYk
 6zUkJTqadbQJutGzNI84yjiXiUgyaqZ3BxHWbBdeuA7mi8qO2A
 VYV7XfCulxfSd+kaMwaUJe6+GbSKMis0bbmlg/lG7WXB0cJtNL
 vgKjY0V0dXyjuduokYneMw1azAkYYJNZDImqtLJqq93+84dElv
 h2/g5S2bUnKY3Snmkkz7I0PyFXYVjiniKYjTODgbXPXV3HtBX7
 Hmxoy6t6lB62/q3U0h5E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 November 2012, Eli Billauer wrote:
> The problem is if the page size smaller than 4kB. The buffers 
> allocated by the driver must not cross a 4kB boundary, and it's assumed 
> that anything returned by __get_free_pages() is 4 kB-aligned. Otherwise 
> the FPGA will generate illegal PCIe packets by crossing that boundary.
> 
> If the page boundary is bigger than 4k, the driver handles that well.
> 

That should be fine then. We don't really support running Linux on
systems with a page size smaller than 4KB anyway, and I think the
only ones that ever hard smaller hardware page sizes (iirc m68k
or vax) were emulating 4KB pages in software.

	Arnd
