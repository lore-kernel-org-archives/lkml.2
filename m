Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1G0Qau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:30:50 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:51558 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab1G0Qat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:30:49 -0400
Date: Wed, 27 Jul 2011 12:29:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: jeremy@goop.org, xen-devel@lists.xensource.com, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, keir.xen@gmail.com
Subject: Re: [Xen-devel] Re: [PATCH 0/5] Collected vdso/vsyscall fixes for 3.1
Message-ID: <20110727162956.GA16931@dumpdata.com>
References: <cover.1311736366.git.luto@mit.edu>
 <20110727145745.GA11872@dumpdata.com>
 <CAObL_7FT8QLg-wihasBahhAtS=pA7+KeU8E=E9x8NPZ0+QJ5iQ@mail.gmail.com>
 <20110727153015.GA16688@dumpdata.com>
 <CAObL_7GWGx4rYJFLpucEX=ozNpk+5ipyq0=vw16xcGetEXSuGQ@mail.gmail.com>
 <20110727154316.GA16909@dumpdata.com>
 <CAObL_7FncQ7DdNf2igFZW=ZzPFQLO3Vvp1c_y5EajA_KTt8iOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAObL_7FncQ7DdNf2igFZW=ZzPFQLO3Vvp1c_y5EajA_KTt8iOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A020203.4E303D10.0191,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 400c8d:       c4 e1 f3 2a c8          vcvtsi2sd %rax,%xmm1,%xmm1
> 
> which is unlikely to work on AMD unless you're the lucky owner of a
> prerelease Bulldozer chip.  I
> 
> I bet if you pull a new copy or remove -mavx from Makefile it will
> work.  I got a grossly hacked-up Xen domU booted and everything seems
> to work.

Ok.
> 
> (Testing native kernels is really fun with qemu-kvm -kernel <image>
> -initrd <my silly initramfs>.  But Xen doesn't seem to support that.)

You mean running Xen within QEMU? It does, but you need to use a multiboot
loader and QEMU does not seem to support that. You can create an
.iso image with isolinux that loads mboot.c32 for that.

If you want to use qemu like that in Xen environment you can do it too.
Just need the upstream version and use -M xenpv
