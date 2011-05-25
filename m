Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab1EYIfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:35:09 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:60970 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932782Ab1EYIfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RDOlYL70X36BrkeR+Q0SfriN1++LaQaV0I+Lx/wDLDYIc824tzUo/E09erSLp+HqZg
         EzdGN3tc8zqnzgiq0s6z3+aoi96pJc2nyzSRVRkR3Tmg7YTVoC5G9Tbqnk60ukRj2Udo
         hrAAOVGN1fjf4y2rDajo/63zkIVA/wF7KOEPo=
MIME-Version: 1.0
In-Reply-To: <20110524121343.GA17312@Chamillionaire.breakpoint.cc>
References: <20110521105828.GA29442@Chamillionaire.breakpoint.cc>
	<BANLkTinGZ0L4oQkBYo9H=R==X5Z+efjRaQ@mail.gmail.com>
	<20110524121343.GA17312@Chamillionaire.breakpoint.cc>
Date: Wed, 25 May 2011 16:35:05 +0800
Message-ID: <BANLkTikNSa9otE_cFKRcThUZ5ZCtE7Kyxw@mail.gmail.com>
Subject: Re: [PATCH] timers: consider slack value in mod_timer()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd73466d906b404a41594f1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd73466d906b404a41594f1
Content-Type: text/plain; charset=UTF-8

On Tue, May 24, 2011 at 8:13 PM, Sebastian Andrzej Siewior
<sebastian@breakpoint.cc> wrote:
> * Yong Zhang | 2011-05-24 15:54:17 [+0800]:
>
>>> diff --git a/kernel/timer.c b/kernel/timer.c
>>> index fd61986..bf09726 100644
>>> --- a/kernel/timer.c
>>> +++ b/kernel/timer.c
>>> @@ -804,6 +804,8 @@ int mod_timer(struct timer_list *timer, unsigned long expires)
>>> ?? ?? ?? ?? ?? ?? ?? ??return 1;
>>>
>>> ?? ?? ?? ??expires = apply_slack(timer, expires);
>>
>>So, why not move above line up, then we can use the recalculated
>>expires?
>
> We leave often before apply_slack() kicks in. From printks() it looks
> like we leave more often in first "return 1" than in the second. Moving
> that line up would lead to more __mode_timer() calls.

Hmmm, so the reason is for a timer whose timer->slack is not set
explicitly. when we recalculate expires, we will get different value
sometimes.

Could you please try the attached patch(webmail will mangle it)

Thanks,
Yong



-- 
Only stand for myself

--000e0cd73466d906b404a41594f1
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-timer-avoid-recount-slack-for-same-expire-pending-ti.patch"
Content-Disposition: attachment; 
	filename="0001-timer-avoid-recount-slack-for-same-expire-pending-ti.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_go40pvrg0

