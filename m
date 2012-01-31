Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2AaKsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:48:16 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33963 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab2AaKsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:48:15 -0500
Message-ID: <4F27C6EB.2070305@suse.cz>
Date: Tue, 31 Jan 2012 11:48:11 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120124 Thunderbird/10.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        systemd-devel@lists.freedesktop.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: sysfs regression: wrong link counts
References: <4F27120A.4040106@suse.cz> <20120130220611.GA26655@kroah.com> <20120130221059.26ab5edf@pyramind.ukuu.org.uk> <20120130222717.GA6393@kroah.com> <m18vkoirv9.fsf@fess.ebiederm.org>
In-Reply-To: <m18vkoirv9.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2012 02:27 AM, Eric W. Biederman wrote:
> Greg KH <greg@kroah.com> writes:
> 
>> On Mon, Jan 30, 2012 at 10:10:59PM +0000, Alan Cox wrote:
>>>> Isn't there some other "proper" way of doing this in userspace, or is
>>>> this really the correct way?
>>>
>>> You can look at the S_IFMT bits and stuff however link count indicating
>>> number of subdirectories is a standard Unix thing and used by many quite
>>> mundane tools as an optimisation.
>>
>> Ah, yeah, that is easier.
>>
>> Eric, care to fix this or want me to revert it?
> 
> With respect to sensors the conversation has already been had, and I fix
> is already queued and should come out in the sensors release due out in
> a week or so.  So sensors should be fixed before this code is merged
> into Linus's kernel.

Oh, we are not going to break userspace with 3.3, are we? I understand
that what sensors do is nothing but sh*t. But this change should wait
until everybody has a chance to have fixed sensors package in their
distribution.

To be clear, what I'm suggesting is to postpone the change and schedule
it for something like 3.7.

> Now why something minor like sensors that nothing seems to depend
> strongly on should stop a system from booting is a huge question.

sensors do not prevent boot at all, of course. The other
cannot-start-network bug does.

> So I am going to have the conversation to triage what is up with
> systemd.  That seems totally unexpected.

Looks like netdev renaming problem, see my other mail.

thanks,
-- 
js
suse labs
.
