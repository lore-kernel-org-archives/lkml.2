Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab2JZGGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 02:06:09 -0400
Received: from guarana.org ([59.167.251.209]:40851 "EHLO
	cheesypoof.guarana.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249Ab2JZGGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 02:06:08 -0400
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2012 02:06:08 EDT
Message-ID: <20121026165713.19106iudy5h4nvbw@guarana.org>
Date: Fri, 26 Oct 2012 16:57:13 +1100
From: Kevin Easton <kevin@guarana.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] firmware loader: introduce module parameter to
 customize fw search path
References: <1351212379-26026-1-git-send-email-ming.lei@canonical.com>
 <CA+55aFwaLnyYFaydxw1ALmp_EP217DmgY=ihNy3z1ZqF-pqkSA@mail.gmail.com>
 <CACVXFVObmYD9iG1yMkCNqfdx-XxMKOJ41kAROyxx-RBDufKKmQ@mail.gmail.com>
 <CA+55aFzoJULimHhYHdb-BW1bqSAY8FUevPnYu-K6nDa7xRtg2w@mail
 <20121026035259.GO2616@ZenIV.linux.org.uk>
In-Reply-To: <20121026035259.GO2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Al Viro <viro@ZenIV.linux.org.uk>:

> On Thu, Oct 25, 2012 at 08:38:25PM -0700, Linus Torvalds wrote:
>
>> It's valid to cast a non-const pointer to a const one. It's the
>> *other* way around that is invalid.
>>
>> So marking fw_path[] as having 'const char *' elements just means that
>> we won't be changing those elements through the fw_path[] array
>> (correct: we only read them). The fact that one of those same pointers
>> is then also available through a non-const pointer variable means that
>> they can change through *that* pointer, but that doesn't change the
>> fact that fw_path[] itself contains const pointers.
>>
>> Remember: in C, a "const pointer" does *not* mean that the thing it
>> points to cannot change. It only means that it cannot change through
>> *that* pointer.
>
> It's a bit trickier, unfortunately - pointer to pointer to const char
> and pointer to pointer to char do not mix.  Just for fun, try to constify
> envp and argv arguments of call_usermodehelper()...

That's because if it _was_ allowed, you could use it to silently  
launder the const away:

const char *c = "rodata";
char *x;
const char **y;

y = &x;
*y = c;

/* We now have (const char) values accessible through a (char *) pointer x */



