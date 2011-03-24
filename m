Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab1CXQu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:50:59 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42577 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab1CXQu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:50:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=EFBvv67IyKX8vVKY3wkuz0FSibb7fBAF/6j+PTqS7crnWezoEqEgQoAqSG5bxzX9dt
         jZJxQyjnm1QtFH7MwzJSzjCFSv2FIJPyGh1zz14C71mZzGmbbKuC6Ul45jyY+B3QVw/1
         7mkFVTiTihjfRxJVdagoK6t/Bwqo2LZTLkZug=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1103240940570.32226@router.home>
References: <alpine.DEB.2.00.1103221635400.4521@tiger>
	<20110324142146.GA11682@elte.hu>
	<alpine.DEB.2.00.1103240940570.32226@router.home>
Date: Thu, 24 Mar 2011 18:50:57 +0200
X-Google-Sender-Auth: a3OhhvX5AdtpYwaU-XayX3QYG_0
Message-ID: <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com>
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: multipart/mixed; boundary=001636eee22b130adf049f3d489a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636eee22b130adf049f3d489a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 24, 2011 at 4:41 PM, Christoph Lameter <cl@linux.com> wrote:
> On Thu, 24 Mar 2011, Ingo Molnar wrote:
>
>> FYI, some sort of boot crash has snuck upstream in the last 24 hours:
>>
>> =A0BUG: unable to handle kernel paging request at ffff87ffc147e020
>> =A0IP: [<ffffffff811aa762>] this_cpu_cmpxchg16b_emu+0x2/0x1c
>
> Hmmm.. This is the fallback code for the case that the processor does not
> support cmpxchg16b.

How does alternative_io() work? Does it require
alternative_instructions() to be executed. If so, the fallback code
won't be active when we enter kmem_cache_init(). Is there any reason
check_bugs() is called so late during boot? Can we do something like
the totally untested attached patch?

--001636eee22b130adf049f3d489a
Content-Type: application/octet-stream; name="check-bugs.patch"
Content-Disposition: attachment; filename="check-bugs.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_glnx4au21

ZGlmZiAtLWdpdCBhL2luaXQvbWFpbi5jIGIvaW5pdC9tYWluLmMKaW5kZXggNGE5NDc5ZS4uZTU3
ZDZhNyAxMDA2NDQKLS0tIGEvaW5pdC9tYWluLmMKKysrIGIvaW5pdC9tYWluLmMKQEAgLTUwOCw2
ICs1MDgsNyBAQCBhc21saW5rYWdlIHZvaWQgX19pbml0IHN0YXJ0X2tlcm5lbCh2b2lkKQogCXZm
c19jYWNoZXNfaW5pdF9lYXJseSgpOwogCXNvcnRfbWFpbl9leHRhYmxlKCk7CiAJdHJhcF9pbml0
KCk7CisJY2hlY2tfYnVncygpOwogCW1tX2luaXQoKTsKIAkvKgogCSAqIFNldCB1cCB0aGUgc2No
ZWR1bGVyIHByaW9yIHN0YXJ0aW5nIGFueSBpbnRlcnJ1cHRzIChzdWNoIGFzIHRoZQpAQCAtNjE0
LDggKzYxNSw2IEBAIGFzbWxpbmthZ2Ugdm9pZCBfX2luaXQgc3RhcnRfa2VybmVsKHZvaWQpCiAJ
dGFza3N0YXRzX2luaXRfZWFybHkoKTsKIAlkZWxheWFjY3RfaW5pdCgpOwogCi0JY2hlY2tfYnVn
cygpOwotCiAJYWNwaV9lYXJseV9pbml0KCk7IC8qIGJlZm9yZSBMQVBJQyBhbmQgU01QIGluaXQg
Ki8KIAlzZmlfaW5pdF9sYXRlKCk7CiAK
--001636eee22b130adf049f3d489a--
