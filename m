Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab2GPFQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 01:16:51 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46339 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab2GPFQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 01:16:47 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Mon, 16 Jul 2012 07:16:45 +0200
Message-ID: <CA+icZUXURRAs-rK1EnRidYUQ9NXXYw4DaHbn=4mcEe3Q0sU+2A@mail.gmail.com>
Subject: Re: [Regression][Revert request] Excessive delay or hang during
 resume from system suspend due to a hrti
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linux PM List <linux-pm@lists.linux-foundation.org>
Content-Type: multipart/mixed; boundary=f46d042a0d673aa76104c4eb89ba
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d042a0d673aa76104c4eb89ba
Content-Type: text/plain; charset=UTF-8

[ QUOTE ]

Hi Linus,

Please revert:

commit 5baefd6d84163443215f4a99f6a20f054ef11236
Author: John Stultz <johnstul@us.ibm.com>
Date:   Tue Jul 10 18:43:25 2012 -0400

    hrtimer: Update hrtimer base offsets each hrtimer_interrupt

This breaks resume on the iBook G4 and Toshiba Portege R500 (at least), by
adding an excessive delay to it (the Toshiba box sometimes hangs hard during
resume from system suspend).  According to Andreas
(https://lkml.org/lkml/2012/7/15/66):

"Apparently during or before noirq resume the system is hanging by the same
amount of time as the system was sleeping."

which seems to agree with my observations.

Given that the two known-affected boxes are so different, it is quite probable
that the total number of affected systems is actually quite high.

Thanks!


To everyone involved: the fact that this change, which was likely to introduce
regressions from the look of it alone, has been pushed to Linus (an to -stable
at the same time!) so late in the cycle, is seriuosly disappointing.

Thanks,
Rafael

[ /QUOTE ]

Hi,

when I booted 1st into Linux-3.5-rc7 (a few hours after release) I had
a call-trace in get_next_timer_interrupt() (NULL pointer dereference)
on early-boot.
The machine got frozen.

I can't say if this is related to the same issue here, but I can
confirm after suspend + resume the machine (sandy-bridge ultrabook) I
am working on is in an unusable state.
I had to cold reboot/restart.

Regards,
- Sedat -

P.S.: Unfortunately, I could not reproduce the NULL-deref again.
Thomas gave me some instruction to enable some debugobjects
kernel-options (see attached backlog from IRC).

--f46d042a0d673aa76104c4eb89ba
Content-Type: text/plain; charset=US-ASCII; 
	name="backlog_linux-rt_timers-issue_20120715.txt"
Content-Disposition: attachment; 
	filename="backlog_linux-rt_timers-issue_20120715.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h4p3pga00

QmFja2xvZyAjbGludXgtcnQgKE9GVEMsIEdlcm1hbiBsb2NhbC10aW1lIFVUQysyKToKClswOToy
NzoyNl0gPGRpbGVrcz4gaGkKWzA5OjI4OjExXSA8ZGlsZWtzPiB0Z2x4IGpzdHVsdHo6IHdpdGgg
My41LXJjNyBJIGhhdmUgYSBOVUxMIHBvaW50ZXIgZGVyZWZlbmNlIGluIGdldF9uZXh0X3RpbWVy
X2ludGVycnVwdApbMDk6Mjg6MTldIDxkaWxla3M+IG5hdGl2ZV9zY2hlZF9jbG9jawpbMDk6Mjg6
MzFdIDxkaWxla3M+IHRpY2tfbm9oel9zdG9wX3NjaGVkX3RpY2suaXNyYQpbMDk6Mjg6NDNdIDxk
aWxla3M+IHRpY2tfbm9oel9pZGxlX2VudGVyClswOToyODo0Nl0gPGRpbGVrcz4gY3B1X2lkbGUK
WzA5OjI4OjUyXSA8ZGlsZWtzPiBzdGFydF9zZWNvbmRhcnkKWzA5OjI4OjU4XSA8ZGlsZWtzPiBt
YWNoaW5lIGZyZWV6ZXMKWzA5OjI5OjAzXSA8dGdseD4gYnJpbGxpYW50ClswOToyOTowNV0gPGRp
bGVrcz4gY29sZCByZWJvb3QvcmVzdGFydApbMDk6Mjk6MjldIC0qLSBkaWxla3MgLT4gYnJlYWtm
YXN0ClswOTo0MTozMl0gPC0tIHRyZW0gKH50cmVtQGJueTkzLTctODgtMTYxLTMzLTIyMS5mYngu
cHJveGFkLm5ldCkgaGF0IGRhcyBOZXR6d2VyayB2ZXJsYXNzZW4gKFF1aXQ6IEV4LUNoYXQpClsw
OTo0NToyN10gPGRpbGVrcz4gcmUKWzA5OjQ2OjE4XSA8ZGlsZWtzPiB0Z2x4OiBhbnkgaWRlYT8K
WzA5OjQ3OjQyXSA8dGdseD4gd2hlbiBkb2VzIHRoaXMgaGFwcGVuID8KWzA5OjQ3OjQ4XSA8dGds
eD4gZWFybHkgYm9vdCA/ClswOTo0ODowNl0gPGRpbGVrcz4geWVzLiBub3RoaW5nIGluIHRoZSBs
b2dzClsxMDoxODoyNl0gPHRnbHg+IGhtbQpbMTA6MTk6MjFdIDx0Z2x4PiBzbyBpdCBleHBsb2Rl
cyBpbiBnZXRfbmV4dF90aW1lcl9pbnRlcnJ1cHQoKSwgcmlnaHQgPwpbMTA6MjA6MDFdIDx0Z2x4
PiBjYW4geW91IGVuYWJsZSBkZWJ1Z29iamVjdHMgPwpbMTA6MjA6MTJdIDxkaWxla3M+IHllcywg
YXMgYXMgSSBzYXcgYW5kIG5vdGVkIG9uIGEgcG9zdGl0IHNjaGVldApbMTA6MjA6NDFdIDx0Z2x4
PiBERUJVR19PQkpFQ1RTClsxMDoyMDo0Nl0gPHRnbHg+IERFQlVHX09CSkVDVFNfRlJFRQpbMTA6
MjA6NTFdIDx0Z2x4PiBERUJVR19PQkpFQ1RTX1RJTUVSUwpbMTA6MjE6MDVdIDx0Z2x4PiBERUJV
R19PQkpFQ1RTX0VOQUJMRV9ERUZBVUxUClsxMDoyMjoxOV0gPHRnbHg+IHVzdWFsbHkgZXhwbG9z
aW9ucyBpbiBnZXRfbmV4dF90aW1lcl9pbnRlcnJ1cHQoKSBhcmUgY2F1c2VkIGJ5IHRpbWVycyBi
ZWluZyBjb3JydXB0ZWQKWzEwOjIyOjUyXSA8dGdseD4gZGVidWcgb2JqZWN0cyB1c3VhbGx5IGNh
biBjYXRjaCBpdCBhbmQgbGV0IHRoZSBib3ggc3Vydml2ZSBwbHVzIGdpdmVzIHVzIHByb3BlciBp
bmZvIGFib3V0IHRoZSB3cmVja2FnZQpbMTA6MjU6MzddIDxkaWxla3M+IE9LClsxMDoyNjowM10g
PGRpbGVrcz4gaXMgdGhlIGJ1aWxkLXRyZWUgZXhwbG9kaW5nIGluIHNpemU/ClsxMDo0Nzo0OF0g
PHRnbHg+IG5vdCBtdWNoClsxMDo0ODoxN10gPHRnbHg+IGl0J3Mgb25seSB0aGUgZGVidWdvYmpl
Y3QgY29kZSBpdHNlbGYgcGx1cyB0aGUgdGltZXIgY29kZSB3aGljaCBncm93cyBhIGJpdApbMTA6
NDg6MjZdIDx0Z2x4PiBsZXNzIHRoYW4gMWsgSSB0aGluawoKCi1kaWxla3MgLy8gMTUtSnVsLTIw
MTEK
--f46d042a0d673aa76104c4eb89ba--
