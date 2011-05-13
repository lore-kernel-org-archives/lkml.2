Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab1EMHxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 03:53:07 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35853 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443Ab1EMHxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 03:53:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y5yDViTrOmSUkeecw3xpGslpGbEVVjA5tH2O0ac12F3IbXXsPnJFRr0hzXKQTjfQQx
         OhCxBeoEw2wVjFRuII+RcKDjneUs+tyaPrCg94obzqnhhJG75hSBdHaebgCVkm43o8Oc
         2H0RKUs1R21DjmDw/osslQ24AtnrsJC90YxyI=
MIME-Version: 1.0
In-Reply-To: <BANLkTimCpH3Nn2XnOJUKnK=dMObj1r8KEg@mail.gmail.com>
References: <BANLkTimCpH3Nn2XnOJUKnK=dMObj1r8KEg@mail.gmail.com>
Date: Fri, 13 May 2011 15:53:04 +0800
Message-ID: <BANLkTi=ckPK3BV07n=hmwOeqFUs3mrazFQ@mail.gmail.com>
Subject: Re: Sched_autogroup and niced processes
From: Yong Zhang <yong.zhang0@gmail.com>
To: Carl-Johan Kjellander <carl-johan@klarna.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'ing more people.

On Fri, May 13, 2011 at 3:39 PM, Carl-Johan Kjellander
<carl-johan@klarna.com> wrote:
> I've been running seti@home niced to 19 in the background since 1999
> without any problems. No noticeable effect even when playing a movie
> or a game. But since 2.6.38 the new fix-all-problems automatic
> grouping has been messing a bit with me. These are some timed compiles
> on my 8 cores.
>
> time make -j12 # with seti@home running
> real    4m16.753s
> user    10m33.770s
> sys     1m39.710s
>
> time make -j12 # without seti@home running
> real    2m12.480s
> user    10m11.580s
> sys     1m39.980s
>
> echo 0 > /proc/sys/kernel/sched_autogroup_enabled
> time make -j12 # no autogroup, seti@home running again
> real    2m33.276s
> user    10m37.540s
> sys     1m43.190s
>
> All compiles already had all files cached in RAM.
>
> Now I can take the 10% performance hit, but not the 100% hit of
> running stuff super niced in the background. Processes niced to 19
> should only use spare cycles and not take up half of the cores even
> with autogroup. I would really like to run autogroup since it is a
> neat idea, but it can't mess up running niced processes in the
> background which have been working fine for 12 years.

Then how about change the nice value of seti@home->autogroup?
echo 19 > /proc/'pid of seti@home'/autogroup

Thanks,
Yong

>
> /Carl-Johan Kjellander
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Only stand for myself
