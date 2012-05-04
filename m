Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab2EDDB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 23:01:56 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60557 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab2EDDBz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 23:01:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120504024706.GA10461@kroah.com>
References: <20120503215748.GA18995@kroah.com>
	<87sjfgafqj.fsf@sejong.aot.lge.com>
	<20120503.215020.954262287222794218.davem@davemloft.net>
	<CACqU3MVqpz=azeUOUfmtoLEPvqngfJHSHFe7ujemeRT1-B=osA@mail.gmail.com>
	<CACqU3MWLKMhTdh-HUh0MhE_hZmwNPG5FOxWarjO4BsRemmG8sA@mail.gmail.com>
	<CACqU3MVVgo7R8CmGwi6utE0F0urf5NW58s23bmNU_rSQAg2pww@mail.gmail.com>
	<20120504024706.GA10461@kroah.com>
Date: Thu, 3 May 2012 23:01:54 -0400
Message-ID: <CACqU3MUwDaRXwAd3fu7sUmM2ApH+pfu4rf1-TNKt1ja+wYpJ9w@mail.gmail.com>
Subject: Re: perf build failure on Linus's tree
From: Arnaud Lacombe <lacombar@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: David Miller <davem@davemloft.net>, namhyung.kim@lge.com,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, jolsa@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 3, 2012 at 10:47 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, May 03, 2012 at 10:35:02PM -0400, Arnaud Lacombe wrote:
>> Hi,
>>
>> On Thu, May 3, 2012 at 10:29 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> > [...]
>> > [0]: http://pkgs.fedoraproject.org/gitweb/?p=flex.git;a=blob;f=flex-2.5.35-hardening.patch;h=7d608ea2371fa3295bdb8eb97c15eeb03029c02b;hb=HEAD
>> >
>> as a side note, this patch sounds more being about "silencing" than
>> "hardening"...
>
> That's nice, but I can build the perf version in 3.3 just fine, so
> something broke here (hint, build regression.)  Do I have to bisect it
> down to find the problem?
>
there is most likely nothing to bisect, `perf' seems to have never
required any parser before 3.4. The way the rest of the tools
(especially `kconfig', `genksyms' and `dtc') manage parsers is via
pre-generated .[ch]_shipped version of the lexer/tokenizer. It's been
working well for a long time as such. `perf' will certainly have to
follow the same path.

 - Arnaud
