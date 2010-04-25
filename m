Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab0DYPLM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 11:11:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33696 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab0DYPLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 11:11:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=noo8RnBWR6HhkvC6Ep73SxR/0M/uPSmF6W2Xrkh1n5RzqNpLFCkuUj6g1lFDAK8t0c
         zIZy1m+YEMr+3IdrzCWQObAGwvzGCb2lYY+fLwT0+fzJgdxlnUMqmhQh8WjkkM6jI4Ev
         tstQPwIsD083oFu52/s4Wj8ANPESTqrdiKjo0=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sun, 25 Apr 2010 17:11:08 +0200
Message-ID: <l2z2d0a357f1004250811w6da355ebp95d1730473026c22@mail.gmail.com>
Subject: Re: [2.6.34-rc5-git6] EIP: is at inet6_csk_bind_conflict + 06xe/0xb7 
	[ipv6]
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Jiri Olsa <jolsa@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
       Jongman Heo <jongman.heo@gmail.com>
Content-Type: multipart/mixed; boundary=0016e6d46d7df183500485111184
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d46d7df183500485111184
Content-Type: text/plain; charset=UTF-8

[ Please CC - I am not subscribed to LKML ]

[QUOTE]

On 25.04.2010 16:26, Jongman Heo wrote:

> I also hit this bug today.

I also hit similar bug, maybe it is the same.

> Doing git bisect, first bad commit was
>
>   commit fda48a0d7a8412cedacda46a9c0bf8ef9cd13559
>   tcp: bind() fix when many ports are bound
>
> Reverting above commit fixes the problem.

How to do it? Would you please publish a reverting patch?

Regards,

Piotr Hosowicz

[/QUOTE]

Hi,

did forget to mention 2.6.34-rc5-git5 was OK.

Revering this commit did not help:

commit f4f914b58019f0e50d521bbbadfaee260d766f95
net: ipv6 bind to device issue

After looking into net-2.6 GIT repository, "tcp: bind() fix when many
ports are bound" could cause indeed the problems here, too.
Building now....

Regards,
- Sedat -

P.S.: Attached 0001-Revert-tcp-bind-fix-when-many-ports-are-bound.patch

--0016e6d46d7df183500485111184
Content-Type: text/x-diff; charset=US-ASCII; 
	name="0001-Revert-tcp-bind-fix-when-many-ports-are-bound.patch"
Content-Disposition: attachment; 
	filename="0001-Revert-tcp-bind-fix-when-many-ports-are-bound.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g8fzsvkl0

