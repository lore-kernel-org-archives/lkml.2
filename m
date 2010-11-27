Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751002Ab0K0Fen (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 00:34:43 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45917 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab0K0Fek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 00:34:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AdPQqg+eXc/kyIWR2yHZJwdA2zPy9HgKuKyuDvrFu9Mp7mlE7ZSAo3EvefcGN9xHuc
         Ny01Te0cuIWVXSth9b84o1fXs670rWVQdIij+YwO75m5bdzBE7YqxAfpWR2KUFEIIcwG
         1NXoya26yt0fL9bSyPKqhjWCQPc8JeA5uLVcA=
MIME-Version: 1.0
In-Reply-To: <4CEFD2BA.5090403@kernel.org>
References: <4CEFD2BA.5090403@kernel.org>
Date: Sat, 27 Nov 2010 00:34:39 -0500
Message-ID: <AANLkTimidOhwXPNwrCCS0HqiOrmzeLC14+bCuWgKj0vJ@mail.gmail.com>
Subject: Re: Possible FPU context corruption w/ CONFIG_PREEMPT
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Robert Richter <robert.richter@amd.com>,
        Dan Carpenter <error27@gmail.com>, Avi Kivity <avi@redhat.com>,
        Bernd Machenschalk <Bernd.Machenschalk@aei.mpg.de>,
        Heinz-Bernd Eggenstein <hbeggenst@aol.com>,
        Oliver Bock <oliver.bock@aei.mpg.de>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 10:31 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, guys.
>
> Heinz-Bernd Eggenstein reports a possible FPU context corruption w/
> CONFIG_PREEMPT.  Please take a look at the following forum post.
>
>  http://einstein.phys.uwm.edu/forum_thread.php?id=8516
>
> openSUSE 11.3 desktop kernel which has CONFIG_PREEMPT set is
> triggering SIGFPE while the default kernel w/o preemption works fine.
> He also notes that a similar bug was fixed in 2008 by commit 06c38d5e
> (x86-64: fix FPU corruption with signals and preemption) from Suresh.
> Does it ring anyone's bell?
>
> Heinz, is there a simple procedure to reproduce the problem, or would
> it be possible to lure you into bisection?
>
> Thanks.
>

This might be fixed by commit a4d4fbc7735bba6654b20f859135f9d3f8fe7f76
(Disable preemption when using TS_USEDFPU).

--
Brian Gerst
