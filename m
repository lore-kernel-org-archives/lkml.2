Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab0KERbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:31:21 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38179 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab0KERbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:31:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mCnqhHpqy6b+HAliWmgQiSq89iPJKK67wcXnwW3ZoYzo/aHVUNJw9sM8pS8BajhLDI
         b8A1xb7Hqtiqe6h8zQIxvB9nACyAbowkep6SAxABc9+92SKSp3ie4US+WcfD7M0nMToH
         ljsyXCPnq3fTCiEYT3SlPSUZWv673LkZRguqo=
MIME-Version: 1.0
In-Reply-To: <AANLkTikgPKeZUih6_12JWSNy=Vsz2UP9HR7wHOz4q6ST@mail.gmail.com>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
	<4CD08419.5050803@kernel.org>
	<4CD23087.30900@cs.columbia.edu>
	<AANLkTikgPKeZUih6_12JWSNy=Vsz2UP9HR7wHOz4q6ST@mail.gmail.com>
Date: Fri, 5 Nov 2010 10:31:16 -0700
Message-ID: <AANLkTikoaU-speokApBQnGZySKx_P3Ovi_O2zMQtz21W@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
From: Sukadev Bhattiprolu <sukadevb@gmail.com>
To: Kapil Arya <kapil@ccs.neu.edu>
Cc: Oren Laadan <orenl@cs.columbia.edu>, Tejun Heo <tj@kernel.org>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Gene Cooperman <gene@ccs.neu.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 4, 2010 at 8:55 PM, Kapil Arya <kapil@ccs.neu.edu> wrote:

>> * Complexity: they technically implement a virtual pid-namespace in userspace
>> by intercepting calls to clone(). I wonder if they consider e.g. pid's saved
>> on file owners or in afunix creds ? I'll just say it's nearly impossible with
>> their 20K lines of code - I know because I did it in a kernel module ...
>
> We do wrap clone and create a table from original PID/TID to current PID/TID
> just as you say. To our knowledge, we have wrappers for all system calls
> involving a PID/TID except fcntl. We are guessing that either Linux C/R also
> keeps a translation table or else restores the original PID/TID. Which do you
> do? In the latter case what do you do if a PID/TID is already used by another
> process/thread?
>

Like Oren said, we run the application inside the container - which would have
 its own pid namespace. When we restart, we again create a container, which
starts with a fresh pid namespace, so the pids will not be in use.
IOW, a process
 has a virtual pid and a global pid. The virtual pid is what the
application sees
when it calls getpid() and that pid will be correctly restored when you create
the container.

Sukadev
