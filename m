Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab0JEQBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:01:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55237 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab0JEQBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:01:31 -0400
Message-ID: <4CAB4B9D.2020500@zytor.com>
Date: Tue, 05 Oct 2010 09:00:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>,
        akpm@linux-foundation.org, phillip@lougher.demon.co.uk,
        hsweeten@visionengravers.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] initramfs: strcpy destination string overflow
References: <cover.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com> <b6cdf32448371a89fdab2f3875ac5b32365bf518.1286193211.git.EXT-Eugeny.Kuznetsov@nokia.com> <AANLkTinoCgO56O1kPNW3vjd9Nd1kY2SU34UH2RQa9qkE@mail.gmail.com>
In-Reply-To: <AANLkTinoCgO56O1kPNW3vjd9Nd1kY2SU34UH2RQa9qkE@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2010 08:55 AM, Linus Torvalds wrote:
> On Tue, Oct 5, 2010 at 1:44 AM, Evgeny Kuznetsov
> <EXT-Eugeny.Kuznetsov@nokia.com> wrote:
>> From: Evgeny Kuznetsov <ext-eugeny.kuznetsov@nokia.com>
>>
>> Function "strcpy()" is used without check for maximum allowed
>> source string length and could cause destination string overflow.
>> "strcpy()" is replaced by "strlcpy()" to prevent destination
>> string overflow.
> 
> I think this is wrong.
> 
> If the name is too long to fit in the hash table, we should not create
> a new hash entry at all, because we'd be returning the wrong
> (truncated) name when we find it next time.
> 
> So it would be much better to just do
> 
>    if (strlen(name) >= sizeof(q->name))
>       return NULL;
> 
> in find_link(), because as far as I can tell, the hard-linking is
> always just an optimization.
> 
> Comments? Peter?

The hard-linking is unfortunately not just an optimization; if you
ignore it you will create one copy of the file and some number of
zero-length files, since the data isn't duplicated.  As such, printk'ing
an error message and ignoring it is probably the right thing to do.
Truncation is definitely wrong.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

