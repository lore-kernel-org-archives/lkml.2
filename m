Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab0DXUgv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 16:36:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62280 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab0DXUgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 16:36:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=cj49jqa4+lb9xqjy6mStxgWbSTDWPLQMt+Nld3Q4+Ha7kQKsXJOW9eDVNm0C1u40tP
         pLvg1Hy7rIFxuy5DXtKy+Q3uKK66NX60UZEaTQssFFKqUBIb3gMBfgtaeA9r4EouMUm9
         sJVeDnhiHpPGPyZM3DF5LJvfEbC6QgZ32SBHY=
MIME-Version: 1.0
In-Reply-To: <1272020222.24780.460.camel@tucsk.pomaz.szeredi.hu>
References: <1271420878.24780.145.camel@tucsk.pomaz.szeredi.hu>
	 <h2m4e5e476b1004170546z8997cd90h98ecfb9cc5aad8cf@mail.gmail.com>
	 <1271677562.24780.184.camel@tucsk.pomaz.szeredi.hu>
	 <j2t4e5e476b1004201350xbd08a002l3329fbdd4fb1b8db@mail.gmail.com>
	 <1271856324.24780.285.camel@tucsk.pomaz.szeredi.hu>
	 <1271865911.24780.292.camel@tucsk.pomaz.szeredi.hu>
	 <p2t4e5e476b1004220059u2263832atf36ee33ae83463fa@mail.gmail.com>
	 <20100422203123.GF3228@redhat.com>
	 <1272020222.24780.460.camel@tucsk.pomaz.szeredi.hu>
