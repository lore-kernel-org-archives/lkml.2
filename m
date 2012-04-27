Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab2D0WUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:20:25 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43885 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab2D0WUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:20:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120427150330.783a5b97.akpm@linux-foundation.org>
References: <1335550240-17765-1-git-send-email-snanda@chromium.org>
 <20120427141257.c90f43e0.akpm@linux-foundation.org> <CANMivWaAN9D=-BjSP=frHijWK+K3abAo9nCuW8o+rPSDdHgm7g@mail.gmail.com>
 <20120427150330.783a5b97.akpm@linux-foundation.org>
From: Sameer Nanda <snanda@chromium.org>
Date: Fri, 27 Apr 2012 15:20:02 -0700
X-Google-Sender-Auth: 9vsEzcmET_5geBOfXOmX80yDE8o
Message-ID: <CANMivWZsFaXHChKP0PE1KmWm2T-hWp+VNYKoW1XexQjrqXO=DQ@mail.gmail.com>
Subject: Re: [PATCH] watchdog: fix for lockup detector breakage on resume
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@redhat.com, peterz@infradead.org, len.brown@intel.com, pavel@ucw.cz,
        rjw@sisk.pl, dzickus@redhat.com, msb@chromium.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        olofj@chromium.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 3:03 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 27 Apr 2012 14:40:01 -0700
> Sameer Nanda <snanda@chromium.org> wrote:
>
>> On Fri, Apr 27, 2012 at 2:12 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>>
>> This call actually happens on "exit from suspend" or "entry into
>> resume" processing so
>> how about something like:
>>
>> On exit from suspend we force an offline->online transition on the boot CPU so
>> that the PMU state that was lost while in suspended state gets set up properly
>> for the boot CPU.  This information is required for restarting the NMI watchdog.
>
> OK, let's use that.
>
>> > Also, this is all dead code if CONFIG_SUSPEND=n, so how about
>> >
>
> You had no comments about this?
Looks good to me.

Thanks for including this in the mm tree!

-- 
Sameer