RnJvbSA5NDQxZTM0Y2E0MGI4MWE3Zjg0YmU4NDM5ZDJkODJkYmFkOTc5OTY3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBTdW4sIDI1IEFwciAyMDEwIDE2OjU0OjEzICswMjAwClN1YmplY3Q6IFtQQVRDSF0gUmV2
ZXJ0ICJ0Y3A6IGJpbmQoKSBmaXggd2hlbiBtYW55IHBvcnRzIGFyZSBib3VuZCIKClRoaXMgcmV2
ZXJ0cyBjb21taXQgZmRhNDhhMGQ3YTg0MTJjZWRhY2RhNDZhOWMwYmY4ZWY5Y2QxMzU1OS4KLS0t
CiBuZXQvaXB2NC9pbmV0X2Nvbm5lY3Rpb25fc29jay5jICB8ICAgMTYgKysrKystLS0tLS0tLS0t
LQogbmV0L2lwdjYvaW5ldDZfY29ubmVjdGlvbl9zb2NrLmMgfCAgIDE1ICsrKysrLS0tLS0tLS0t
LQogMiBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAyMSBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9uZXQvaXB2NC9pbmV0X2Nvbm5lY3Rpb25fc29jay5jIGIvbmV0L2lwdjQvaW5l
dF9jb25uZWN0aW9uX3NvY2suYwppbmRleCAxNDgyNWViLi44ZGE2NDI5IDEwMDY0NAotLS0gYS9u
ZXQvaXB2NC9pbmV0X2Nvbm5lY3Rpb25fc29jay5jCisrKyBiL25ldC9pcHY0L2luZXRfY29ubmVj
dGlvbl9zb2NrLmMKQEAgLTcwLDE3ICs3MCwxMyBAQCBpbnQgaW5ldF9jc2tfYmluZF9jb25mbGlj
dChjb25zdCBzdHJ1Y3Qgc29jayAqc2ssCiAJCSAgICAoIXNrLT5za19ib3VuZF9kZXZfaWYgfHwK
IAkJICAgICAhc2syLT5za19ib3VuZF9kZXZfaWYgfHwKIAkJICAgICBzay0+c2tfYm91bmRfZGV2
X2lmID09IHNrMi0+c2tfYm91bmRfZGV2X2lmKSkgewotCQkJY29uc3QgX19iZTMyIHNrMl9yY3Zf
c2FkZHIgPSBpbmV0X3Jjdl9zYWRkcihzazIpOwotCiAJCQlpZiAoIXJldXNlIHx8ICFzazItPnNr
X3JldXNlIHx8CiAJCQkgICAgc2syLT5za19zdGF0ZSA9PSBUQ1BfTElTVEVOKSB7CisJCQkJY29u
c3QgX19iZTMyIHNrMl9yY3Zfc2FkZHIgPSBpbmV0X3Jjdl9zYWRkcihzazIpOwogCQkJCWlmICgh
c2syX3Jjdl9zYWRkciB8fCAhc2tfcmN2X3NhZGRyIHx8CiAJCQkJICAgIHNrMl9yY3Zfc2FkZHIg
PT0gc2tfcmN2X3NhZGRyKQogCQkJCQlicmVhazsKLQkJCX0gZWxzZSBpZiAocmV1c2UgJiYgc2sy
LT5za19yZXVzZSAmJgotCQkJCSAgIHNrMl9yY3Zfc2FkZHIgJiYKLQkJCQkgICBzazJfcmN2X3Nh
ZGRyID09IHNrX3Jjdl9zYWRkcikKLQkJCQlicmVhazsKKwkJCX0KIAkJfQogCX0KIAlyZXR1cm4g
bm9kZSAhPSBOVUxMOwpAQCAtMTI0LDExICsxMjAsOSBAQCBhZ2FpbjoKIAkJCQkJCXNtYWxsZXN0
X3NpemUgPSB0Yi0+bnVtX293bmVyczsKIAkJCQkJCXNtYWxsZXN0X3JvdmVyID0gcm92ZXI7CiAJ
CQkJCQlpZiAoYXRvbWljX3JlYWQoJmhhc2hpbmZvLT5ic29ja2V0cykgPiAoaGlnaCAtIGxvdykg
KyAxKSB7Ci0JCQkJCQkJaWYgKCFpbmV0X2NzayhzayktPmljc2tfYWZfb3BzLT5iaW5kX2NvbmZs
aWN0KHNrLCB0YikpIHsKLQkJCQkJCQkJc3Bpbl91bmxvY2soJmhlYWQtPmxvY2spOwotCQkJCQkJ
CQlzbnVtID0gc21hbGxlc3Rfcm92ZXI7Ci0JCQkJCQkJCWdvdG8gaGF2ZV9zbnVtOwotCQkJCQkJ
CX0KKwkJCQkJCQlzcGluX3VubG9jaygmaGVhZC0+bG9jayk7CisJCQkJCQkJc251bSA9IHNtYWxs
ZXN0X3JvdmVyOworCQkJCQkJCWdvdG8gaGF2ZV9zbnVtOwogCQkJCQkJfQogCQkJCQl9CiAJCQkJ
CWdvdG8gbmV4dDsKZGlmZiAtLWdpdCBhL25ldC9pcHY2L2luZXQ2X2Nvbm5lY3Rpb25fc29jay5j
IGIvbmV0L2lwdjYvaW5ldDZfY29ubmVjdGlvbl9zb2NrLmMKaW5kZXggYjRiN2Q0MC4uNjI4ZGIy
NCAxMDA2NDQKLS0tIGEvbmV0L2lwdjYvaW5ldDZfY29ubmVjdGlvbl9zb2NrLmMKKysrIGIvbmV0
L2lwdjYvaW5ldDZfY29ubmVjdGlvbl9zb2NrLmMKQEAgLTQyLDE2ICs0MiwxMSBAQCBpbnQgaW5l
dDZfY3NrX2JpbmRfY29uZmxpY3QoY29uc3Qgc3RydWN0IHNvY2sgKnNrLAogCQlpZiAoc2sgIT0g
c2syICYmCiAJCSAgICAoIXNrLT5za19ib3VuZF9kZXZfaWYgfHwKIAkJICAgICAhc2syLT5za19i
b3VuZF9kZXZfaWYgfHwKLQkJICAgICBzay0+c2tfYm91bmRfZGV2X2lmID09IHNrMi0+c2tfYm91
bmRfZGV2X2lmKSkgewotCQkJaWYgKCghc2stPnNrX3JldXNlIHx8ICFzazItPnNrX3JldXNlIHx8
Ci0JCQkgICAgIHNrMi0+c2tfc3RhdGUgPT0gVENQX0xJU1RFTikgJiYKLQkJCSAgICAgaXB2Nl9y
Y3Zfc2FkZHJfZXF1YWwoc2ssIHNrMikpCi0JCQkJYnJlYWs7Ci0JCQllbHNlIGlmIChzay0+c2tf
cmV1c2UgJiYgc2syLT5za19yZXVzZSAmJgotCQkJCSFpcHY2X2FkZHJfYW55KGluZXQ2X3Jjdl9z
YWRkcihzazIpKSAmJgotCQkJCWlwdjZfcmN2X3NhZGRyX2VxdWFsKHNrLCBzazIpKQotCQkJCWJy
ZWFrOwotCQl9CisJCSAgICAgc2stPnNrX2JvdW5kX2Rldl9pZiA9PSBzazItPnNrX2JvdW5kX2Rl
dl9pZikgJiYKKwkJICAgICghc2stPnNrX3JldXNlIHx8ICFzazItPnNrX3JldXNlIHx8CisJCSAg
ICAgc2syLT5za19zdGF0ZSA9PSBUQ1BfTElTVEVOKSAmJgorCQkgICAgIGlwdjZfcmN2X3NhZGRy
X2VxdWFsKHNrLCBzazIpKQorCQkJYnJlYWs7CiAJfQogCiAJcmV0dXJuIG5vZGUgIT0gTlVMTDsK
LS0gCjEuNy4wLjUKCg==
--0016e6d46d7df183500485111184--
