Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866Ab1BKR7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 12:59:49 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46038 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab1BKR7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 12:59:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QFaT3H7AVsCRsIJvwKJRIkxE4KgwXdXe7dP0TbuPeI81gLAc2knCaIUoLkgEVL/tOM
         1DBe/2BsfAqGg4pU5DekFEVxixEpvAAHnwvrCLlVHy7Jn111jQRkYAPM80nozbrRgYFT
         /r+7+z9foDVbKbFSCYVNzH5b/8zQIJHzCf62s=
MIME-Version: 1.0
In-Reply-To: <20110211170722.GA2010@jolsa.brq.redhat.com>
References: <1297432830-3912-1-git-send-email-jolsa@redhat.com>
	<m14o8a34em.fsf@fess.ebiederm.org>
	<20110211170722.GA2010@jolsa.brq.redhat.com>
Date: Fri, 11 Feb 2011 12:59:47 -0500
Message-ID: <AANLkTikCAbe5ATHjqgQDOFuCjcuG1=8e_5+ADaCQ3M6R@mail.gmail.com>
Subject: Re: [PATCH] x86_64: disable identity mappings statically
From: Brian Gerst <brgerst@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 12:07 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Fri, Feb 11, 2011 at 08:46:41AM -0800, Eric W. Biederman wrote:
>> Jiri Olsa <jolsa@redhat.com> writes:
>>
>> > hi,
>> >
>> > while browsing the page table setup code, I noticed the x86_64 head
>> > code might not need the identity mappings at all.
>> > It seems it's ok to switch it off completely from the begining,
>> > unless I'm missing something.
>>
>> Have you tested it?
>
> yes, I booted it with no problem

The only reason this doesn't crash is because the identity mappings
provided by the boot code are marked as global, and therefore might
not be flushed by simply loading cr3.  The cpu can evict TLB entries
at any time though, so it's a bad idea to run without the identity
mappings even for the brief moment before jumping to the virtual
address.

--
Brian Gerst