Date: Sat, 24 Apr 2010 22:36:48 +0200
Message-ID: <s2q4e5e476b1004241336lbd071624ke489350093ca6e1a@mail.gmail.com>
Subject: Re: CFQ read performance regression
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Miklos Szeredi <mszeredi@suse.cz>, Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Suresh Jayaraman <sjayaraman@suse.de>
Content-Type: multipart/mixed; boundary=0016367b5f20bf9617048501804b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016367b5f20bf9617048501804b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 23, 2010 at 12:57 PM, Miklos Szeredi <mszeredi@suse.cz> wrote:
> On Thu, 2010-04-22 at 16:31 -0400, Vivek Goyal wrote:
>> On Thu, Apr 22, 2010 at 09:59:14AM +0200, Corrado Zoccolo wrote:
>> > Hi Miklos,
>> > On Wed, Apr 21, 2010 at 6:05 PM, Miklos Szeredi <mszeredi@suse.cz> wro=
te:
>> > > Jens, Corrado,
>> > >
>> > > Here's a graph showing the number of issued but not yet completed
>> > > requests versus time for CFQ and NOOP schedulers running the tiobenc=
h
>> > > benchmark with 8 threads:
>> > >
>> > > http://www.kernel.org/pub/linux/kernel/people/mszeredi/blktrace/queu=
e-depth.jpg
>> > >
>> > > It shows pretty clearly the performance problem is because CFQ is no=
t
>> > > issuing enough request to fill the bandwidth.
>> > >
>> > > Is this the correct behavior of CFQ or is this a bug?
>> > =C2=A0This is the expected behavior from CFQ, even if it is not optima=
l,
>> > since we aren't able to identify multi-splindle disks yet.
>>
>> In the past we were of the opinion that for sequential workload multi sp=
indle
>> disks will not matter much as readahead logic (in OS and possibly in
>> hardware also) will help. For random workload we anyway don't idle on th=
e
>> single cfqq so it is fine. But my tests now seem to be telling a differe=
nt
>> story.
>>
>> I also have one FC link to one of the HP EVA and I am running increasing
>> number of sequential readers to see if throughput goes up as number of
>> readers go up. The results are with noop and cfq. I do flush OS caches
>> across the runs but I have no control on caching on HP EVA.
>>
>> Kernel=3D2.6.34-rc5
>> DIR=3D/mnt/iostestmnt/fio =C2=A0 =C2=A0 =C2=A0 =C2=A0DEV=3D/dev/mapper/m=
pathe
>> Workload=3Dbsr =C2=A0 =C2=A0 =C2=A0iosched=3Dcfq =C2=A0 =C2=A0 Filesz=3D=
2G =C2=A0 bs=3D4K
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> job =C2=A0 =C2=A0 =C2=A0 Set NR =C2=A0ReadBW(KB/s) =C2=A0 MaxClat(us) =
=C2=A0 =C2=A0WriteBW(KB/s) =C2=A0MaxClat(us)
>> --- =C2=A0 =C2=A0 =C2=A0 --- -- =C2=A0------------ =C2=A0 ----------- =
=C2=A0 =C2=A0------------- =C2=A0-----------
>> bsr =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 1 =C2=A0 135366 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 59024 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00
>> bsr =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 2 =C2=A0 124256 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 126808 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00
>> bsr =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 4 =C2=A0 132921 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 341436 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00
>> bsr =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 8 =C2=A0 129807 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 392904 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00
>> bsr =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 16 =C2=A0129988 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 773991 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00
>>
>> Kernel=3D2.6.34-rc5
>> DIR=3D/mnt/iostestmnt/fio =C2=A0 =C2=A0 =C2=A0 =C2=A0DEV=3D/dev/mapper/m=
pathe
>> Workload=3Dbsr =C2=A0 =C2=A0 =C2=A0iosched=3Dnoop =C2=A0 =C2=A0Filesz=3D=
2G =C2=A0 bs=3D4K
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> job =C2=A0 =C2=A0 =C2=A0 Set NR =C2=A0ReadBW(KB/s) =C2=A0 MaxClat(us) =
=C2=A0 =C2=A0WriteBW(KB/s) =C2=A0MaxClat(us)
>> --- =C2=A0 =C2=A0 =C2=A0 --- -- =C2=A0------------ =C2=A0 ----------- =
=C2=A0 =C2=A0------------- =C2=A0-----------
>> bsr =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 1 =C2=A0 126187 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 95272 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00
>> bsr =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 2 =C2=A0 185154 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 72908 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00
>> bsr =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 4 =C2=A0 224622 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 88037 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A00
>> bsr =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 8 =C2=A0 285416 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 115592 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00
>> bsr =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 16 =C2=A0348564 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 156846 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A00
>>
>
> These numbers are very similar to what I got.
>
>> So in case of NOOP, throughput shotup to 348MB/s but CFQ reamains more o=
r
>> less constat, about 130MB/s.
>>
>> So atleast in this case, a single sequential CFQ queue is not keeing the
>> disk busy enough.
>>
>> I am wondering why my testing results were different in the past. May be
>> it was a different piece of hardware and behavior various across hardwar=
e?
>
> Probably. =C2=A0I haven't seen this type of behavior on other hardware.
>
>> Anyway, if that's the case, then we probably need to allow IO from
>> multiple sequential readers and keep a watch on throughput. If throughpu=
t
>> drops then reduce the number of parallel sequential readers. Not sure ho=
w
>> much of code that is but with multiple cfqq going in parallel, ioprio
>> logic will more or less stop working in CFQ (on multi-spindle hardware).
Hi Vivek,
I tried to implement exactly what you are proposing, see the attached patch=
es.
I leverage the queue merging features to let multiple cfqqs share the
disk in the same timeslice.
I changed the queue split code to trigger on throughput drop instead
of on seeky pattern, so diverging queues can remain merged if they
have good throughput. Moreover, I measure the max bandwidth reached by
single queues and merged queues (you can see the values in the
bandwidth sysfs file).
If merged queues can outperform non-merged ones, the queue merging
code will try to opportunistically merge together queues that cannot
submit enough requests to fill half of the NCQ slots. I'd like to know
if you can see any improvements out of this on your hardware. There
are some magic numbers in the code, you may want to try tuning them.
Note that, since the opportunistic queue merging will start happening
only after merged queues have shown to reach higher bandwidth than
non-merged queues, you should use the disk for a while before trying
the test (and you can check sysfs), or the merging will not happen.

>
> Have you tested on older kernels? =C2=A0Around 2.6.16 it seemed to allow =
more
> parallel reads, but that might have been just accidental (due to I/O
> being submitted in a different pattern).
Is the BW for 1 single reader also better on 2.6.16, or the
improvement is only seen with more concurrent readers?

Thanks,
Corrado
>
> Thanks,
> Miklos
>
>

--0016367b5f20bf9617048501804b
Content-Type: application/octet-stream; 
	name="0001-cfq-iosched-introduce-bandwidth-measurement.patch"
