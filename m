Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761840Ab2CPQzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:55:19 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:50458 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab2CPQzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:55:16 -0400
Date: Fri, 16 Mar 2012 17:54:47 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
Message-ID: <20120316165447.GA10678@aftab>
References: <20120314204355.GA10187@kroah.com>
 <20120314223102.GA27602@aftab>
 <4F61496D.8030000@redhat.com>
 <20120315113115.GA32149@aftab>
 <4F61E35B.9000906@redhat.com>
 <20120315213844.GA3781@aftab>
 <4F62FE38.6060704@redhat.com>
 <20120316111536.GA8577@aftab>
 <4F632D16.1090200@redhat.com>
 <4F63490E.3040500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F63490E.3040500@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 11:07:10AM -0300, Mauro Carvalho Chehab wrote:
> The patches are (will be, after mirror sync) at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git hw_events_v8

Please send them for a normal review after you've changed them as per
Greg's request.

..

> I decided to code the ras functions it as a new class, under:
> 	/sys/class/ras
> 
> I didn't convert yet the code that creates the CE/UE error counters
> per rank/dimm/branch/csrow, as it will need some changes. The code is
> also creating a "power" subdir, of course, this is uneeded/unwanted,
> but the basic stuff is already there:
> 
> $ tree /sys/class/ras
> /sys/class/ras
> ├── mc0 -> ../../devices/pci0000:3f/0000:3f:03.0/ras/mc0
> ├── rank0 -> ../../devices/pci0000:3f/0000:3f:03.0/ras/mc0/rank0
> ├── rank1 -> ../../devices/pci0000:3f/0000:3f:03.0/ras/mc0/rank1
> ├── rank3 -> ../../devices/pci0000:3f/0000:3f:03.0/ras/mc0/rank3
> └── rank6 -> ../../devices/pci0000:3f/0000:3f:03.0/ras/mc0/rank6
> 
> $ tree /sys/class/ras/mc0
> /sys/class/ras/mc0
> ├── ce_count
> ├── ce_noinfo_count
> ├── device -> ../../../0000:3f:03.0
> ├── fake_inject

This node needs to go to debugfs.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
