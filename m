Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab0GUNML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:12:11 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:38846 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752851Ab0GUNMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:12:09 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Subject: Re: CONFIG_SCSI_G_NCR5380_MEM dead?
Date: Wed, 21 Jul 2010 15:12:01 +0200
User-Agent: KMail/1.9.10
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
References: <86pqyhhtut.fsf@peer.zerties.org>
In-Reply-To: <86pqyhhtut.fsf@peer.zerties.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007211512.03147.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 July 2010, Christian Dietrich wrote:
> Hi all!
>
>         As part of the VAMOS[0] research project at the University of
> Erlangen we are looking at multiple integrity errors in linux'
> configuration system.
>
>         I've been running a check on the drivers/scsi sourcetree for
> config Items not defined in Kconfig and found such a case. Sourcecode
> blocks depending on these Items are not reachable from a vanilla
> kernel -- dead code. I've seen such dead blocks made on purpose
> e.g. while integrating new features into the kernel but generally
> they're just useless.
>
> I encountered, that the CONFIG_SCSI_G_NCR5380_MEM symbol in
> drivers/scsi/g_NCR5380.c isn't defined anywhere. So this codeblocks
> seems to be unreachable. But there is a define in g_NCR5380_mmio.c for
> SCSI_G_NCR5380_MEM with an include of g_NCR5380.c. So i think this is a
> typo-bug and it should be a CONFIG_ define. The code wasn't changed since
> linux is in git, so probably no one has used the mmio module, cause
> there can't be a difference to the normal pio module. If you think this
> ifdefs should be removed, i can send a patch.

I fixed this some time ago but the patches are still not in mainline. You can 
find them in -mm tree: http://userweb.kernel.org/~akpm/mmotm/

-- 
Ondrej Zary
