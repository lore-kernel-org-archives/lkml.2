Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab2EFQw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 12:52:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37817 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab2EFQw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 12:52:27 -0400
Message-ID: <4FA6AC46.20701@gmail.com>
Date: Sun, 06 May 2012 19:52:22 +0300
From: Nikolai Kondrashov <spbnick@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] hid: Enable report fixup on rebind
References: <1335097300-11881-1-git-send-email-rydberg@euromail.se> <alpine.LNX.2.00.1204222325380.1856@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1204222325380.1856@pobox.suse.cz>
Content-Type: multipart/mixed;
 boundary="------------000103040608050202010309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000103040608050202010309
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jiri, Henrik,

On 04/23/2012 12:27 AM, Jiri Kosina wrote:
> On Sun, 22 Apr 2012, Henrik Rydberg wrote:
>
>> This patchset contains a resolution to the problem with
>> driver-specific modification of the report descriptor. The core of the
>> problem lies with the dual semantics of hid_parse_report(), which is
>> therefore split into two functions. As a consequence, the hid core can
>> handle the rebind case internally, with no changes to the
>> drivers. Out-of-tree drivers will work fine as long as they operate in
>> the same way as the in-kernel drivers.
>>
>> The first two patches are bug fixes found in the process. I am hoping
>> for some test feedback on those. The third patch is the main one.
>
> Hi Henrik,
>
> thanks a lot for looking into this. I will look into the patches in more
> detail tomorrow. I am now just adding Nikolai to CC, as he was the first
> one to bring this up and actually has a driver that exposed the fact that
> just freeing/reinstatiating rdesc is not enough.

I've managed to throw together a script which rebinds a device to a specific
out-of-tree HID driver automatically. Please find it attached. I'll be
bundling it with the modules, probably.

I'm planning to use it with udev rules looking like this one:

SUBSYSTEM=="hid", ACTION=="add", ENV{HID_ID}=="0003:0000172F:*", \
         RUN+="/usr/local/bin/digimend-rebind"

So, the out-of-tree HID module problem is finally solved, at least for my
current uses. Thanks a lot!

Sincerely,
Nick

--------------000103040608050202010309
Content-Type: text/plain;
 name="digimend-rebind"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="digimend-rebind"

