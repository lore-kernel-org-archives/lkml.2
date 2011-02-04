Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab1BDFsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 00:48:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38454 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab1BDFsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 00:48:10 -0500
Message-ID: <4D4B930E.1060704@zytor.com>
Date: Thu, 03 Feb 2011 21:47:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: matthieu castet <castet.matthieu@free.fr>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [BUG] broken ebba638ae723d8a8fc2f7abce5ec18b688b791d7
References: <4D41E86D.8060205@free.fr> <20110127230013.GO4981@outflux.net> <4D4228CE.5090601@zytor.com> <20110131213847.GF4557@outflux.net> <4D474194.2000709@free.fr> <20110131235231.GJ4557@outflux.net> <4D475D6B.4030508@zytor.com> <20110202204031.GB5503@outflux.net>
In-Reply-To: <20110202204031.GB5503@outflux.net>
Content-Type: multipart/mixed;
 boundary="------------040302010006000606000503"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040302010006000606000503
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 02/02/2011 12:40 PM, Kees Cook wrote:
> On Mon, Jan 31, 2011 at 05:10:03PM -0800, H. Peter Anvin wrote:
>> On 01/31/2011 03:52 PM, Kees Cook wrote:
>>>
>>> This worked, thanks! If this tests cleanly for you in qemu, we should get
>>> this committed.
>>>
>>
>> This is wrong for at least one reason; possibly two:
>>
>> a) it ignores the control to not reload the segment registers (not
>> sure if anything still uses them, but...)
>>
>> b) I'm not sure that init_thread_union is safe for the non-BSP CPU here.
> 
> What's the best way to move forward? Or, how can we find answers to these
> questions?
> 
> -Kees
> 


Can someone test out the attached patch and verify that it works?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


--------------040302010006000606000503
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="diff"

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9oZWFkXzMyLlMgYi9hcmNoL3g4Ni9rZXJu
ZWwvaGVhZF8zMi5TCmluZGV4IGZjMjkzZGMuLjJhZWU1OTQgMTAwNjQ0Ci0tLSBhL2FyY2gv
eDg2L2tlcm5lbC9oZWFkXzMyLlMKKysrIGIvYXJjaC94ODYva2VybmVsL2hlYWRfMzIuUwpA
QCAtMjYsNiArMjYsMTEgQEAKICNkZWZpbmUgcGEoWCkgKChYKSAtIF9fUEFHRV9PRkZTRVQp
CiAKIC8qCisgKiBJbml0aWFsIHN0YWNrIHBvaW50ZXIgZm9yIHRoZSBib290IHByb2Nlc3Nv
cgorICovCitpbml0aWFsX3N0YWNrX3BvaW50ZXIgPSBpbml0X3RocmVhZF91bmlvbitUSFJF
QURfU0laRQorCisvKgogICogUmVmZXJlbmNlcyB0byBtZW1iZXJzIG9mIHRoZSBuZXdfY3B1
X2RhdGEgc3RydWN0dXJlLgogICovCiAKQEAgLTk5LDggKzEwNCwxMCBAQCBFTlRSWShzdGFy
dHVwXzMyKQogCW1vdmwgJWVheCwlZXMKIAltb3ZsICVlYXgsJWZzCiAJbW92bCAlZWF4LCVn
cworCW1vdmwgJWVheCwlc3MKIDI6Ci0KKwltb3ZsICRwYShpbml0aWFsX3N0YWNrX3BvaW50
ZXIpLCAlZXNwCisJCiAvKgogICogQ2xlYXIgQlNTIGZpcnN0IHNvIHRoYXQgdGhlcmUgYXJl
IG5vIHN1cnByaXNlcy4uLgogICovCkBAIC0yODIsNiArMjg5LDkgQEAgRU5UUlkoc3RhcnR1
cF8zMl9zbXApCiAJbW92bCAlZWF4LCVlcwogCW1vdmwgJWVheCwlZnMKIAltb3ZsICVlYXgs
JWdzCisJbW92bCBwYShzdGFja19zdGFydCksJWVjeAorCW1vdmwgJWVheCwlc3MKKwlsZWFs
IC1fX1BBR0VfT0ZGU0VUKCVlY3gpLCVlc3AKICNlbmRpZiAvKiBDT05GSUdfU01QICovCiBk
ZWZhdWx0X2VudHJ5OgogCkBAIC02NzEsNyArNjgxLDcgQEAgRU5UUlkoaW5pdGlhbF9wYWdl
X3RhYmxlKQogCiAuZGF0YQogRU5UUlkoc3RhY2tfc3RhcnQpCi0JLmxvbmcgaW5pdF90aHJl
YWRfdW5pb24rVEhSRUFEX1NJWkUKKwkubG9uZyBpbml0aWFsX3N0YWNrX3BvaW50ZXIKIAku
bG9uZyBfX0JPT1RfRFMKIAogcmVhZHk6CS5ieXRlIDAK
--------------040302010006000606000503--
