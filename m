Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525Ab1CDOlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:41:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58531 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab1CDOlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 09:41:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=MNViEwN7NegO+GvC7pfjnC4Fq6A29k2lTsTgEjsedWMhLFOQ1rJ+64OGDD+u0cesB3
         s8UYbAHVBDCaGaECUxGH7mynPGNf4us8b8zyoMZlIwodL29+7B16ZWw81dfCiwsj18Vr
         NVCzSAF9UfsMbL4pEE5DPZ0puyyjsqeSxPpzI=
Date: Fri, 4 Mar 2011 15:40:59 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110304144059.GS20499@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110303173422.GA27960@redhat.com>
 <20110303202246.GB32152@redhat.com>
 <AANLkTikeCzr-OGkmaaortS7_rR+JCM9B6aJV0c52EMbE@mail.gmail.com>
 <20110304134126.GL20499@htj.dyndns.org>
 <AANLkTikLd2Kg9Pz+5eLd_irdxoKdrR9qPj8yixeTfvaM@mail.gmail.com>
 <20110304140745.GP20499@htj.dyndns.org>
 <AANLkTina7D3QffUK7vYvc3aVTvbcJQqm8VgQP3xJKYdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTina7D3QffUK7vYvc3aVTvbcJQqm8VgQP3xJKYdw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 03:31:15PM +0100, Denys Vlasenko wrote:
> On Fri, Mar 4, 2011 at 3:07 PM, Tejun Heo <tj@kernel.org> wrote:
> > Hello,
> >
> > On Fri, Mar 04, 2011 at 02:59:32PM +0100, Denys Vlasenko wrote:
> >> I would rather speed strace up than slow it down further, even if
> >> slightly.
> >
> > The question to ask is at what cost?  If mostly unnoticeable slow down
> > makes the API cleaner, I'll go that way.  Everything is a tradeoff.
> 
> # time sh -c 'ls -lR /usr/share >/dev/null'
> real	0m2.633s
>
> strace without PTRACE_GETSIGINFO:
> real	0m47.023s
> real	0m48.799s
> real	0m47.695s
>
> strace with PTRACE_GETSIGINFO:
> real	0m51.958s
> real	0m53.773s
> real	0m51.625s

Great, numbers, so it's ~10 slow down.  Gees, with or without that
change, strace(2) is heavy, >18 times slower than without.  Maybe it
should give up on ptrace and use the new tracing infrastructure?

Anyways, thanks a lot for the numbers.  Much appreciated.

-- 
tejun
