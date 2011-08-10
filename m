Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1HJOeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:34:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59329 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab1HJOeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:34:21 -0400
MIME-Version: 1.0
In-Reply-To: <1312985888.2989.46.camel@i7.infradead.org>
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
Date: Wed, 10 Aug 2011 10:34:19 -0400
Message-ID: <CACqU3MXozgu0kr-4w=bGejcEi8MrxH-PhKa0Ji0zrLu7ZEFomg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: Arnaud Lacombe <lacombar@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 10:17 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Wed, 2011-08-10 at 10:15 -0400, Arnaud Lacombe wrote:
>>
>> hum, let's take a real life example: user foo wants his config to
>> enable CONFIG_WIRELESS_EXT, so with what you propose, he would do:
>>
>> # make CONFIG_WIRELESS_EXT=y allmodconfig
>>
>> currently, this would _never_ work, unless one of the symbol selected
>> by `allmodconfig' selects it, as WIRELESS_EXT is defined the
>> following:
>>
>> config WIRELESS_EXT
>>     bool
>>
>> I suspect there also an implicit dependency to WIRELESS.
>
> This is a complete red herring. It's *always* been like that, and works
> *just* like this for the 'all.config' file etc.
>
your point being ? I might as well tell you that I find the current
behavior of 'all*.config' just as broken wrt. to dependency
management.

> If you have nothing relevant to say, just don't say anything.
>
maybe you can come with a detailed description of your proposal's
behavior, including how to manage case like this, instead of just
throwing patch around ?

If I do:

# make CONFIG_WIRELESS_EXT=y allnoconfig

I expect either a success or an error, not a silent discard. And
*yes*, the problem already exists with "all*.config".

Thanks,
 - Arnaud
