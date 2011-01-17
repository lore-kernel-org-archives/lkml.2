Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab1AQTME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 14:12:04 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49422 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab1AQTMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 14:12:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ILsT/xREJpji/cTBCGbzBR2duRmH0ME5WomyusF1NiF9zIubUr+Na9vVQn9VFOrrzA
         NAo6Vxc+nT1Y89jeWiJAMNRvmvUFKYTdspMiz3ScYqCNmBRGaU1uKJaaU88CtZt474Ix
         QcJki4+virznm98/xhm64YIC4HzeMRYpxT7Bo=
MIME-Version: 1.0
In-Reply-To: <20110117070000.GE11358@cr0.nay.redhat.com>
References: <AANLkTin9dGAQ1fZM_8MsFr3dGwc17vGEGszY_hPMdozp@mail.gmail.com>
	<AANLkTimgYxjJwF+kORC6Z9vJMLwGvQVv85PkGPRCzyvK@mail.gmail.com>
	<20110117070000.GE11358@cr0.nay.redhat.com>
Date: Mon, 17 Jan 2011 12:11:59 -0700
Message-ID: <AANLkTinRCu1FuOYExo3cgNT=99gPkEZX8SvHWb6ux-bR@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request at ffff8800cf669000
From: xing lin <linxingnku@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 12:00 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> If you are using x86, you have CONFIG_X86_PTDUMP, with which
> you can dump all page tables via debugfs.

It turns out CONFIG_X86_PTDUMP is not set. :-)
utos@node:/boot$ grep PTDUMP /boot/config-2.6.32-24-generic
# CONFIG_X86_PTDUMP is not set
utos@node:/boot$ uname -a
Linux node.memcached.checkpoint.emulab.net 2.6.32-24-generic
#38+emulab1 SMP Mon Aug 23 18:07:24 MDT 2010 x86_64 GNU/Linux

On the other hand, I do not understand why I need to look into page
tables. I think for the current 64-bit machines, all the physical
memory can be direct-mapped into the kernel logical space. In the AMD
64-bit machine, the kernel space ranges from [0xFFFF 8000 0000 0000,
0xFFFF FFFF FFFF FFFF] which is 128TB. In my Intel 64-bit machine, the
kernel is mapped at 0xFFFF 8800 0000 0000. I think the kernel space is
from [0xFFFF 8800 0000 0000, 0xFFFF FFFF FFFF FFFF] which is 119TB. So
I can use __pa() or __va() to get physical address or virtual address
directly. Right?


-- 
Regards,
Xing
School of Computing, University of Utah
http://www.cs.utah.edu/~xinglin/
