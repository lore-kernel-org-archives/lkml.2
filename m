Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888Ab0JFLnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 07:43:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33852 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752584Ab0JFLnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 07:43:03 -0400
Subject: Re: linux-next: build warnings after merge of the kbuild-current
 tree
From: Catalin Marinas <catalin.marinas@arm.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>
In-Reply-To: <4CAC59D4.5010505@suse.cz>
References: <20101006114433.4fbe86ef.sfr@canb.auug.org.au>
	 <4CAC59D4.5010505@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Wed, 06 Oct 2010 12:42:43 +0100
Message-ID: <1286365363.4281.5.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2010 11:42:44.0097 (UTC) FILETIME=[97071F10:01CB654B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-06 at 12:13 +0100, Michal Marek wrote:
> On 6.10.2010 02:44, Stephen Rothwell wrote:
> > After merging the kbuild-current tree, today's (and yesterday's)
> > linux-next build (x86_64 allmodconfig and other builds as well) produced
> > these warnings:
> >
> > warning: [...] selects I2C_ALGOBIT which has unmet direct dependencies (I2C && !I2C_HELPER_AUTO)
> > [...]
> > warning: [...] selects VIDEO_TVAUDIO which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C)
> >
> > After reverting commit ff5ff6060bf880aac233e68dd666cbe9e39ec620
> > ("kconfig: delay symbol direct dependency initialization") it produces no
> > such warnings.
> 
> I'm aware of them. I'm talking with Jean Delvare about fixing the I2C
> warnings, see http://lkml.org/lkml/2010/10/5/83. The drivers/media/video
> warnings will need the same care. I don't know if we manage to fix these
> in time, so maybe the kconfig fix will have to way for 2.6.36.1.

The kconfig commit ff5ff6060 fixes a bug with commit 246cf9c26 which was
using some structures after they were freed. Because of the bug, it just
happened that it wasn't showing these kconfig warnings. A worst thing is
kbuild segfaulting or getting into an infinite loop (as reported/fixed
by Arnaud).

I think the above commit is still needed before 2.6.36 and maybe push a
drivers/media/video warnings in 2.6.36.1.

Thanks.

-- 
Catalin