Content-Disposition: attachment; 
	filename="0001-cfq-iosched-introduce-bandwidth-measurement.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g8eviwam0

RnJvbSAxZDQyYmVhOTE5MDkwYzg5YjAxNmUzMDQ4MjI2MDQ3NWVhNTNhNzI0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDb3JyYWRvIFpvY2NvbG8gPGN6b2Njb2xvQGdtYWlsLmNvbT4K
RGF0ZTogRnJpLCAyMyBBcHIgMjAxMCAyMjoyMTozMCArMDIwMApTdWJqZWN0OiBbUEFUQ0ggMS8y
XSBjZnEtaW9zY2hlZDogaW50cm9kdWNlIGJhbmR3aWR0aCBtZWFzdXJlbWVudAoKLS0tCiBibG9j
ay9jZnEtaW9zY2hlZC5jIHwgICAzMCArKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0KIDEg
ZmlsZXMgY2hhbmdlZCwgMjggaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9ibG9jay9jZnEtaW9zY2hlZC5jIGIvYmxvY2svY2ZxLWlvc2NoZWQuYwppbmRleCA4Mzg4
MzRiLi42NTUxNzI2IDEwMDY0NAotLS0gYS9ibG9jay9jZnEtaW9zY2hlZC5jCisrKyBiL2Jsb2Nr
L2NmcS1pb3NjaGVkLmMKQEAgLTU0LDcgKzU0LDcgQEAgc3RhdGljIGNvbnN0IGludCBjZnFfaGlz
dF9kaXZpc29yID0gNDsKIAogI2RlZmluZSBSUV9DSUMocnEpCQlcCiAJKChzdHJ1Y3QgY2ZxX2lv
X2NvbnRleHQgKikgKHJxKS0+ZWxldmF0b3JfcHJpdmF0ZSkKLSNkZWZpbmUgUlFfQ0ZRUShycSkJ
CShzdHJ1Y3QgY2ZxX3F1ZXVlICopICgocnEpLT5lbGV2YXRvcl9wcml2YXRlMikKKyNkZWZpbmUg
UlFfQ0ZRUShycSkJCSgoc3RydWN0IGNmcV9xdWV1ZSAqKSAoKHJxKS0+ZWxldmF0b3JfcHJpdmF0
ZTIpKQogCiBzdGF0aWMgc3RydWN0IGttZW1fY2FjaGUgKmNmcV9wb29sOwogc3RhdGljIHN0cnVj
dCBrbWVtX2NhY2hlICpjZnFfaW9jX3Bvb2w7CkBAIC0xNDUsNiArMTQ1LDcgQEAgc3RydWN0IGNm
cV9xdWV1ZSB7CiAJc3RydWN0IGNmcV9ncm91cCAqb3JpZ19jZnFnOwogCS8qIFNlY3RvcnMgZGlz
cGF0Y2hlZCBpbiBjdXJyZW50IGRpc3BhdGNoIHJvdW5kICovCiAJdW5zaWduZWQgbG9uZyBucl9z
ZWN0b3JzOworCXVuc2lnbmVkIHRyYW5zZmVycmVkOwogfTsKIAogLyoKQEAgLTI0MSw2ICsyNDIs
MTIgQEAgc3RydWN0IGNmcV9kYXRhIHsKIAkgKi8KIAlpbnQgaHdfdGFnX2VzdF9kZXB0aDsKIAl1
bnNpZ25lZCBpbnQgaHdfdGFnX3NhbXBsZXM7CisJLyoKKwkgKiBwZXJmb3JtYW5jZSBtZWFzdXJl
bWVudHMKKwkgKiBtYXhfYncgaXMgaW5kZXhlZCBieSBjb29wIGZsYWcuCisJICovCisJdW5zaWdu
ZWQgbWF4X2J3WzJdOworCXVuc2lnbmVkIGN1cl9idzsKIAogCS8qCiAJICogaWRsZSB3aW5kb3cg
bWFuYWdlbWVudApAQCAtMTQyMiw2ICsxNDI5LDcgQEAgc3RhdGljIHZvaWQgY2ZxX2FjdGl2YXRl
X3JlcXVlc3Qoc3RydWN0IHJlcXVlc3RfcXVldWUgKnEsIHN0cnVjdCByZXF1ZXN0ICpycSkKIAkJ
CQkJCWNmcWQtPnJxX2luX2RyaXZlcik7CiAKIAljZnFkLT5sYXN0X3Bvc2l0aW9uID0gYmxrX3Jx
X3BvcyhycSkgKyBibGtfcnFfc2VjdG9ycyhycSk7CisJUlFfQ0ZRUShycSktPnRyYW5zZmVycmVk
ICs9IGJsa19ycV9zZWN0b3JzKHJxKTsKIH0KIAogc3RhdGljIHZvaWQgY2ZxX2RlYWN0aXZhdGVf
cmVxdWVzdChzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IHJlcXVlc3QgKnJxKQpAQCAt
MTQzMCw2ICsxNDM4LDcgQEAgc3RhdGljIHZvaWQgY2ZxX2RlYWN0aXZhdGVfcmVxdWVzdChzdHJ1
Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IHJlcXVlc3QgKnJxKQogCiAJV0FSTl9PTighY2Zx
ZC0+cnFfaW5fZHJpdmVyKTsKIAljZnFkLT5ycV9pbl9kcml2ZXItLTsKKwlSUV9DRlFRKHJxKS0+
dHJhbnNmZXJyZWQgLT0gYmxrX3JxX3NlY3RvcnMocnEpOwogCWNmcV9sb2dfY2ZxcShjZnFkLCBS
UV9DRlFRKHJxKSwgImRlYWN0aXZhdGUgcnEsIGRydj0lZCIsCiAJCQkJCQljZnFkLT5ycV9pbl9k
cml2ZXIpOwogfQpAQCAtMTU1Miw2ICsxNTYxLDggQEAgc3RhdGljIHZvaWQKIF9fY2ZxX3NsaWNl
X2V4cGlyZWQoc3RydWN0IGNmcV9kYXRhICpjZnFkLCBzdHJ1Y3QgY2ZxX3F1ZXVlICpjZnFxLAog
CQkgICAgYm9vbCB0aW1lZF9vdXQpCiB7CisJdW5zaWduZWQgdXNlZF9zbGljZSA9IGppZmZpZXMg
LSBjZnFxLT5zbGljZV9zdGFydDsKKwl1bnNpZ25lZCBidyA9IGNmcWQtPm1heF9id1sxXTsKIAlj
ZnFfbG9nX2NmcXEoY2ZxZCwgY2ZxcSwgInNsaWNlIGV4cGlyZWQgdD0lZCIsIHRpbWVkX291dCk7
CiAKIAlpZiAoY2ZxX2NmcXFfd2FpdF9yZXF1ZXN0KGNmcXEpKQpAQCAtMTU2MCwxMyArMTU3MSwy
MCBAQCBfX2NmcV9zbGljZV9leHBpcmVkKHN0cnVjdCBjZnFfZGF0YSAqY2ZxZCwgc3RydWN0IGNm
cV9xdWV1ZSAqY2ZxcSwKIAljZnFfY2xlYXJfY2ZxcV93YWl0X3JlcXVlc3QoY2ZxcSk7CiAJY2Zx
X2NsZWFyX2NmcXFfd2FpdF9idXN5KGNmcXEpOwogCisJaWYgKHVzZWRfc2xpY2UgPiBIWiAvIDEw
MCAmJiB1c2VkX3NsaWNlID4gMikgeworCQlidyA9IGNmcXEtPnRyYW5zZmVycmVkIC8gdXNlZF9z
bGljZTsKKwkJY2ZxZC0+Y3VyX2J3ID0gYnc7CisJCWNmcWQtPm1heF9id1tjZnFfY2ZxcV9jb29w
KGNmcXEpXSA9CisJCQltYXgoY2ZxZC0+bWF4X2J3W2NmcV9jZnFxX2Nvb3AoY2ZxcSldLCBidyk7
CisJfQorCWNmcXEtPnRyYW5zZmVycmVkID0gMDsKIAkvKgogCSAqIElmIHRoaXMgY2ZxcSBpcyBz
aGFyZWQgYmV0d2VlbiBtdWx0aXBsZSBwcm9jZXNzZXMsIGNoZWNrIHRvCiAJICogbWFrZSBzdXJl
IHRoYXQgdGhvc2UgcHJvY2Vzc2VzIGFyZSBzdGlsbCBpc3N1aW5nIEkvT3Mgd2l0aGluCiAJICog
dGhlIG1lYW4gc2VlayBkaXN0YW5jZS4gIElmIG5vdCwgaXQgbWF5IGJlIHRpbWUgdG8gYnJlYWsg
dGhlCiAJICogcXVldWVzIGFwYXJ0IGFnYWluLgogCSAqLwotCWlmIChjZnFfY2ZxcV9jb29wKGNm
cXEpICYmIENGUVFfU0VFS1koY2ZxcSkpCisJaWYgKGNmcV9jZnFxX2Nvb3AoY2ZxcSkgJiYgYncg
PD0gY2ZxZC0+bWF4X2J3WzFdICogOS8xMCkKIAkJY2ZxX21hcmtfY2ZxcV9zcGxpdF9jb29wKGNm
cXEpOwogCiAJLyoKQEAgLTM3NzYsNiArMzc5NCwxMyBAQCBmYWlsOgogLyoKICAqIHN5c2ZzIHBh
cnRzIGJlbG93IC0tPgogICovCitzdGF0aWMgc3NpemVfdCBiYW5kd2lkdGhfc2hvdyhzdHJ1Y3Qg
ZWxldmF0b3JfcXVldWUgKmUsIGNoYXIgKnBhZ2UpCit7CisJc3RydWN0IGNmcV9kYXRhICpjZnFk
ID0gZS0+ZWxldmF0b3JfZGF0YTsKKwlyZXR1cm4gc3ByaW50ZihwYWdlLCAiJWRcdCVkXHQlZFxu
IiwgY2ZxZC0+Y3VyX2J3LAorCQkgICAgICAgY2ZxZC0+bWF4X2J3WzBdLCBjZnFkLT5tYXhfYndb
MV0pOworfQorCiBzdGF0aWMgc3NpemVfdAogY2ZxX3Zhcl9zaG93KHVuc2lnbmVkIGludCB2YXIs
IGNoYXIgKnBhZ2UpCiB7CkBAIC0zODYxLDYgKzM4ODYsNyBAQCBzdGF0aWMgc3RydWN0IGVsdl9m
c19lbnRyeSBjZnFfYXR0cnNbXSA9IHsKIAlDRlFfQVRUUihzbGljZV9pZGxlKSwKIAlDRlFfQVRU
Uihsb3dfbGF0ZW5jeSksCiAJQ0ZRX0FUVFIoZ3JvdXBfaXNvbGF0aW9uKSwKKwlfX0FUVFJfUk8o
YmFuZHdpZHRoKSwKIAlfX0FUVFJfTlVMTAogfTsKIAotLSAKMS42LjIuNQoK
--0016367b5f20bf9617048501804b
Content-Type: application/octet-stream; 
	name="0002-cfq-iosched-optimistic-queue-merging.patch"
