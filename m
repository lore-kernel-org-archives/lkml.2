Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab2FSAdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 20:33:45 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:51868 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752946Ab2FSAdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 20:33:43 -0400
Message-ID: <4FDFC8D1.90003@xenotime.net>
Date: Mon, 18 Jun 2012 17:33:21 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Jun 18 (kmsg problems)
References: <20120618165336.48345227c6b64c314326ae57@canb.auug.org.au>	 <4FDF61A7.3050601@xenotime.net>	 <20120619080109.b28055c1b32fb81027a9562b@canb.auug.org.au>	 <20120618221535.GA13037@kroah.com>	 <CAPXgP10sBkwLnhDmu6UG9yVaiXG+8UYGkBEOVzUp3H+468J03w@mail.gmail.com> <1340058777.1572.35.camel@foo>
In-Reply-To: <1340058777.1572.35.camel@foo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 03:32 PM, Kay Sievers wrote:

> On Tue, 2012-06-19 at 00:17 +0200, Kay Sievers wrote:
>> On Tue, Jun 19, 2012 at 12:15 AM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>> On Tue, Jun 19, 2012 at 08:01:09AM +1000, Stephen Rothwell wrote:
>>>> [Adding Greg and Kay]
>>>>
>>>> On Mon, 18 Jun 2012 10:13:11 -0700 Randy Dunlap <rdunlap@xenotime.net> wrote:
>>>>>
>>>>> arch/x86/kernel/reboot.o: In function `kmsg_dump_get_line':
>>>>> reboot.c:(.text+0xf0): multiple definition of `kmsg_dump_get_line'
>>>>> arch/x86/kernel/setup.o:setup.c:(.text+0x0): first defined here
>>>>> arch/x86/kernel/reboot.o: In function `kmsg_dump_get_buffer':
>>>>> reboot.c:(.text+0x100): multiple definition of `kmsg_dump_get_buffer'
>>>>> arch/x86/kernel/setup.o:setup.c:(.text+0x10): first defined here
>>>>> arch/x86/kernel/reboot.o: In function `kmsg_dump_rewind':
>>>>> reboot.c:(.text+0x110): multiple definition of `kmsg_dump_rewind'
>>>>> arch/x86/kernel/setup.o:setup.c:(.text+0x20): first defined here
>>>>
>>>> Caused by commit e2ae715d66bf ("kmsg - kmsg_dump() use iterator to
>>>> receive log buffer content") from the driver-core.current tree.
>>>
>>> I'm building my tree right now, and I can't seem to hit this.
>>>
>>>> This was reported a few days ago.  Why is it not fixed yet?
>>>
>>> It was reported Friday evening, on a holiday weekend for some of us, we
>>> are trying the best we can :)
>>>
>>>> Especially since it is in a branch that is supposedly "bug fixes"?
>>>
>>> It fixes up a reported problem, and we had 3 people test it and said it
>>> resolved the issue for them, no build problems reported.
>>>
>>> Randy, can I get a copy of your .config that duplicates this?
>>
>> I looked at it, and did not see it, I was blind.
>>
>> We just miss the "static inline" in include/linux/kmsg_dump.h. :)
> 
> From: Kay Sievers <kay@vrfy.org>
> Subject: kmsg - kmsg_dump() fix CONFIG_PRINTK=n compilation


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.


> 
> Signed-off-by: Kay Sievers <kay@vrfy.org>
> ---
>  include/linux/kmsg_dump.h |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> --- a/include/linux/kmsg_dump.h
> +++ b/include/linux/kmsg_dump.h
> @@ -71,19 +71,19 @@ static inline void kmsg_dump(enum kmsg_d
>  {
>  }
>  
> -bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
> -			  const char *line, size_t size, size_t *len)
> +static inline bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
> +				const char *line, size_t size, size_t *len)
>  {
>  	return false;
>  }
>  
> -bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
> -			    char *buf, size_t size, size_t *len)
> +static inline bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
> +					char *buf, size_t size, size_t *len)
>  {
>  	return false;
>  }
>  
> -void kmsg_dump_rewind(struct kmsg_dumper *dumper)
> +static inline void kmsg_dump_rewind(struct kmsg_dumper *dumper)
>  {
>  }
>  
> 



-- 
~Randy