RnJvbSAwMmZkMjNiMGJhZjZmNjgzZTg5ODkyN2VkMDE0Y2Y3ZDBlOGQ1YTkwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBZb25nIFpoYW5nIDx5b25nLnpoYW5nMEBnbWFpbC5jb20+CkRh
dGU6IFdlZCwgMjUgTWF5IDIwMTEgMTY6MjA6MTcgKzA4MDAKU3ViamVjdDogW1BBVENIXSB0aW1l
cjogYXZvaWQgcmVjb3VudCBzbGFjayBmb3Igc2FtZS1leHBpcmUgcGVuZGluZyB0aW1lcgoKbW9k
X3RpbWVyIGhhcyBhIG9wdGltaXplZCB3YXkgZm9yIHNhbWUtZXhwaXJlIHBlbmRpbmcgdGltZXIs
CmJ1dCBhZnRlciB3ZSBpbnRyb2R1Y2VkIHNsYWNrLCB0aW1lci0+ZXhwaXJlcyB3aWxsIGJlCnJl
Y291bnQgYmFzZWQgb24gdGltZXItPnNsYWNrLgpTbyB0aGUgY3VycmVudCAnaWYgKHRpbWVyX3Bl
bmRpbmcodGltZXIpICYmIHRpbWVyLT5leHBpcmVzID09IGV4cGlyZXMpJwp3aWxsIGJlIHRydWUg
b25seSB3aGVuICd0aW1lci0+c2xhY2sgPj0gMCcsIGJ1dCBmb3IgdGhlIGNhc2Ugd2hlcmUKdGlt
ZXItPnNsYWNrIGlzIG5vdCBkZWZpbmVkIGV4cGxpY2l0bHksIHRoYXQgY2hlY2sgd2lsbCBmYWls
IHNvbWV0aW1lcy4KClJlcG9ydGVkLWJ5OiBTZWJhc3RpYW4gQW5kcnplaiBTaWV3aW9yIDxzZWJh
c3RpYW5AYnJlYWtwb2ludC5jYz4KU2lnbmVkLW9mZi1ieTogWW9uZyBaaGFuZyA8eW9uZy56aGFu
ZzBAZ21haWwuY29tPgpDYzogVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+Ci0t
LQoga2VybmVsL3RpbWVyLmMgfCAgICA4ICsrKysrKy0tCiAxIGZpbGVzIGNoYW5nZWQsIDYgaW5z
ZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9rZXJuZWwvdGltZXIuYyBi
L2tlcm5lbC90aW1lci5jCmluZGV4IGZkNjE5ODYuLjczYWY1M2MgMTAwNjQ0Ci0tLSBhL2tlcm5l
bC90aW1lci5jCisrKyBiL2tlcm5lbC90aW1lci5jCkBAIC03NDksNiArNzQ5LDEwIEBAIHVuc2ln
bmVkIGxvbmcgYXBwbHlfc2xhY2soc3RydWN0IHRpbWVyX2xpc3QgKnRpbWVyLCB1bnNpZ25lZCBs
b25nIGV4cGlyZXMpCiAJdW5zaWduZWQgbG9uZyBleHBpcmVzX2xpbWl0LCBtYXNrOwogCWludCBi
aXQ7CiAKKwkvKiBubyBuZWVkIHRvIGFjY291bnQgc2xhY2sgYWdhaW4gZm9yIGEgc2FtZS1leHBp
cmUgcGVuZGluZyB0aW1lciAqLworCWlmICh0aW1lcl9wZW5kaW5nKHRpbWVyKSAmJiB0aW1lX2Fm
dGVyX2VxKHRpbWVyLT5leHBpcmVzLCBleHBpcmVzKSkKKwkJcmV0dXJuIHRpbWVyLT5leHBpcmVz
OworCiAJZXhwaXJlc19saW1pdCA9IGV4cGlyZXM7CiAKIAlpZiAodGltZXItPnNsYWNrID49IDAp
IHsKQEAgLTc5NSw2ICs3OTksOCBAQCB1bnNpZ25lZCBsb25nIGFwcGx5X3NsYWNrKHN0cnVjdCB0
aW1lcl9saXN0ICp0aW1lciwgdW5zaWduZWQgbG9uZyBleHBpcmVzKQogICovCiBpbnQgbW9kX3Rp
bWVyKHN0cnVjdCB0aW1lcl9saXN0ICp0aW1lciwgdW5zaWduZWQgbG9uZyBleHBpcmVzKQogewor
CWV4cGlyZXMgPSBhcHBseV9zbGFjayh0aW1lciwgZXhwaXJlcyk7CisKIAkvKgogCSAqIFRoaXMg
aXMgYSBjb21tb24gb3B0aW1pemF0aW9uIHRyaWdnZXJlZCBieSB0aGUKIAkgKiBuZXR3b3JraW5n
IGNvZGUgLSBpZiB0aGUgdGltZXIgaXMgcmUtbW9kaWZpZWQKQEAgLTgwMyw4ICs4MDksNiBAQCBp
bnQgbW9kX3RpbWVyKHN0cnVjdCB0aW1lcl9saXN0ICp0aW1lciwgdW5zaWduZWQgbG9uZyBleHBp
cmVzKQogCWlmICh0aW1lcl9wZW5kaW5nKHRpbWVyKSAmJiB0aW1lci0+ZXhwaXJlcyA9PSBleHBp
cmVzKQogCQlyZXR1cm4gMTsKIAotCWV4cGlyZXMgPSBhcHBseV9zbGFjayh0aW1lciwgZXhwaXJl
cyk7Ci0KIAlyZXR1cm4gX19tb2RfdGltZXIodGltZXIsIGV4cGlyZXMsIGZhbHNlLCBUSU1FUl9O
T1RfUElOTkVEKTsKIH0KIEVYUE9SVF9TWU1CT0wobW9kX3RpbWVyKTsKLS0gCjEuNy40LjEKCg==
--000e0cd73466d906b404a41594f1--
