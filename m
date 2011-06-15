Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1FOT3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:29:14 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:45530 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383Ab1FOT3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:29:12 -0400
X-AuditID: 1209190d-b7bdeae0000004f8-ce-4df907bf0ab7
Message-ID: <4DF90801.4090904@mit.edu>
Date: Wed, 15 Jun 2011 15:29:05 -0400
From: Andy Lutomirski <luto@MIT.EDU>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Olivier Galibert <galibert@pobox.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0-rc3
References: <BANLkTinCfV4owNBhJ+F-yfF3V+wg1o=PLA@mail.gmail.com> <BANLkTim_bHKdZnykedzW4re6GMCg+1Ed2g@mail.gmail.com> <BANLkTi=MvvdTZAHG3N=HHTQd9v6uPNHfzw@mail.gmail.com> <20110615071555.GA26721@dspnet.fr>
In-Reply-To: <20110615071555.GA26721@dspnet.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsUixCmqrLuf/aevwYkrPBafH3azW1zeNYfN
	4lHfW3aLnQ8fMDqweDydMJnd48SM3yweFy8pe3zeJBfAEsVlk5Kak1mWWqRvl8CV8f/tZaaC
	hxwVdy81sDUwfmLrYuTkkBAwkTje8oYdwhaTuHBvPVCci0NIYB+jxP55PSwQzgZGiZWrdrND
	OBeYJBqXzGTsYuTg4BVQk7j3Uwikm0VAVeL0qbVgU9kEVCQ6lj5gArFFBSolJv3cwQpi8woI
	Spyc+YQFxOYTkJOYuPUZM8gYEQFNiX+zxUDGMwusZJTo39bPBBIXFpCSaDubDbH2LKPEwb+H
	wOZzCuhLXLr6mg2khlnAWuLb7iKQMLOAvMT2t3OYJzAKzUKybRZC1SwkVQsYmVcxyqbkVunm
	JmbmFKcm6xYnJ+blpRbpGunlZpbopaaUbmIEB74k7w7GdweVDjEKcDAq8fAeO/vDV4g1say4
	MvcQoyQHk5Io7zmmn75CfEn5KZUZicUZ8UWlOanFhxglOJiVRHhnhwKV86YkVlalFuXDpKQ5
	WJTEeWdKqvsKCaQnlqRmp6YWpBbBZGU4OJQkeAOAES4kWJSanlqRlplTgpBm4uAEGc4DNNwY
	pIa3uCAxtzgzHSJ/ilFRShwiIQCSyCjNg+uFJaZXjOJArwjzmoJU8QCTGlz3K6DBTECDb738
	BjK4JBEhJdXAKHtM9PrZd/mbeCdfePtSpPN22AXpro0G7efj5rIXb1r88LlmaiWPi/LEVlaR
	+eyMXU5Mbb/Xtx1+UTM71+nBT/8IK/GLIm27hfcfjPFO+h9z+tj3s0L+cXn59ha17/7OD93z
	IWLT+8Aps7aL9075d24d2+U3u9i5n/6zWDRx0mtFV4dZ2ub7u5RYijMSDbWYi4oTAZG04zAn
	AwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2011 03:15 AM, Olivier Galibert wrote:
> On Tue, Jun 14, 2011 at 10:59:41AM -0700, Linus Torvalds wrote:
>> On Tue, Jun 14, 2011 at 5:15 AM, Denys Vlasenko
>> <vda.linux@googlemail.com>  wrote:
>>>
>>> I've got a patch for my project to fix parsing of kernel version which
>>> has only two numbers. Basically,
>>>
>>> - scanf(ver, "%u.%u.%u",&a,&b,&c)
>>> + sscanf(ver, "%u.%u",&a,&b)
>>
>> Please just fix it.
>>
>> The projects that care about kernel version are buggy in so many ways
>> that it's not funny.
>
> His problem is recognizing "kernel version" vs. "filename" as a
> parameter.
>    depmod [ -e ]  [ -FSystem.map ]  [ -n ]  [ -v ]  [ version ]  [ filename... ]
>
> Oh course, that's a stupid interface, but probably a hard one to
> change.

Well, the man page says that the version parameter is used to find 
/lib/modules/version.  So why not check if /lib/modules/version exists 
and, if not, try the filename?

/me is still annoyed that some expensive commercial software over here 
won't start if you have funny characters like '+' in your kernel version.

--Andy
