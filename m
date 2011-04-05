Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab1DEXrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 19:47:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46109 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab1DEXrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 19:47:51 -0400
Message-ID: <4D9BA9FA.4010405@zytor.com>
Date: Tue, 05 Apr 2011 16:47:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Ingo Molnar <mingo@elte.hu>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>,
        "lkml20101129@newton.leun.net" <lkml20101129@newton.leun.net>,
        stable kernel team <stable@kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH urgent] x86: Save cr4 to mmu_cr4_features at boot time
References: <alpine.DEB.2.00.1103311715400.16492@kaball-desktop> <201104050829.58474.rjw@sisk.pl> <4D9AB8B7.9020708@zytor.com> <201104050843.39246.rjw@sisk.pl>
In-Reply-To: <201104050843.39246.rjw@sisk.pl>
Content-Type: multipart/mixed;
 boundary="------------040703030709070207040507"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040703030709070207040507
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 04/04/2011 11:43 PM, Rafael J. Wysocki wrote:
> On Tuesday, April 05, 2011, H. Peter Anvin wrote:
>> On 04/04/2011 11:29 PM, Rafael J. Wysocki wrote:
>>>>
>>>> Peter very consciously did not mark the fix for this commit as -stable 
>>>> material. It was ineligible for -stable for multiple reasons: it by no means 
>>>> fixed a 2.6.39 regression and the fix was literally just a few days old.
>>>
>>> Has this issue been resolved in the mainline, BTW?
>>>
>>
>> Just to refresh my memory... is this an issue in mainline, or is it only
>> a problem in the backport (I'm wondering if the trampoline unification
>> patches might have accidentally solved the issue)?
> 
> 
> The problem is in mainline too, please fix ASAP.
> 

For the suspend/resume case this seems like the sanest way to fix it in
my opinion.  However, I am a bit concerned since I'm still not sure
we're programming registers in the correct order, that is:

MISC_ENABLE -> EFER -> cr4 -> cr3 -> cr0

I will look at this issue later this evening, but I wanted your opinion
on it.

	-hpa

--------------040703030709070207040507
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="diff"

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L3Bvd2VyL2NwdS5jIGIvYXJjaC94ODYvcG93ZXIvY3B1
LmMKaW5kZXggODdiYjM1ZS4uNjlkYmY0MiAxMDA2NDQKLS0tIGEvYXJjaC94ODYvcG93ZXIv
Y3B1LmMKKysrIGIvYXJjaC94ODYvcG93ZXIvY3B1LmMKQEAgLTk4LDEzICs5OCwxMiBAQCBz
dGF0aWMgdm9pZCBfX3NhdmVfcHJvY2Vzc29yX3N0YXRlKHN0cnVjdCBzYXZlZF9jb250ZXh0
ICpjdHh0KQogCWN0eHQtPmNyMCA9IHJlYWRfY3IwKCk7CiAJY3R4dC0+Y3IyID0gcmVhZF9j
cjIoKTsKIAljdHh0LT5jcjMgPSByZWFkX2NyMygpOwotI2lmZGVmIENPTkZJR19YODZfMzIK
IAljdHh0LT5jcjQgPSByZWFkX2NyNF9zYWZlKCk7Ci0jZWxzZQotLyogQ09ORklHX1g4Nl82
NCAqLwotCWN0eHQtPmNyNCA9IHJlYWRfY3I0KCk7CisJbW11X2NyNF9mZWF0dXJlcyA9IGN0
eHQtPmNyNDsKKyNpZmRlZiBDT05GSUdfWDg2XzY0CiAJY3R4dC0+Y3I4ID0gcmVhZF9jcjgo
KTsKICNlbmRpZgorCiAJY3R4dC0+bWlzY19lbmFibGVfc2F2ZWQgPSAhcmRtc3JsX3NhZmUo
TVNSX0lBMzJfTUlTQ19FTkFCTEUsCiAJCQkJCSAgICAgICAmY3R4dC0+bWlzY19lbmFibGUp
OwogfQo=
--------------040703030709070207040507--
