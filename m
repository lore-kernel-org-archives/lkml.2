Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1ETGB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 02:01:59 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38582 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab1ETGB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 02:01:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xawM7WkYgHLLfP3gmS+TFkL+ZqW+FS+6KOgxGe3Jx5+nTdVGyIU5Obun4Rm4292mp+
         Kj+GxBdhMJe96weCWqSUPYWdKWNJobgV2XdKpyXjum062G/KSBmN2EiFGYYViCsMujom
         1HC08l9NKbqk0zrhKKT0sY6nSGrRAzgz4BScs=
MIME-Version: 1.0
In-Reply-To: <20110520033949.GQ32466@dastard>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com> <20110520033949.GQ32466@dastard>
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Fri, 20 May 2011 08:01:17 +0200
Message-ID: <BANLkTikVLFMX_U6brQ5OALbvJkOGuz6++Q@mail.gmail.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tytso@mit.edu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 5:39 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, May 19, 2011 at 03:34:46PM +0200, Dennis Jansen wrote:
>> This is my first proper kernel code proposal so please bear with me!
>>
>> =Summary for busy kernel hackers=
>> Problem: laptop_mode wants to keep applications from waking the hard
>> disks but fsync calls can "sneak through". (IMHO this is a bug.)
>>
>> Proposed solution: Pretend the fsync was executed and successful.
>> Insert two lines into the fsync and fdatasync calls in fs/sync.c:
>> if (unlikely(laptop_mode))
>>    return 0;
>
> No, no, no, no, no, no, no, no, no, no.
>
> There is _absolutely no justification_ for putting people's data at
> risk like this.  If you want to do make fsync/fdatasync calls
> no-ops, then go install libeatmydata on your systems. It's your
> data, and you make the decision to risk it, not us.

1. I thought I (may) make that decision by using laptop mode.
2. libeatmydata would _always_ be active.
3. A lib doesn't fix the ordering guarantee problem.
4. It's clear that it's not the right code. (And it is a rfc and my
first one, too...)

Any suggestions?

Thanks!

Dennis
