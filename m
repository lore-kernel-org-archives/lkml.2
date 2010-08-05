Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192Ab0HEMjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:39:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47390 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab0HEMj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JkWdeHqfAZ3TUjr5mz+bodb1+oARCOvki1ZrUmLQfO3N2iCjk/yKGLlf+EX+uESTPR
         PPmUxD5NohnQnmlpmMrZPDEZOOifFT8WZbQ4DBf/xCLwNZ1cw9YIor7n/ofEQ+PXbwRy
         KcPJQZDl+yFwUnJsiv8D1cAMmvvoWOR57EhrI=
MIME-Version: 1.0
In-Reply-To: <1280969546.2678.33.camel@localhost.localdomain>
References: <1280926108-24668-1-git-send-email-virtuoso@slind.org>
	<1280937526.28884.21.camel@work-vm>
	<4C59B5E1.9040707@genband.com>
	<1280969546.2678.33.camel@localhost.localdomain>
Date: Thu, 5 Aug 2010 15:39:28 +0300
X-Google-Sender-Auth: mXWZd9fH0e_vplmF3P3wCDjn44A
Message-ID: <AANLkTimTDbyn+RA=FHii=vGFypO_O1EjpmdYU4h2_vd8@mail.gmail.com>
Subject: Re: [PATCH] [RFC] notify userspace about time changes
From: Alexander Shishkin <virtuoso@slind.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Chris Friesen <chris.friesen@genband.com>, gregkh@suse.de,
        lkml@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 August 2010 03:52, john stultz <johnstul@us.ibm.com> wrote:
> On Wed, 2010-08-04 at 12:48 -0600, Chris Friesen wrote:
>> On 08/04/2010 09:58 AM, john stultz wrote:
>>
>> > Is there a actual use case that you need this for?  I don't really have
>> > an issue with the code I just really want to make sure the feature would
>> > be useful enough to justify the API and code maintenance going forward.
>>
>> We actually added a time-change-notification mechanism internally a long
>> time ago but never saw demand for it and so never bothered trying to
>> push it upstream.  Ours is signal-based.
>>
>> Among other things we use it to pass on time-change notifications to an
>> emulator running a proprietary OS that really cares about having an
>> accurate time-of-day but can't afford a syscall to retrieve it every time.
>
> So the eventfd based method (and the filtering) proposed would work for
> you?

I think that Kirill has a point and the filtering is really there for
no gain. The user
can indeed count his own time changes and compare that against the eventfd
counter.

Regards,
--
Alex
