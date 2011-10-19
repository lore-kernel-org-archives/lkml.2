Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab1JSExY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:53:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40541 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754406Ab1JSExX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:53:23 -0400
MIME-Version: 1.0
In-Reply-To: <1318996839.6222.20.camel@marge.simson.net>
References: <1316758874.7393.2.camel@marge.simson.net> <4E7C2E7F.40307@cn.fujitsu.com>
 <1316762345.8168.4.camel@marge.simson.net> <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
 <1316770936.6641.11.camel@marge.simson.net> <1316775204.7562.9.camel@marge.simson.net>
 <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
 <1316788392.6544.33.camel@marge.simson.net> <1318224892.6161.45.camel@marge.simson.net>
 <1318233815.6527.5.camel@marge.simson.net> <1318925436.9641.23.camel@marge.simson.net>
 <1318927355.21167.3.camel@twins> <1318927629.9641.27.camel@marge.simson.net>
 <1318928763.21167.5.camel@twins> <1318929825.9641.32.camel@marge.simson.net>
 <1318932693.6748.5.camel@marge.simson.net> <alpine.DEB.2.00.1110181336150.2639@chino.kir.corp.google.com>
 <1318996839.6222.20.camel@marge.simson.net>
From: Paul Menage <paul@paulmenage.org>
Date: Tue, 18 Oct 2011 21:53:03 -0700
X-Google-Sender-Auth: 1ZGfEqJiP2KIZc64ExvyrtdQ-34
Message-ID: <CALdu-PA7+bygEP-44XB8evaTrsZiDopc-24SmUV+0NbiA=sHNw@mail.gmail.com>
Subject: Re: patch] cpusets, cgroups: disallow attaching kthreadd
To: Mike Galbraith <efault@gmx.de>
Cc: David Rientjes <rientjes@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 9:00 PM, Mike Galbraith <efault@gmx.de> wrote:
>
> Oh my, I can't win.
>
> Either of the two patchlets will do the trick, so maintainer's choice.
>

I agree with your original idea - if it's just some cgroup subsystems
that are unsafe to have kthreadd in, then they can make that choice.

Otherwise you restrict things unnecessarily. E.g. a systemd-alike
might have a tracking hierarchy (without any subsystems attached,
potentially) and want to keep the top-level empty and have all kernel
threads their own cgroup. There's absolutely no problem with that.

I can see the argument that the number of use-cases for this is fairly
small, but in line with the principle of keeping the ABI as stable as
possible in the absence of bugs that force a change, having the
restriction in the necessary subsystems seems cleaner.

Paul
