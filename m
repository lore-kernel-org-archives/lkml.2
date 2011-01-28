Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1A1VbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 16:31:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61290 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1A1VbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 16:31:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: nbd locking problems
Date: Fri, 28 Jan 2011 22:30:53 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.5.1; x86_64; ; )
Cc: Soren Hansen <soren@linux2go.dk>, linux-kernel@vger.kernel.org,
        Dave Hansen <haveblue@us.ibm.com>
References: <AANLkTimP=5A-BNHUwV0qhvjw8y4HevMvXtOBpRr6vFYR@mail.gmail.com> <20110128211825.GA20707@mail.hallyn.com>
In-Reply-To: <20110128211825.GA20707@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101282230.53148.arnd@arndb.de>
X-Provags-ID: V02:K0:SuGgOcYFKh+nt0pg1YfInxjbVizGzkPbw3dV9IKRV0G
 jMAucWcc1aBOM3FXz3m7XLz3q+ZnqE5zGeG+GjOnCOxNOfcfAG
 2BjNKiSsLhZbNfzvABzG1ZM7o4Dv9gEG74HNtW7b2nNNkltWc0
 5FsLTAH5g5yxeC/99oHPJBdZv29KgT8zvOshqF3phBRWpGwIOQ
 IIndeKNApa/7GpXZ9UfnQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 January 2011 22:18:26 Serge E. Hallyn wrote:
> As Dave just explained to me, BKL is released when you sleep :)  I
> assume that's how it gets released around the kthread_create().  I
> think you're right that the new mutex is superfluous, but I'd like to
> look through the ioctl code and make sure there's no shared state which
> we need to protect.  I don't see how there could be, or rather, if there
> were, then it was broken before.

Good analysis. The mass-conversion from BKL to per-driver mutex indeed
assumes that no ioctl blocks for an indefinite amount of time, as nbd
evidently does. I think it's quite likely that the nbd driver does not
require any sort of locking to replace the BKL, it certainly seems
to have reasonable locking rules by itself, the ioctl function got
the BKL only because of an earlier push down from the global VFS ioctl
function.

	Arnd
