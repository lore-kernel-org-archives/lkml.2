Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386Ab0KPOls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:41:48 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52163 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab0KPOlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:41:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZaOFeATtRgby+KL/VbahE9t4/PqJNEfSpBYwFIHKFsPF4XI77scekg9utuXdr0urAS
         nhmG9F94/BJRh5kUl4osodWHWoBsYCgDuk2LdTUWu9UzGF9V/NWpIb3d3kpL0PzAAvew
         yD0dBWZLl4jBMORtMsk1G4yRnGyzOj9Aq0l+Y=
MIME-Version: 1.0
In-Reply-To: <1289900042.27424.253.camel@debian>
References: <1289900042.27424.253.camel@debian>
Date: Tue, 16 Nov 2010 20:38:33 +0600
Message-ID: <AANLkTi=OK+B537S5D8H4=yV5zC8+RksnfYgoKsqEyk5+@mail.gmail.com>
Subject: Re: [performance bug] volanomark regression on 37-rc1
From: Rakib Mullick <rakib.mullick@gmail.com>
To: "Alex,Shi" <alex.shi@intel.com>
Cc: ncrao@google.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        linux-kernel@vger.kernel.org, "Chen, Tim C" <tim.c.chen@intel.com>,
        zheng.z.yan@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/10, Alex,Shi <alex.shi@intel.com> wrote:
> When do performance testing on 37-rc1 kernel on Core2 machines, we find
> the volanomark loopback performance drop about 30%, that due to
> commit:fab476228ba37907ad7
>
Was that test was made before and after applying above commit? Would
love to know, how did you find that commit (I mean was it a git
bisection)?

> Volanomark link: http://www.volano.com/benchmarks.html
> Our volanomark testing parameters as following:
> "-count 25000 -rooms 10 "
> JVM is jrockit-R27.3.1-jre1.5.0_11
> java_options is "-Xmx1500m -Xms1500m -Xns750m -XXaggressive -Xlargepages
> -XXlazyUnlocking -Xgc:genpar -XXtlasize:min=16k,preferred=64k"
> and we set /proc/sys/kernel/sched_compat_yield as "1".
>
> We find if with the following patch, the regression can be recovered.
>

What are the VolanoMark test results, after and before applying this patch?

>
> It seems some of load_balance() is not necessary that caused by avg_idle
> setting. But do not know more details of the volano running. Anyone like
> to give a comments for this issue?
>
Does VolanoMark is used for scheduler benchmarking? If I'm not wrong,
I don't think it directly relates to scheduler benchmarking.

> Ncrao, I have no idea of your benchmarks, but just guess removing the
> avg_idle setting won't bring much wakeup delay for tasks. Could you like
> to show some data of this?
>
> The vmstat output for .36 and .37-rc1 kernel as below:

You are showing the output of .36 and .37-rc1. If Ncrao's commit is
guilty for this performance regression, then what are the results of
before and after applied Ncrao's commit. Then, what are the result
after applying your patch. You are showing vmstat output of .36 and
.37-rc1, which really doesn't prove the point of your patch. It needs
to be more clearer.


thanks,
rakib


> Regards
> Alex
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