Content-Disposition: attachment; 
	filename="0002-cfq-iosched-optimistic-queue-merging.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g8evjaxh1

RnJvbSAxOTQzNWY2MThjMTA3MmE0OGE2NjUzMWMxNzIxOGEzZmJjMGE0MWNkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDb3JyYWRvIFpvY2NvbG8gPGN6b2Njb2xvQGdtYWlsLmNvbT4K
RGF0ZTogU2F0LCAyNCBBcHIgMjAxMCAxNTozOTozMSArMDIwMApTdWJqZWN0OiBbUEFUQ0ggMi8y
XSBjZnEtaW9zY2hlZDogb3B0aW1pc3RpYyBxdWV1ZSBtZXJnaW5nLgoKLS0tCiBibG9jay9jZnEt
aW9zY2hlZC5jIHwgICA0MSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0t
LQogMSBmaWxlcyBjaGFuZ2VkLCAzMyBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2Jsb2NrL2NmcS1pb3NjaGVkLmMgYi9ibG9jay9jZnEtaW9zY2hlZC5jCmluZGV4
IDY1NTE3MjYuLjRlOWUwMTUgMTAwNjQ0Ci0tLSBhL2Jsb2NrL2NmcS1pb3NjaGVkLmMKKysrIGIv
YmxvY2svY2ZxLWlvc2NoZWQuYwpAQCAtMTQ2LDYgKzE0Niw3IEBAIHN0cnVjdCBjZnFfcXVldWUg
ewogCS8qIFNlY3RvcnMgZGlzcGF0Y2hlZCBpbiBjdXJyZW50IGRpc3BhdGNoIHJvdW5kICovCiAJ
dW5zaWduZWQgbG9uZyBucl9zZWN0b3JzOwogCXVuc2lnbmVkIHRyYW5zZmVycmVkOworCXVuc2ln
bmVkIGxhc3RfYnc7CiB9OwogCiAvKgpAQCAtMTU3NCw2ICsxNTc1LDcgQEAgX19jZnFfc2xpY2Vf
ZXhwaXJlZChzdHJ1Y3QgY2ZxX2RhdGEgKmNmcWQsIHN0cnVjdCBjZnFfcXVldWUgKmNmcXEsCiAJ
aWYgKHVzZWRfc2xpY2UgPiBIWiAvIDEwMCAmJiB1c2VkX3NsaWNlID4gMikgewogCQlidyA9IGNm
cXEtPnRyYW5zZmVycmVkIC8gdXNlZF9zbGljZTsKIAkJY2ZxZC0+Y3VyX2J3ID0gYnc7CisJCWNm
cXEtPmxhc3RfYncgPSBidzsKIAkJY2ZxZC0+bWF4X2J3W2NmcV9jZnFxX2Nvb3AoY2ZxcSldID0K
IAkJCW1heChjZnFkLT5tYXhfYndbY2ZxX2NmcXFfY29vcChjZnFxKV0sIGJ3KTsKIAl9CkBAIC0x
Njk2LDggKzE2OTgsOSBAQCBzdGF0aWMgc3RydWN0IGNmcV9xdWV1ZSAqY2ZxcV9jbG9zZShzdHJ1
Y3QgY2ZxX2RhdGEgKmNmcWQsCiB7CiAJc3RydWN0IHJiX3Jvb3QgKnJvb3QgPSAmY2ZxZC0+cHJp
b190cmVlc1tjdXJfY2ZxcS0+b3JnX2lvcHJpb107CiAJc3RydWN0IHJiX25vZGUgKnBhcmVudCwg
Km5vZGU7Ci0Jc3RydWN0IGNmcV9xdWV1ZSAqX19jZnFxOworCXN0cnVjdCBjZnFfcXVldWUgKl9f
Y2ZxcSwgKl9fY2ZxcTE7CiAJc2VjdG9yX3Qgc2VjdG9yID0gY2ZxZC0+bGFzdF9wb3NpdGlvbjsK
Kwl1bnNpZ25lZCByczsKIAogCWlmIChSQl9FTVBUWV9ST09UKHJvb3QpKQogCQlyZXR1cm4gTlVM
TDsKQEAgLTE3MTUsNyArMTcxOCw3IEBAIHN0YXRpYyBzdHJ1Y3QgY2ZxX3F1ZXVlICpjZnFxX2Ns
b3NlKHN0cnVjdCBjZnFfZGF0YSAqY2ZxZCwKIAkgKiB3aWxsIGNvbnRhaW4gdGhlIGNsb3Nlc3Qg
c2VjdG9yLgogCSAqLwogCV9fY2ZxcSA9IHJiX2VudHJ5KHBhcmVudCwgc3RydWN0IGNmcV9xdWV1
ZSwgcF9ub2RlKTsKLQlpZiAoY2ZxX3JxX2Nsb3NlKGNmcWQsIGN1cl9jZnFxLCBfX2NmcXEtPm5l
eHRfcnEpKQorCWlmICghQ0ZRUV9TRUVLWShfX2NmcXEpICYmIGNmcV9ycV9jbG9zZShjZnFkLCBj
dXJfY2ZxcSwgX19jZnFxLT5uZXh0X3JxKSkKIAkJcmV0dXJuIF9fY2ZxcTsKIAogCWlmIChibGtf
cnFfcG9zKF9fY2ZxcS0+bmV4dF9ycSkgPCBzZWN0b3IpCkBAIC0xNzIzLDEyICsxNzI2LDM0IEBA
IHN0YXRpYyBzdHJ1Y3QgY2ZxX3F1ZXVlICpjZnFxX2Nsb3NlKHN0cnVjdCBjZnFfZGF0YSAqY2Zx
ZCwKIAllbHNlCiAJCW5vZGUgPSByYl9wcmV2KCZfX2NmcXEtPnBfbm9kZSk7CiAJaWYgKCFub2Rl
KQotCQlyZXR1cm4gTlVMTDsKLQotCV9fY2ZxcSA9IHJiX2VudHJ5KG5vZGUsIHN0cnVjdCBjZnFf
cXVldWUsIHBfbm9kZSk7Ci0JaWYgKGNmcV9ycV9jbG9zZShjZnFkLCBjdXJfY2ZxcSwgX19jZnFx
LT5uZXh0X3JxKSkKLQkJcmV0dXJuIF9fY2ZxcTsKLQorCQlfX2NmcXExID0gX19jZnFxOworCWVs
c2UKKwkJX19jZnFxMSA9IHJiX2VudHJ5KG5vZGUsIHN0cnVjdCBjZnFfcXVldWUsIHBfbm9kZSk7
CisKKwlpZiAoIUNGUVFfU0VFS1koX19jZnFxMSkgJiYgY2ZxX3JxX2Nsb3NlKGNmcWQsIGN1cl9j
ZnFxLCBfX2NmcXExLT5uZXh0X3JxKSkKKwkJcmV0dXJuIF9fY2ZxcTE7CisKKwkvLyBPcHBvcnR1
bmlzdGljIHF1ZXVlIG1lcmdpbmcgY291bGQgYmUgYmVuZWZpY2lhbCBldmVuIG9uIGZhciBxdWV1
ZXMKKwkvLyBXZSBlbmFibGUgaXQgb25seSBvbiBOQ1EgZGlza3MsIGlmIHdlIG9ic2VydmVkIHRo
YXQgbWVyZ2VkIHF1ZXVlcworCS8vIGNhbiByZWFjaCBoaWdoZXIgYmFuZHdpZHRoIHRoYW4gc2lu
Z2xlIHF1ZXVlcy4KKwlycyA9IGN1cl9jZnFxLT5hbGxvY2F0ZWRbUkVBRF0gKyBjdXJfY2ZxcS0+
YWxsb2NhdGVkW1dSSVRFXTsKKwlpZiAoY2ZxZC0+aHdfdGFnICYmIGNmcWQtPm1heF9id1sxXSA+
IGNmcWQtPm1heF9id1swXSAmJgorCSAgICAvLyBEbyBub3Qgb3ZlcmxvYWQgdGhlIGRldmljZSBx
dWV1ZQorCSAgICBycyA8IGNmcWQtPmh3X3RhZ19lc3RfZGVwdGggLyAyKSB7CisJCXVuc2lnbmVk
IHIxID0gX19jZnFxLT5hbGxvY2F0ZWRbUkVBRF0gKyBfX2NmcXEtPmFsbG9jYXRlZFtXUklURV07
CisJCXVuc2lnbmVkIHIyID0gX19jZnFxMS0+YWxsb2NhdGVkW1JFQURdICsgX19jZnFxMS0+YWxs
b2NhdGVkW1dSSVRFXTsKKwkJLy8gUHJlZmVyIG1lcmdpbmcgd2l0aCBhIHF1ZXVlIHRoYXQgaGFz
IGZld2VyIHBlbmRpbmcgcmVxdWVzdHMKKwkJaWYgKHIxID4gcjIgJiYgIUNGUVFfU0VFS1koX19j
ZnFxMSkpIHsKKwkJCV9fY2ZxcSA9IF9fY2ZxcTE7CisJCQlyMSA9IHIyOworCQl9CisJCS8vIERv
IG5vdCBtZXJnZSBpZiB0aGUgbWVyZ2VkIHF1ZXVlIHdvdWxkIGhhdmUgdG9vIG1hbnkgcmVxdWVz
dHMKKwkJaWYgKHIxICsgcnMgPiBjZnFkLT5od190YWdfZXN0X2RlcHRoIC8gMikKKwkJCXJldHVy
biBOVUxMOworCQkvLyBNZXJnZSBvbmx5IGlmIHRoZSBCVyBvZiB0aGUgdHdvIHF1ZXVlcyBpcyBj
b21wYXJhYmxlCisJCWlmIChhYnMoX19jZnFxLT5sYXN0X2J3IC0gY3VyX2NmcXEtPmxhc3RfYncp
ICogNCA8IGNmcWQtPm1heF9id1swXSkKKwkJCXJldHVybiBfX2NmcXE7CisJfQogCXJldHVybiBO
VUxMOwogfQogCi0tIAoxLjYuMi41Cgo=
--0016367b5f20bf9617048501804b--
