Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0ESQo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:44:57 -0400
Received: from defer-dn04.ocn.ad.jp ([125.170.100.158]:42770 "EHLO
	defer-dn04.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab0ESQou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 12:44:50 -0400
X-Greylist: delayed 1703 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 May 2010 12:44:50 EDT
Date: Thu, 20 May 2010 01:14:47 +0900 (JST)
Message-Id: <20100520.011447.193688848.anemo@mba.ocn.ne.jp>
To: mroberto@cpti.cetuc.puc-rio.br
Cc: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       cl@linux-foundation.org, mel@csn.ul.ie, minchan.kim@gmail.com,
       linux@arm.linux.org.uk, sfr@canb.auug.org.au, hpa@zytor.com,
       yinghai@kernel.org, sshtylyov@mvista.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] MM: Fix NR_SECTION_ROOTS == 0 when using using
 sparsemem extreme.
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <n2pcecb6d8f1005051519ze48b22a0t8548311839f510b0@mail.gmail.com>
	<1273093366-3388-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
References: <1273093366-3388-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
	<n2pcecb6d8f1005051519ze48b22a0t8548311839f510b0@mail.gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 May 2010 18:02:46 -0300, Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br> wrote:
> Got this while compiling for ARM/SA1100:
> 
> mm/sparse.c: In function '__section_nr':
> mm/sparse.c:135: warning: 'root' is used uninitialized in this function
> 
> This patch follows Russell King's suggestion for a new calculation for
> NR_SECTION_ROOTS. Thanks also to Sergei Shtylyov for pointing out the
> existence of the macro DIV_ROUND_UP.

JFYI, This fix is not just silence the warning, fix a real problem.

Without this fix, mem_section[] might have 0 size so mem_section[0]
will share other variable area.  For example, I got:

c030c700 b __warned.16478
c030c700 B mem_section
c030c701 b __warned.16483

This might cause very strange behavior.  Your patch actually fixes it.
Thank you.

---
Atsushi Nemoto
