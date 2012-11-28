Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab2K1QVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:21:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab2K1QVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:21:36 -0500
Message-ID: <50B63A04.9010901@redhat.com>
Date: Wed, 28 Nov 2012 17:21:24 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Acpi deadlocks with 3.7.0-rc4
References: <50A513A8.9010404@redhat.com> <CA+55aFyLMmKuEvY6T2=vSHp_R4=ndqFEFNJsc3Axze2vYknKhg@mail.gmail.com>
In-Reply-To: <CA+55aFyLMmKuEvY6T2=vSHp_R4=ndqFEFNJsc3Axze2vYknKhg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 28.11.2012 17:01, Linus Torvalds napsal(a):
> Adding more people (and the acpi list) to this report.
>
> I'm seeing *very* few changes to the core suspend/resume path in 3.7,
> and while there are some acpia updates, they seem to be pretty mild
> too.
>
> I think the acpi_os_wait_semaphore thing is a red herring - that's
> just stale on the stack.
>
> Do you have the register state from the oops? Or at least the "Code:"
> line? It would be nice to see exactly where the oops happens, and I
> cannot line up your "acpi_ns_lookup  + 0xa1/0x5b9" with any code due
> to different compilers (and configurations etc).
>
>                 Linus
>


I've opened  https://bugzilla.kernel.org/show_bug.cgi?id=51071
and attached picture there which is all I have.

I'll try to decode exact code line.


In all cases - I've played even with 3.4 kernel - which also does not survive 
multiple resumes in docking station - though it just leaves black screen - so 
this oops is rather 'progress' and it also could be false path.

It's probably not a regression from 3.6 - since this problem was there for 
much longer - but now it has just become much more visible.

As I usually do not have reason to make multiple suspend/resumes in dock I've 
not noticed it until now when I've tried to capture this ACPI trace.

Zdenek

