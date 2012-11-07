Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab2KGEmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 23:42:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32604 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab2KGEmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 23:42:35 -0500
Message-ID: <5099E6A4.7050802@oracle.com>
Date: Wed, 07 Nov 2012 12:42:12 +0800
From: Jeff Liu <jeff.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: akpm@linux-foundation.org, aedilger@gmail.com, alan@linux.intel.com,
        arnn@arndb.de, gregkh@linuxfoundation.org, jakub@redhat.com,
        james.l.morris@oracle.com, john.sobecki@oracle.com, tytso@mit.edu,
        viro@zeniv.linux.org.uk, LKML <linux-kernel@vger.kernel.org>
Subject: Re: + binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
 added to -mm tree
References: <20121107001609.9B7A9100047@wpzn3.hot.corp.google.com> <CAGXu5jJ779UvpZwO-fi7-m+i=OfqwgXh1PC4GNwjhfD9GD82wQ@mail.gmail.com> <5099E1C7.5000007@oracle.com> <CAGXu5j+fLM4YV==xjTsS4qU+CZY_ohL2cdAcEcXBjmS2WHa6Sw@mail.gmail.com>
In-Reply-To: <CAGXu5j+fLM4YV==xjTsS4qU+CZY_ohL2cdAcEcXBjmS2WHa6Sw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 12:29 PM, Kees Cook wrote:
> On Tue, Nov 6, 2012 at 8:21 PM, Jeff Liu <jeff.liu@oracle.com> wrote:
>> Hi Andrew and Kees,
>>
>> Great thanks for both your comments!
>>
>> On 11/07/2012 09:11 AM, Kees Cook wrote:
>>> Hrm, I don't like this. get_random_int() specifically says: "Get a
>>> random word for internal kernel use only." The intent of AT_RANDOM is
>>> for userspace pRNG seeding (though glibc currently uses it directly
>>> for stack protector and pointer mangling), which is not "internal
>>> kernel use only". :) Though I suppose this is already being used for
>>> the randomize_stack_top(), but I think it'd still be better to use
>>> higher quality bits.
>> Btw Kees, does it sounds make sense if we just return the 16 bytes
>> uninitialized stack array if the user disable the stack randomize via
>> "/proc/sys/kernel/randomize_va_space = 0" or via the related sysctl, or
>> even specified norandmaps on boot?
> 
> No, I feel that ASLR (randomize_va_space) is distinctly separate from
> how glibc uses AT_RANDOM (stack protector and pointer mangling).
> AT_RANDOM should remain active even if randomize_va_space is 0.
Ok, I was confused about the semantics of ASLR, thanks for your
clarification, will post another patch soon according to your feedback.

-Jeff

