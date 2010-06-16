Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645Ab0FPUow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:44:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43955 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759298Ab0FPUot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:44:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LJvTSP4KzYXmLiRsx7LD1fnarYbOLi9v/irkt9/D+7ogwjvZwVpeHyIGVAEdO5CSdY
         0SswFh9YbdOuwmCIlptDPE1A06HJdFA+XQiWdkhDIqpYL8o6XBynYSNoUlI2GDEuscnB
         KQufHgTufRcOfD5OERhLCieBVHZ5m1usqSRKY=
MIME-Version: 1.0
In-Reply-To: <201006162216.49756.rjw@sisk.pl>
References: <201006141653.03879.rjw@sisk.pl>
	<201006160107.54822.rjw@sisk.pl>
	<201006160811.43926.linux@rainbow-software.org>
	<201006162216.49756.rjw@sisk.pl>
Date: Wed, 16 Jun 2010 16:44:47 -0400
Message-ID: <AANLkTinXNdWXDFhQFoeJ7j6woF4HEgUsBkH-438na6xe@mail.gmail.com>
Subject: Re: [Regression, post-2.6.34] Hibernation broken on machines with 
	radeon/KMS and r300
From: Alex Deucher <alexdeucher@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ondrej Zary <linux@rainbow-software.org>, Dave Airlie <airlied@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: multipart/mixed; boundary=0016363107bde18e3904892bcae9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016363107bde18e3904892bcae9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 16, 2010 at 4:16 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, June 16, 2010, Ondrej Zary wrote:
>> On Wednesday 16 June 2010, Rafael J. Wysocki wrote:
>> > On Tuesday, June 15, 2010, Rafael J. Wysocki wrote:
>> > > On Monday, June 14, 2010, Alex Deucher wrote:
>> > > > On Mon, Jun 14, 2010 at 3:03 PM, Rafael J. Wysocki <rjw@sisk.pl> w=
rote:
>> > > > > On Monday, June 14, 2010, Alex Deucher wrote:
>> > > > >> On Mon, Jun 14, 2010 at 10:53 AM, Rafael J. Wysocki <rjw@sisk.p=
l>
>> wrote:
>> > > > >> > Alex, Dave,
>> > > > >> >
>> > > > >> > I'm afraid hibernation is broken on all machines using radeon=
/KMS
>> > > > >> > with r300 after commit ce8f53709bf440100cb9d31b1303291551cf51=
7f
>> > > > >> > (drm/radeon/kms/pm: rework power management). =A0At least, I'=
m able
>> > > > >> > to reproduce the symptom, which is that the machine hangs har=
d
>> > > > >> > around the point where an image is created (probably during t=
he
>> > > > >> > device thaw phase), on two different boxes with r300 (the out=
put
>> > > > >> > of lspci from one of them is attached for reference, the othe=
r one
>> > > > >> > is HP nx6325).
>> > > > >> >
>> > > > >> > Suspend to RAM appears to work fine at least on one of the
>> > > > >> > affected boxes.
>> > > > >> >
>> > > > >> > Unfortunately, the commit above changes a lot of code and it'=
s not
>> > > > >> > too easy to figure out what's wrong with it and I didn't have=
 the
>> > > > >> > time to look more into details of this failure. =A0However, i=
t looks
>> > > > >> > like you use .suspend() and .resume() callbacks as .freeze() =
and
>> > > > >> > .thaw() which may not be 100% correct (in fact it looks like =
the
>> > > > >> > "legacy" PCI suspend/resume is used, which is not recommended=
 any
>> > > > >> > more).
>> > > > >>
>> > > > >> Does it work any better after Dave's last drm pull request?
>> > > > >
>> > > > > Nope. =A0The symptom is slightly different, though, because now =
it
>> > > > > hangs after turning off the screen.
>> > > > >
>> > > > >> With the latest changes, pm should not be a factor unless it's
>> > > > >> explicitly enabled via sysfs.
>> > > > >
>> > > > > Well, I guess the first pm patch changed more than just pm, then=
.
>> > > >
>> > > > Does this patch help?
>> > > > http://lists.freedesktop.org/archives/dri-devel/2010-June/001314.h=
tml
>> > >
>> > > No, it doesn't. =A0I try to hibernate, everything works to the point=
 where
>> > > the screen goes off and the box hangs (solid). =A0Normally, it would=
 turn
