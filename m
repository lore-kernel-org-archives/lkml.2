Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab1HJWdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 18:33:45 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56199 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab1HJWdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 18:33:43 -0400
MIME-Version: 1.0
In-Reply-To: <1313002322.2989.88.camel@i7.infradead.org>
References: <1312067499.22074.59.camel@i7.infradead.org>
	<1312067670.22074.61.camel@i7.infradead.org>
	<CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com>
	<4E34998D.8060806@zytor.com>
	<CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com>
	<4E4140B3.7090802@suse.cz>
	<CACqU3MU4wJb3ij6skod-ZiM+Q0OMTXNdbJ+qWjJW8VZNEP+x1g@mail.gmail.com>
	<4E4280BA.9050109@suse.cz>
	<1312981658.2989.39.camel@i7.infradead.org>
	<CACqU3MUJkM3Y2o2Jx1eQxZkW2T-Dby1JCaks6SqTz_FB17hSvw@mail.gmail.com>
	<1312985888.2989.46.camel@i7.infradead.org>
	<CACqU3MXozgu0kr-4w=bGejcEi8MrxH-PhKa0Ji0zrLu7ZEFomg@mail.gmail.com>
	<1312993987.2989.53.camel@i7.infradead.org>
	<CACqU3MXC_eDqgWDwnVe8KsqoAMTPQNiP6YMHD5G+1sMBhMwXzA@mail.gmail.com>
	<1312999168.2989.61.camel@i7.infradead.org>
	<CACqU3MWB+4n5Acd-GboH5WbCzfZFiAc0wNvOkn_5O+--7jLE8A@mail.gmail.com>
	<1313002322.2989.88.camel@i7.infradead.org>
Date: Wed, 10 Aug 2011 18:33:42 -0400
Message-ID: <CACqU3MU2J25q-wWJ8LNcMkwi3uMigz_+0=XcrNiPC0TGiJHZqA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: Arnaud Lacombe <lacombar@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 10, 2011 at 2:52 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Wed, 2011-08-10 at 14:40 -0400, Arnaud Lacombe wrote:
>> so, at best, this buggy behavior is ~ 6 years old. Before that, I'd
>> assume that the internal namespace was not accessible by any other
>> mean than the front-ends.
>
> I've been editing .config or doing 's/.*CONFIG_FOO[= ].*/CONFIG_FOO=y/'
> on it for a decade before that. With all the same limitations as
> all.config, and my new CONFIG_FOO=y command line support.
>
> How do *you* quickly, from the command line, enable or disable a single
> option in an existing config?
>
>> > Please, if this offends you then by all means go and fix it. A sane way
>> > of handling dependencies would give a way to say "do what you need to do
>> > in order to enable CONFIG_SATA_MV", and should remove the abomination of
>> > 'select', which was introduced purely to work around that lack.
>> >
>> > But none of that is directly relevant in *this* thread.
>> >
>> to paraphrase you, I'd say, this might looks "cute but might give
>> behavior that people will come to depend on in their scripts and then
>> we take it away again", "that's why I'd kind of like to see it done
>> *once*, *properly*".
>
> That's a reasonable concern, but I think it's misplaced in this case.
> We're not enabling anything that we're later going to break. I can't see
> many people *depending* on the fact that 'make CONFIG_SATA_MV=y
> oldconfig' actually does *nothing* in some cases.
>
you are wrong, you ends up with half-baked compile-time dependency,
which break the build:

% make allnoconfig drivers/ata/

do nothing, but works.

% make CONFIG_SATA_MV=y allnoconfig drivers/ata/

tries to build `drivers/ata/sata_mv.o' and miserably fails.

[tested on top of your patches]

 - Arnaud

> When we later, hopefully, get proper dependency resolution, that will
> take something that *wasn't* working and make it work. For all.config
> and for the command line overrides (and in other places) at the same
> time.
>
> --
> dwmw2
>
>
