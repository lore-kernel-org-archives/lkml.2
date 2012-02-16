Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab2BPX1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 18:27:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903Ab2BPX1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 18:27:34 -0500
Message-ID: <4F3D90E1.6010001@redhat.com>
Date: Thu, 16 Feb 2012 15:27:29 -0800
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org, esandeen@redhat.com
Subject: Re: Corrupted files after suspend to disk
References: <AANLkTinRC1hXvaXDVV5pOA4YyCdXwAjziZsDzm=LuHqK@mail.gmail.com> <AANLkTinewk=mJZifVxEJkCtKfNauOjHnLAqwbGn139C=@mail.gmail.com> <AANLkTikui_HQ5JMcMJUqMr9WLyTRNzF-z4G7wAUNPOFy@mail.gmail.com> <201103242330.14416.rjw@sisk.pl> <CAFLxGvzzHDRma_Y_XEpOD+fY+vonbkoR1mvQp4Vb4c3M6fTsPA@mail.gmail.com> <20120216163030.GA32651@redhat.com>
In-Reply-To: <20120216163030.GA32651@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/12 8:30 AM, Dave Jones wrote:
> On Thu, Feb 16, 2012 at 11:52:27AM +0100, richard -rw- weinberger wrote:
>  
>  > >> >> Of course, please test the above separately. :-)
>  > >> >
>  > >> > Ok, I'll test this when I'm at home.
>  > >> >
>  > >> > BTW: dropping the caches helps, when some files seem corrupted.
>  > >> > Today /usr/bin/okular was broken.
>  > >> > After setting vm.drop_caches=1 it worked again.
>  > >>
>  > >> On Linux 2.6.38 I'm unable to reproduce the issue.
>  > >> Only 2.6.37 seems to be affected.
>  > >> So, I'm moving over to 2.6.38. :)
>  > >
>  > Bad news:
>  > I saw the issue on 3.x too but thought it's because my IdeaPad s10 is crap.
>  > Now with my shiny new Lenovo x121e I have the same issue! :-(
>  > 
>  > OpenSUSE 12.1, kernel 3.2.7.
>  > After a few suspend2disk iterations random files are corrupted.
>  > But only cached files. A reboot solves the problem.

Just to be clear - you see _data_ corruption in files, but only
until a reboot, and after that they are ok?  Ok, reading above
about using drop_caches that sounds like the case.

That sounds different from what I saw in the bug Dave mentions
below, but possibly related root cause, I suppose.

-Eric

> FWIW, we've been seeing a number of hard to diagnose failures
> with suspend to disk for the last few releases in Fedora.
> Eric Sandeen has been chasing https://bugzilla.redhat.com/show_bug.cgi?id=744275
> for a while, but there's no smoking gun that really explains what's
> getting into these states. Further complicating things, is that it
> doesn't seem to be 100% reproducable.
> 
> 	Dave
> 

