Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab1HJM7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:59:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075Ab1HJM7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:59:40 -0400
Message-ID: <4E4280BA.9050109@suse.cz>
Date: Wed, 10 Aug 2011 14:59:38 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
References: <1312067499.22074.59.camel@i7.infradead.org> <1312067670.22074.61.camel@i7.infradead.org> <CACqU3MV460WGjmQdOOmhk3ZJT1FNjEjfuHqx8mYcgun9+7SfjA@mail.gmail.com> <4E34998D.8060806@zytor.com> <CACqU3MWn-OQVfLH96E+AeTCEjUw5+girXbuNgmUvXrEQuBe4vg@mail.gmail.com> <4E4140B3.7090802@suse.cz> <CACqU3MU4wJb3ij6skod-ZiM+Q0OMTXNdbJ+qWjJW8VZNEP+x1g@mail.gmail.com>
In-Reply-To: <CACqU3MU4wJb3ij6skod-ZiM+Q0OMTXNdbJ+qWjJW8VZNEP+x1g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9.8.2011 17:26, Arnaud Lacombe wrote:
> On Tue, Aug 9, 2011 at 10:14 AM, Michal Marek <mmarek@suse.cz> wrote:
>> On 31.7.2011 02:05, Arnaud Lacombe wrote:
>>> Because kconfig might not be ran exclusively from a fully controlled
>>> and restricted environment ? Not to mention that it is used by other
>>> people than the linux kernel folks.
>>
>> Well, it has always been possible to trick kbuild (not kconfig) into
>> accepting CONFIG_* options from environment, because unset kconfig options
>> in auto.conf are not seen by make. Of course this is completely fragile,
>> because there is no dependency checking and such variables are only seen by
>> make and do not appear in autoconf.h. So a patch that teaches kconfig to
>> read options from the environment would actually make some (albeit currently
>> "illegal") use cases work correctly :).
>>
> kconfig can already set symbol value from the environment. The only
> limitation I can see is that it is not optional and require an
> explicit environment variable name.

I wasn't talking about the env= syntax, but about

make CONFIG_EXT2_FS=m all
which makes kbuild visit fs/ext2 even if CONFIG_EXT2_FS is disabled in
.config. With no update of the configuration or checking the dependencies.

Hm, actually this would be a problem even if kconfig does read the
CONFIG_* variables from the environment, because it could result in a
mismatch if kconfig determines that the variable cannot be set, but make
still sees it in the environment. So we would have to use 'undefine
CONFIG_FOO' instead of '# CONFIG_FOO is not set' in
include/config/auto.conf, to be able to properly support make CONFIG_FOO=y.

Michal
