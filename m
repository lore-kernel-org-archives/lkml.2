Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1CJAgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:36:37 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60149 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab1CJAge convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:36:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=b8dVwLs66po3XfIRsE25PHYLljUgWnZp2QegWE2PMyxf0NubtTKu+rDPGPsC0wxyK8
         UrwPJ2qe4/88lWqTXBOhE4IXJ/I93xY8xtluj9WCisu4wNo/QMurJtR9MsH0qFhbwUBy
         aBAWHVWzCc69hmXVl65z4s15E6QOzTHzW6N38=
MIME-Version: 1.0
In-Reply-To: <20110309162513.5058c824.akpm@linux-foundation.org>
References: <1299681411-9227-1-git-send-email-virtuoso@slind.org> <20110309162513.5058c824.akpm@linux-foundation.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 10 Mar 2011 01:36:18 +0100
Message-ID: <AANLkTinZioShsr3O0Z=xaEQ-S=JBCgs_SS_LdsBnNhZ2@mail.gmail.com>
Subject: Re: [RFCv4] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock changes
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org,
        Ken MacLeod <ken@bitsko.slc.ut.us>,
        Shaun Reich <predator106@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 01:25, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed,  9 Mar 2011 16:36:51 +0200
> Alexander Shishkin <virtuoso@slind.org> wrote:
>
>> Changes since v3:
>>  - changed timerfd_settime() semantics (see below)
>> Changes since v2:
>>  - replaced sysfs interface with a syscall
>>  - added sysctl/procfs handle to set a limit to the number of users
>>  - fixed issues pointed out by Greg.
>> Changes since v1:
>>  - updated against 2.6.36-rc1,
>>  - added notification/filtering options,
>>  - added Documentation/ABI/sysfs-kernel-time-notify interface description.

> It would be helpful to know if the identified users of this feature
> actually find it useful and adequate.  I guess the most common
> application is the 1,001 desktop clock widgets.  Do you have any
> feedback from any of the owners of those?

We want it for systemd, to provide cron-like functionality but without
the need to stupidly wake up every minute and check the system time
for possible jumps.

It also sounds useful for a generic resume (after system suspend)
notification for applications, which isn't really possible today.

Kay
