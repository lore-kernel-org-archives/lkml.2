Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab0CUPhu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 11:37:50 -0400
Received: from mail-fx0-f221.google.com ([209.85.220.221]:59820 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab0CUPhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 11:37:48 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Mar 2010 11:37:48 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=c/V+aErmz2JDvIC85iWmeL0sJ1vHROzFr23JazawoiRe/lAvBYqUHJwbDsmgQo2AKw
         agzhjWqGGvABcKSaBonkKuvlNRl6qjSOwks8mmDxC9p4tR4pu66XJgNxGBbfnzqHBCSe
         kOjtoPiYP253YoQVa/yk/bIKsMwD+gQOteSwI=
MIME-Version: 1.0
In-Reply-To: <20100321135836.GA11661@zhen-devel.sh.intel.com>
References: <1268258994.2183.14.camel@carter>
	 <ca2dc2821003102331x3d1a7a0fgadb63612e49f77db@mail.gmail.com>
	 <20100311083404.GG6896@zhen-devel.sh.intel.com>
	 <ca2dc2821003110754r65ab170at39a61fb11fa285e0@mail.gmail.com>
	 <20100319132723.118cc16a.akpm@linux-foundation.org>
	 <ca2dc2821003200604m7c8cdea4r64ab8c98e7ec8242@mail.gmail.com>
	 <20100321135836.GA11661@zhen-devel.sh.intel.com>
Date: Sun, 21 Mar 2010 16:30:20 +0100
Message-ID: <ca2dc2821003210830h2025df79r477cca7d81ddd28d@mail.gmail.com>
Subject: Re: [PATCH] intel-agp.c: Fix crash when accessing nonexistent GTT 
	entries in i915
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Zhenyu Wang <zhenyuw@linux.intel.com>,
       Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       David.Woodhouse@intel.com, dwmw2@infradead.org, eric@anholt.net,
       ben@decadent.org.uk, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 21, 2010 at 2:58 PM, Zhenyu Wang <zhenyuw@linux.intel.com> wrote:
> On 2010.03.20 14:04:56 +0100, Miguel Ojeda wrote:
>> On Fri, Mar 19, 2010 at 9:27 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>> > On Thu, 11 Mar 2010 16:54:26 +0100
>> > Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
>> >
>> >> Attached dmesg, lspci -vv, config and xorg.
>> >>
>> >> When the X server crashes, the kernel does not report anything
>> >
>> > This seems to have gone all quiet?
>>
>> It seems so, I was about to ping Zhenyu.
>
> Could you try recent X.org intel driver release? Your failure X log
> showed some pretty old UMS driver's render flush time out message,
> I think whose version never has been well tested with new kms/gem stuff.
>

Sure. Debian Stable got version 2.3.

>>
>> >
>> > As this was a 2.6.32->2.6.32.4 regression, I assume that it's also a
>> > 2.6.32->2.6.33 regression?
>>
>> Yep. All kernels I tested since 2.6.32.4 crash, including 2.6.32.10,
>> 2.6.33 and 2.6.34-rc1. See my original message for more details about
>> the crash.
>>
>
> Could you bisect? I doubt it's caused by David's patch, as if it is, you
> will have trouble at early agp init time, instead of current problem looks
> like something causing rendering hang..and I can't think of how mapping GTT
> to a scratch page could cause problem in case GTT bar is truely 256K.

I bisected in order to find the commit 5877960869333e42ebeb733e8d9d5630ff96d350.

I don't know if such commit is really the true problem (does not seem
so if you are right); however, it is the commit that breaks the X
server as I stated in the original message.

>
> --
> Open Source Technology Center, Intel ltd.
>
> $gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iEYEARECAAYFAkumJgwACgkQsQQaM014GCe2cgCbB8LJnqn7n7J++lA8Pd+TfBQb
> 2BQAn2sYv0DZuSniLTcf9F3cX+cGIgVl
> =gQHY
> -----END PGP SIGNATURE-----
>
>
