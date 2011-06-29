Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab1F2PhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:37:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56865 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab1F2Pg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:36:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: missing compat-ioctl for CDROM_DRIVE_STATUS + FDGETPRM
Date: Wed, 29 Jun 2011 17:36:53 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110617090424.GA19345@sig21.net> <20110629125117.GA5739@sig21.net> <20110629150907.GA3412@sig21.net>
In-Reply-To: <20110629150907.GA3412@sig21.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291736.53864.arnd@arndb.de>
X-Provags-ID: V02:K0:1nfWDRMY7MggVZOK+DHnivO+/7g/tlb6LkLvlKFnfMs
 7F+aUKGthTp4rAUcCF97hjuWugnTRWmZIDAqZnVnAFpqGTD8U7
 SQ2yss3brE1Fnu42oIuDzuPl1YVuHmQy7ehEi0Hd3LzWw/VYKB
 BBCjuvQjM9xwHgrys/Jn7Euf+FhaG8xdFF+HZuJT71vk08qlFE
 9YHvIIdoo8ypT+0dI1rmg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 June 2011, Johannes Stezenbach wrote:
> On Wed, Jun 29, 2011 at 02:51:17PM +0200, Johannes Stezenbach wrote:
> > On Wed, Jun 29, 2011 at 02:30:42PM +0200, Arnd Bergmann wrote:
> > > On Wednesday 29 June 2011, Johannes Stezenbach wrote:
> > > > Do I get it right that just adding two IGNORE_IOCTL() to
> > > > the ioctl_pointer array in linux/fs/compat_ioctl.c is sufficient,
> > > > like in commit 3f001711?
> > > 
> > > Yes.
> 
> Hm, it only works for CDROM_DRIVE_STATUS, but I still get
> the warning for FDGETPRM (801c0204).  Could you give
> me a hint how to address this?
> 
> (tested with both 2.6.39.2 and 3.0-rc5-63-g0d72c6f)

FDGETPRM is incompatible in multiple ways: it uses a different
structure and a different command number on 32 bits, because
the structure has a different size.

You will actually need to add FDGETPRM32 to fs/compat_ioctl.h.
This is locally defined in block/compat_ioctl.c, so you may have
to move the definition to include/linux/fd.h.

	Arnd
