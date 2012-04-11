Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab2DKMVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 08:21:03 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63074 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760124Ab2DKMVA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 08:21:00 -0400
MIME-Version: 1.0
In-Reply-To: <201204070906.HHC13855.QOSFVOMtFFLJOH@I-love.SAKURA.ne.jp>
References: <201204011221.GAG51016.JQFSFFOtLOMVHO@I-love.SAKURA.ne.jp>
 <CA+1xoqe+T=iUtUeFdeqmRvMZ7TMCgkLs_1QYv-4YNtn-jCoMCQ@mail.gmail.com>
 <201204052329.EBH52139.FFOLQMOJSVHOFt@I-love.SAKURA.ne.jp>
 <201204062044.EJE13062.OLMQtSVFHOFOJF@I-love.SAKURA.ne.jp>
 <20120406180905.GA10835@llnl.gov> <201204070906.HHC13855.QOSFVOMtFFLJOH@I-love.SAKURA.ne.jp>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 11 Apr 2012 14:20:40 +0200
Message-ID: <CA+1xoqd0JJ-Z+hmwgdZkBiu1anEh6iz1jJboULPp-drUzO37Ew@mail.gmail.com>
Subject: Re: ipv6: tunnel: hang when destroying ipv6 tunnel
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: garlick@llnl.gov, ericvh@gmail.com, oleg@redhat.com,
        eric.dumazet@gmail.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davej@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Yes but in the unlikely event that this happens, the effect is a small
>> memory leak for the duration of the mount.  On the other hand if the
>> fid is destroyed without successfully informing the server, then
>> subsequent operations that involve new file references will fail
>> when that fid number is reused, and the mount becomes unusable.
>
> I don't know whether Sasha's problem is caused by this patch or not.
> But p9_client_clunk() is called from many functions in fs/9p/ directory.
> They are assuming that p9_client_clunk() will call p9_fid_destroy() but
> this patch is breaking that assumption. I think this is the cause of hang which
> Sasha is experiencing because Sasha's trace shows that call_usermodehelper() is
> blocked by functions in fs/9p/ directory. Seems inconsistency state problem.

I'd be happy to try out any other patches or help debugging this issue.

Which behavior did this patch fix exactly? can I just revert it and
try running without it?