IyEvYmluL3NoCiMKIyBESUdJbWVuZCBzcGVjaWZpYyBkcml2ZXIgcmViaW5kaW5nIHNjcmlw
dC4gVG8gYmUgaW52b2tlZCBieSB1ZGV2LgojIEF1dGhvcjogTmlrb2xhaSBLb25kcmFzaG92
IDxzcGJuaWNrQGdtYWlsLmNvbT4KIwojIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJl
OiB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5CiMgaXQgdW5kZXIgdGhl
IHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNoZWQg
YnkKIyB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uLCBlaXRoZXIgdmVyc2lvbiAyIG9m
IHRoZSBMaWNlbnNlLCBvcgojIChhdCB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNpb24u
CiMKIyBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4gdGhlIGhvcGUgdGhhdCBpdCB3
aWxsIGJlIHVzZWZ1bCwKIyBidXQgV0lUSE9VVCBBTlkgV0FSUkFOVFk7IHdpdGhvdXQgZXZl
biB0aGUgaW1wbGllZCB3YXJyYW50eSBvZgojIE1FUkNIQU5UQUJJTElUWSBvciBGSVRORVNT
IEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4gIFNlZSB0aGUKIyBHTlUgR2VuZXJhbCBQdWJs
aWMgTGljZW5zZSBmb3IgbW9yZSBkZXRhaWxzLgojCiMgWW91IHNob3VsZCBoYXZlIHJlY2Vp
dmVkIGEgY29weSBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UKIyBhbG9uZyB3
aXRoIHRoaXMgcHJvZ3JhbS4gIElmIG5vdCwgc2VlIDxodHRwOi8vd3d3LmdudS5vcmcvbGlj
ZW5zZXMvPi4KIwoKIyBXcml0ZSBhIHN0cmluZyB0byBhIGZpbGUsIGlnbm9yaW5nIEVOT0RF
Vi4Kd3JpdGVfaWdub3JlX2Vub2RldigpIHsKICAgIGxvY2FsIHN0cj0iJDEiCiAgICBsb2Nh
bCBwYXRoPSIkMiIKICAgIGxvY2FsIG91dHB1dD0iIgoKICAgICMgV3JpdGUgdGhlIHN0cmlu
ZyB3aXRoIHRlZSwgY2FwdHVyaW5nIGVycm9yIG91dHB1dAogICAgaWYgISBvdXRwdXQ9ImAo
ZWNobyBcIiRzdHJcIiB8IHRlZSBcIiRwYXRoXCIgPi9kZXYvbnVsbCkgMj4mMWAiOyB0aGVu
CiAgICAgICAgIyBSYWlzZSBhbnl0aGluZyBleGNlcHQgRU5PREVWCiAgICAgICAgaWYgWyAi
JHtvdXRwdXQjIyo6IH0iICE9ICJObyBzdWNoIGRldmljZSIgXTsgdGhlbgogICAgICAgICAg
ICBlY2hvICIkb3V0cHV0IiA+JjIKICAgICAgICAgICAgcmV0dXJuIDEKICAgICAgICBmaQog
ICAgZmkKfQoKKAoJc2V0IC1lIC11CgogICAgcHJvZ25hbWU9ImBiYXNlbmFtZSBcIiQwXCJg
IgoKCWlkPSJgYmFzZW5hbWUgJERFVlBBVEhgIgoKICAgIGN1cnJlbnRfZHJpdmVyX3BhdGg9
ImByZWFkbGluayAtdiAtZiAvc3lzJHtERVZQQVRIfS9kcml2ZXJgIgogICAgaWYgWyAtZSAi
JGN1cnJlbnRfZHJpdmVyX3BhdGgiIF07IHRoZW4KICAgICAgICBjdXJyZW50X2RyaXZlcj0i
YGJhc2VuYW1lIFwiJGN1cnJlbnRfZHJpdmVyX3BhdGhcImAiCiAgICBlbHNlCiAgICAgICAg
Y3VycmVudF9kcml2ZXI9IiIKICAgIGZpCgoJc3BlY2lmaWNfbW9kdWxlPSJgbW9kcHJvYmUg
LVIgJE1PREFMSUFTYCIKCgkjIEFzc3VtZSB0aGUgZHJpdmVyIHdvdWxkIGJlIGNhbGxlZCB0
aGUgc2FtZSBhcyBtb2R1bGUsCgkjIGJ1dCB3aXRob3V0IHRoZSAiaGlkXyIgb3IgImhpZC0i
IHByZWZpeAoJc3BlY2lmaWNfZHJpdmVyPSIke3NwZWNpZmljX21vZHVsZSNoaWRbXy1dfSIK
ICAgIHNwZWNpZmljX2RyaXZlcl9wYXRoPSIvc3lzL2J1cy9oaWQvZHJpdmVycy8kc3BlY2lm
aWNfZHJpdmVyIgoKCWlmIFsgIiRjdXJyZW50X2RyaXZlciIgIT0gIiRzcGVjaWZpY19kcml2
ZXIiIF07IHRoZW4KICAgICAgICBsb2dnZXIgLXAgZGFlbW9uLm5vdGljZSAtdCAiJHByb2du
YW1lIiAicmViaW5kaW5nICRERVZQQVRIIgoKCQkjIEVuc3VyZSB0aGUgc3BlY2lmaWMgZHJp
dmVyIG1vZHVsZSBpcyBsb2FkZWQKCQltb2Rwcm9iZSAiJHNwZWNpZmljX21vZHVsZSIKCgkJ
IyBVbmJpbmQgZnJvbSB0aGUgY3VycmVudCBkcml2ZXIsIGlmIGFueQogICAgICAgIGlmIFsg
LW4gIiRjdXJyZW50X2RyaXZlciIgXTsgdGhlbgogICAgICAgICAgICB3cml0ZV9pZ25vcmVf
ZW5vZGV2ICIkaWQiICIkY3VycmVudF9kcml2ZXJfcGF0aC91bmJpbmQiCiAgICAgICAgZmkK
CgkJIyBCaW5kIHRvIHRoZSBzcGVjaWZpYyBkcml2ZXIKICAgICAgICB3cml0ZV9pZ25vcmVf
ZW5vZGV2ICIkaWQiICIkc3BlY2lmaWNfZHJpdmVyX3BhdGgvYmluZCIKCWZpCikgMj4mMSB8
IGxvZ2dlciAtcCBkYWVtb24ud2FybmluZyAtdCAiJHByb2duYW1lIgo=
--------------000103040608050202010309--
