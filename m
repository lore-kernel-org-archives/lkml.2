Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab1DSJ4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 05:56:09 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63383 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab1DSJ4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 05:56:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=awZUo7Sa7Q2m5v9UpKMDC70rp7OTFDa3FLzQrcb26EMAWhG7GswX5fiVkbo19vAGUN
         XEhj5iYnL4hVjdtsfxuj9btZJd7JSFvN1514cI5Lg6s7WvNNsKRhDLUOkda0Hmzp3C/c
         xy98mLqwb4VFjbD+Qo6srPsEKXhA39v8yrUu0=
MIME-Version: 1.0
In-Reply-To: <87ipuar6nq.fsf@linux.vnet.ibm.com>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
 <20110412190934.GA12082@redhat.com> <20110412192103.GA13278@redhat.com>
 <87tye1ckhr.fsf@linux.vnet.ibm.com> <BANLkTik68Q2bpgF7GpcOs+YF44B9TL60qQ@mail.gmail.com>
 <87ipuar6nq.fsf@linux.vnet.ibm.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 19 Apr 2011 11:55:50 +0200
Message-ID: <BANLkTikxQ9rSxXTJS-c9qXO6XvpkbWDn8Q@mail.gmail.com>
Subject: Re: Linux 2.6.39-rc3
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 10:23, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Tue, 19 Apr 2011 00:57:27 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:

>> Just a simple question about this approach in general? A filesystem
>> UUID can be changed on disk at any time (tune2fs -U ...).
>>
>> Your code looks like you copy the bytes to the in-kernel superblock
>> structure without noticing any later changes on disk? How is that
>> supposed to work?
>
> Isn't that true even for the fsid returned by statfs ?.  IIUC tune2fs
> won't change even the ext4_super_block.s_uuid .

What matter is that it's common practice today, to change labels
on-disks of mounted filesystems.

There should probably be getter/setter (like generic ioctls, or
whatever fits) for uuid/label of a mounted filesystem. That call would
also update this new superblock info. Guess that's needed before the
kernel can export such stuff in mountinfo.

So tools at least have a chance to do it right here, and the current
on-disk edit can rightfully be deprecated. Exporting possible
out-of-sync data, without the chance to update it without a "reboot"
really doesn't sound convincing.

Kay
