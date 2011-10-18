Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab1JRTBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 15:01:04 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:57755 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753020Ab1JRTBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 15:01:03 -0400
Message-ID: <4E9DCCEC.4090105@xenotime.net>
Date: Tue, 18 Oct 2011 12:01:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Michal Schmidt <mschmidt@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] params: make dashes and underscores in parameter names
 truly equal
References: <1318197817-20964-1-git-send-email-mschmidt@redhat.com> <8739exg588.fsf@rustcorp.com.au> <4E96F887.5050103@redhat.com> <87obxfq7bd.fsf@rustcorp.com.au>
In-Reply-To: <87obxfq7bd.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2011 08:58 PM, Rusty Russell wrote:
> On Thu, 13 Oct 2011 16:41:11 +0200, Michal Schmidt <mschmidt@redhat.com> wrote:
>> On 10/13/2011 01:28 AM, Rusty Russell wrote:
>>>          Idea is solid, implementation has a few quirks.  As the name
>>> obsolete_checksetup() implies, this was only supposed to be a crutch for
>>> old __setup() calls.  Modern code should be using module_param() or
>>> core_param().
>>
>> ... instead of __setup()?
> 
> Yep.
> 
>> No objection to the change in do_early_param() ?
> 
> Well, for the moment I've applied that, with parameq and parameqn
> reimplemented more cleanly.  See below.
> 
>>> Did you have a specific example?
>>
>> The specific example I had in mind was the one from 
>> Documentation/kernel-parameters.txt:
>>
>>            log_buf_len=1M print-fatal-signals=1
>>    can also be entered as
>>            log-buf-len=1M print_fatal_signals=1
> 
> Oops.
> 
>> Let's see how many __setup() parameters there are:
>> $ git grep -E '^__setup\("' |wc -l
>> 457
>>
>> Only the ones with a dash or underscore in the name:
>> $ git grep -E '__setup\(".*[_-].*"' | wc -l
>> 180
>>
>> It will take some time.
> 
> The easy things have already been done ;)
> 
> Just do the non-arch ones, first, and see where that gets us.
> 
> Thanks!
> Rusty.
> 
> From: Michal Schmidt <mschmidt@redhat.com>
> Subject: params: make dashes and underscores in parameter names truly equal
> Date: Mon, 10 Oct 2011 00:03:37 +0200
> 
> The user may use "foo-bar" for a kernel parameter defined as "foo_bar".
> Make sure it works the other way around too.
> 
> Apply the equality of dashes and underscores on early_params and __setup
> params as well.
> 
> The example given in Documentation/kernel-parameters.txt indicates that
> this is the intended behaviour.

Well, that could have just been my misunderstanding, but I think that this
patch is the right thing to do.  Thanks.

> With the patch the kernel accepts "log-buf-len=1M" as expected.
> https://bugzilla.redhat.com/show_bug.cgi?id=744545
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (neatened implementations)
> ---
>  include/linux/moduleparam.h |   20 ++++++++++++++++++++
>  init/main.c                 |    4 ++--
>  kernel/params.c             |   21 ++++++++++++++-------
>  3 files changed, 36 insertions(+), 9 deletions(-)


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
