Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab2CVPTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 11:19:14 -0400
Received: from mga05.intel.com ([192.55.52.89]:49389 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753649Ab2CVPTL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 11:19:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120322150945.GW6589@ZenIV.linux.org.uk>
References: <1332356057-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1332356057-3356-11-git-send-email-zohar@linux.vnet.ibm.com>
	<20120322142212.GV6589@ZenIV.linux.org.uk>
	<1332427986.2218.53.camel@falcor>
	<20120322150945.GW6589@ZenIV.linux.org.uk>
Date: Thu, 22 Mar 2012 17:19:09 +0200
Message-ID: <CALLzPKZTyba2ZgLea=dJW1RsY99-nOE3riVY0mCGVg7zm1SCFw@mail.gmail.com>
Subject: Re: [PATCH v3 10/12] ima: defer calling __fput()
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Matt Helsley <matt.helsley@gmail.com>, Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 5:09 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Mar 22, 2012 at 10:53:04AM -0400, Mimi Zohar wrote:
>> > BTW, you've missed several other places in mm/* doing fput(), so it wouldn't
>> > be enough to paper over your problem anyway.
>> >
>> > Final fput() *can* happen under mmap_sem.  Period.
>>
>> I think I got that loud and clear; otherwise we wouldn't have come up
>> with deferring the __fput().  We have a very real problem here - writing
>> extended attributes requires taking the i_mutex.
>
> Don't do it, then?  If you _must_ write to xattr on final fput, I'd suggest
> starting to figure out if xattr needs its protection to be ->i_mutex - it
> might make sense to introduce a separate mutex for xattr crap.  Or not - I'm

"Or not" ... How to understand you?

> not familiar enough with the guts of xattr handling in individual filesystems
> to tell if that would work (e.g. if it would need unpleasant changes to
> ->setattr() instances)...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
