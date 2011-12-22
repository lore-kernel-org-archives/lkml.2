Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab1LVTol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 14:44:41 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:35132 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab1LVToi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 14:44:38 -0500
MIME-Version: 1.0
In-Reply-To: <4EF38269.7080804@redhat.com>
References: <1324576939-23619-1-git-send-email-pbonzini@redhat.com>
 <1324576939-23619-3-git-send-email-pbonzini@redhat.com> <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com>
 <4EF38269.7080804@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Dec 2011 11:44:16 -0800
X-Google-Sender-Auth: MuXK6M6C2TaVu6EZB16robmiJKg
Message-ID: <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com>
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition devices
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org, pmatouse@redhat.com,
        agk@redhat.com, jbottomley@parallels.com, mchristi@redhat.com,
        msnitzer@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 11:18 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> This kind of crazy needs to go away.
>
> What crazy?  It's not a permission problem.  Sending a SCSI command to a
> partition makes no sense.  A permission problem implies that somehow you
> should be able to fix it by granting additional permissions, which is not
> the case here.

Ahh, I misread the intention here, and didn't notice that it was doing
it on the stupid SCSI ioctl commands, not the lowlevel SCSI "cmd". The
fact that the changelog talked about sending read/write commands down
to the disk confused me.

But please do use ENOIOCTLCMD directly then, instead of using ENOTTY
and turning it into ENOIOCTLCMD.

                   Linus