>> > > the screen back on and continue with saving the image.
>> > >
>> > > But, since that happens with the patch above applied, I think it doe=
sn't
>> > > really pass the suspend phase (IOW, it probably hangs somewhere in t=
he
>> > > radeon's suspend routine).
>> >
>> > I've just verified that in fact hibernation works on HP nx6325 with
>> > 2.6.35-rc3, but it takes about 55 sec. to suspend the graphics adapter=
 in
>> > the "freeze" phase. =A0Surprisingly enough, during suspend to RAM it w=
orks
>> > normally (as well as in the "poweroff" phase of hibernation).
>>
>> It takes 2 minutes on RV530:
>> https://bugzilla.redhat.com/show_bug.cgi?id=3D586522
>
> Well, my second affected box appears to hang somewhere in the radeon's su=
spend
> routine.

Does the attached patch help?

Alex

--0016363107bde18e3904892bcae9
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-kms-only-attempt-to-cancel-delayed-work-i.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-only-attempt-to-cancel-delayed-work-i.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gaimqiy30

RnJvbSA5ZDI2MDBmZDMxYzFkZGE2ZjQxZTU2OWZkOGFmZjQ1YzllNWNlNTRmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVyQGdtYWlsLmNvbT4K
RGF0ZTogV2VkLCAxNiBKdW4gMjAxMCAxNjo0MTozOCAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIGRy
bS9yYWRlb24va21zOiBvbmx5IGF0dGVtcHQgdG8gY2FuY2VsIGRlbGF5ZWQgd29yayBpZiBwbSBt
ZXRob2QgaXMgUE1fTUVUSE9EX0RZTlBNCgpkZWxheWVkIHdvcmsgaXMgb25seSBzY2hlZHVsZWQg
aWYgcG0gbWV0aG9kIGlzIFBNX01FVEhPRF9EWU5QTS4KClNpZ25lZC1vZmYtYnk6IEFsZXggRGV1
Y2hlciA8YWxleGRldWNoZXJAZ21haWwuY29tPgotLS0KIGRyaXZlcnMvZ3B1L2RybS9yYWRlb24v
cmFkZW9uX3BtLmMgfCAgICA4ICsrKysrLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9u
cygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9u
L3JhZGVvbl9wbS5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fcG0uYwppbmRleCBi
OWFkMzY2Li4wNzUxZmM4IDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVv
bl9wbS5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX3BtLmMKQEAgLTQwNywx
MSArNDA3LDEyIEBAIHN0YXRpYyBzc2l6ZV90IHJhZGVvbl9zZXRfcG1fbWV0aG9kKHN0cnVjdCBk
ZXZpY2UgKmRldiwKIAkJbXV0ZXhfdW5sb2NrKCZyZGV2LT5wbS5tdXRleCk7CiAJfSBlbHNlIGlm
IChzdHJuY21wKCJwcm9maWxlIiwgYnVmLCBzdHJsZW4oInByb2ZpbGUiKSkgPT0gMCkgewogCQlt
dXRleF9sb2NrKCZyZGV2LT5wbS5tdXRleCk7Ci0JCXJkZXYtPnBtLnBtX21ldGhvZCA9IFBNX01F
VEhPRF9QUk9GSUxFOworCQlpZiAocmRldi0+cG0ucG1fbWV0aG9kID09IFBNX01FVEhPRF9EWU5Q
TSkKKwkJCWNhbmNlbF9kZWxheWVkX3dvcmsoJnJkZXYtPnBtLmR5bnBtX2lkbGVfd29yayk7CiAJ
CS8qIGRpc2FibGUgZHlucG0gKi8KIAkJcmRldi0+cG0uZHlucG1fc3RhdGUgPSBEWU5QTV9TVEFU
RV9ESVNBQkxFRDsKIAkJcmRldi0+cG0uZHlucG1fcGxhbm5lZF9hY3Rpb24gPSBEWU5QTV9BQ1RJ
T05fTk9ORTsKLQkJY2FuY2VsX2RlbGF5ZWRfd29yaygmcmRldi0+cG0uZHlucG1faWRsZV93b3Jr
KTsKKwkJcmRldi0+cG0ucG1fbWV0aG9kID0gUE1fTUVUSE9EX1BST0ZJTEU7CiAJCW11dGV4X3Vu
bG9jaygmcmRldi0+cG0ubXV0ZXgpOwogCX0gZWxzZSB7CiAJCURSTV9FUlJPUigiaW52YWxpZCBw
b3dlciBtZXRob2QhXG4iKTsKQEAgLTQyOCw3ICs0MjksOCBAQCBzdGF0aWMgREVWSUNFX0FUVFIo
cG93ZXJfbWV0aG9kLCBTX0lSVUdPIHwgU19JV1VTUiwgcmFkZW9uX2dldF9wbV9tZXRob2QsIHJh
ZGVvbgogdm9pZCByYWRlb25fcG1fc3VzcGVuZChzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikK
IHsKIAltdXRleF9sb2NrKCZyZGV2LT5wbS5tdXRleCk7Ci0JY2FuY2VsX2RlbGF5ZWRfd29yaygm
cmRldi0+cG0uZHlucG1faWRsZV93b3JrKTsKKwlpZiAocmRldi0+cG0ucG1fbWV0aG9kID09IFBN
X01FVEhPRF9EWU5QTSkKKwkJY2FuY2VsX2RlbGF5ZWRfd29yaygmcmRldi0+cG0uZHlucG1faWRs
ZV93b3JrKTsKIAltdXRleF91bmxvY2soJnJkZXYtPnBtLm11dGV4KTsKIH0KIAotLSAKMS43LjAu
MQoK
--0016363107bde18e3904892bcae9--
