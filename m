Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab1DVICQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 04:02:16 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42255 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1DVICL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 04:02:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=p4NHi/8+rCdYOVR52zzdWz4GKIsjv4l32Y0aGIA8nfXSqal+0ebouwHfDXYIbNNIuj
         2p76uZHRQe2RhcJ2A3nm+h595IeaibDUJXRNL7nAFz7U65uu1nDZN84vAmZX6rDN51Gc
         dVwxSVnuxCOsWB7nUTZF5mzbyyxblC/OqH/P8=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1104211505320.20201@chino.kir.corp.google.com>
References: <1303317178.2587.30.camel@mulgrave.site>
	<alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com>
	<20110421220351.9180.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1104211500170.5741@router.home>
	<alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com>
	<1303421088.4025.52.camel@mulgrave.site>
	<alpine.DEB.2.00.1104211431500.20201@chino.kir.corp.google.com>
	<1303422566.4025.56.camel@mulgrave.site>
	<alpine.DEB.2.00.1104211505320.20201@chino.kir.corp.google.com>
Date: Fri, 22 Apr 2011 11:02:10 +0300
X-Google-Sender-Auth: EzMQv4fhrM7E-Nc-g97-JR-FsVc
Message-ID: <BANLkTi=JGeWiFm-9H-2vHDsU1v7ykDt1UA@mail.gmail.com>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to expand_upwards
From: Pekka Enberg <penberg@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        x86 maintainers <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 1:12 AM, David Rientjes <rientjes@google.com> wrote:
>> > diff --git a/init/Kconfig b/init/Kconfig
>> > index 56240e7..a7ad8fb 100644
>> > --- a/init/Kconfig
>> > +++ b/init/Kconfig
>> > @@ -1226,6 +1226,7 @@ config SLAB
>> >           per cpu and per node queues.
>> >
>> >  config SLUB
>> > +       depends on BROKEN || NUMA || !DISCONTIGMEM
>> >         bool "SLUB (Unqueued Allocator)"
>> >         help
>> >            SLUB is a slab allocator that minimizes cache line usage
>>
>>
>> I already sent it to linux-arch and there's been no dissent; there have
>> been a few "will that fix my slub bug?" type of responses.
>
> I was concerned about tile because it actually got all this right by using
> N_NORMAL_MEMORY appropriately and it uses slub by default, but it always
> enables NUMA at the moment so this won't impact it.
>
> Acked-by: David Rientjes <rientjes@google.com>

I'm OK with this Kconfig patch. Can someone send a proper patch with
signoffs and such? Do we want to tag this for -stable too?

                         Pekka
