Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab0CROGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:06:54 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:43322 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab0CROGx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:06:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZJ667PHTDvWHUj6pnhmXmHXtVvgoC35cL9EOvZyaDpDHmy5FfWgYpcYw/QoVNSDSKt
         EpPpEqM7G3imYAUVNoSJ+eHMguXdZWEF5w+fg0E6XlkaMb+y3C7NZ1iDqhP/4yBjpYKt
         RWYxs1IMR2hirykmhr+Zo7YVFxyoRKV7AUnpk=
MIME-Version: 1.0
In-Reply-To: <20100318135944.GD25642@elte.hu>
References: <20100318085607.GB2157@elte.hu> <20100318101025.GA13073@elte.hu>
	 <4BA1FEB0.7000400@redhat.com> <20100318113527.GA13168@elte.hu>
	 <y0m4okdzu4z.fsf@fche.csb> <20100318130226.GB7424@elte.hu>
	 <4BA22663.7070509@redhat.com> <20100318133124.GA25642@elte.hu>
	 <20100318134457.GH22775@redhat.com> <20100318135944.GD25642@elte.hu>
Date: Thu, 18 Mar 2010 15:06:51 +0100
X-Google-Sender-Auth: dd725b3568b667f7
Message-ID: <520f0cf11003180706o3bc74165y2da989f6036c8c82@mail.gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single 
	project
From: John Kacur <jkacur@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Daniel P. Berrange" <berrange@redhat.com>, Avi Kivity <avi@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Alexander Graf <agraf@suse.de>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Fr?d?ric Weisbecker" <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 2:59 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Daniel P. Berrange <berrange@redhat.com> wrote:
>
>> On Thu, Mar 18, 2010 at 02:31:24PM +0100, Ingo Molnar wrote:
>> >
>> > * Avi Kivity <avi@redhat.com> wrote:
>> >
>> > > On 03/18/2010 03:02 PM, Ingo Molnar wrote:
>> > > >
>> > > >> [...] What users eagerly replace their kernels?
>> > > >
>> > > > Those 99% who click on the 'install 193 updates' popup.
>> > > >
>> > >
>> > > Of which 1 is the kernel, and 192 are userspace updates (of which one may be
>> > > qemu).
>> >
>> > I think you didnt understand my (tersely explained) point - which is probably
>> > my fault. What i said is:
>> >
>> >  - distros update the kernel first. Often in stable releases as well if
>> >    there's a new kernel released. (They must because it provides new hardware
>> >    enablement and other critical changes they generally cannot skip.)
>> >
>> >  - Qemu on the other hand is not upgraded with (nearly) that level of urgency.
>> >    Completely new versions will generally have to wait for the next distro
>> >    release.
>>
>> This has nothing todo with them being in separate source repos. We could
>> update QEMU to new major feature releaes with the same frequency in a Fedora
>> release, but we delibrately choose not to rebase the QEMU userspace because
>> experiance has shown the downside from new bugs / regressions outweighs the
>> benefit of any new features.
>>
>> The QEMU updates in stable Fedora trees, now just follow the minor bugfix
>> release stream provided by QEMU & those arrive in Fedora with little
>> noticable delay.
>
> That is exactly what i said: Qemu and most user-space packages are on a
> 'slower' update track than the kernel: generally updated for minor releases.
>
> My further point was that the kernel on the other hand gets updated more
> frequently and as such, any user-space tool bits hosted in the kernel repo get
> updated more frequently as well.
>
> Thanks,
>
>        Ingo

Just to play devil's advocate, let's not mix up the development model with the
distribution model. There is nothing to stop packagers and distributors from
providing separate kernel "proper" packages and perf tools packages.

It might even make good sense assuming backwards compatibility for distros
that have conservative policies about new kernel versions to provide newer
perf tools packages with older kernels.

John
