Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab1AaD1S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 22:27:18 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61351 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab1AaD1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 22:27:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=SX0mu8L9iLrpg8dOOoc3Hn6NPUm7aVZCRvjabMWfjTK1D4mhTfCBNhYxmEEqXMDoiw
         siF9tc1Y2mqVhy91EXIXqQcwo9KjSK+MaebUgh9jEMVRBemPimbLRUlfpicWKcB+Vuvo
         /cmyr0PAIA2zBWwqvtzmXH/Sr6difrmn2PoGQ=
MIME-Version: 1.0
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Date: Mon, 31 Jan 2011 05:26:54 +0200
Message-ID: <AANLkTi=4CH2zFrDp6DAnSj3pa28MtymfG+NrtQ3iW5k-@mail.gmail.com>
Subject: [PATCH 2/2] RFC: selinux: sysctl: fix selinux labeling broken by last patch
To: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@parisplace.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Dave Chinner <dchinner@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux <selinux@tycho.nsa.gov>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: multipart/mixed; boundary=0050450143e7016b60049b1bfec7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0050450143e7016b60049b1bfec7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Eric's patch was rejected because it broke selinux labeling:
http://thread.gmane.org/gmane.linux.kernel.lsm/9807/focus=3D9841

       This seems to break labeling.  Prior to this patch, I see:

       # ls -lZ /proc/1/net/rpc/nfsd.fh
       -rw-------. root root system_u:object_r:sysctl_rpc_t:s0 channel

       with the patch:

       # ls -lZ /proc/1/net/rpc/nfsd.fh
       -rw-------. root root system_u:object_r:proc_t:s0      channel

My patch seems to have fixed this problem (it correctly reports
sysctl_rpc_t in this case), but my selinux experience is =CE=B5 > 0 and I
have no ideea what else it may have broken.

I ran 'find /proc | xargs ls -Z > f' on a kernel with an without
these patches:
* http://swarm.cs.pub.ro/~lucian/store/ls-Z-with-patch
* http://swarm.cs.pub.ro/~lucian/store/ls-Z-without-patch

My setup is a custom busybox live CD with selinux enabled, with
/etc/selinux and /usr/share/selinux/default copied from Ubuntu 10.10's
selinux-policy-default package. I'm sure there are lots of reasons why
this is not correcly configured, etc., but I have no experience
regarding selinux. I can make all the scripts/sources/configs/etc
available to anyone interested.

NOTE: this patch will be merged with:
  security/selinux: Simplify proc inode to security label mapping

I'm only prividing this patch separately to point out the differences
to Eric W. Biederman's patch.

Both of these patches apply cleanly agains Linux 2.6.37.

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 fs/proc/proc_sysctl.c    |    1 -
 security/selinux/hooks.c |   20 ++++++++++++++++----
 2 files changed, 16 insertions(+), 5 deletions(-)

--0050450143e7016b60049b1bfec7
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0002-RFC-selinux-sysctl-fix-selinux-labeling-broken-by-la.patch"
Content-Disposition: attachment; 
	filename="0002-RFC-selinux-sysctl-fix-selinux-labeling-broken-by-la.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: 110397b064c22d36_0.1

ZGlmZiAtLWdpdCBhL2ZzL3Byb2MvcHJvY19zeXNjdGwuYyBiL2ZzL3Byb2MvcHJvY19zeXNjdGwu
Yw0KaW5kZXggYjY1MmNiMC4uYjE3NjE5ZCAxMDA2NDQNCi0tLSBhL2ZzL3Byb2MvcHJvY19zeXNj
dGwuYw0KKysrIGIvZnMvcHJvYy9wcm9jX3N5c2N0bC5jDQpAQCAtMzEsNyArMzEsNiBAQCBzdGF0
aWMgc3RydWN0IGlub2RlICpwcm9jX3N5c19tYWtlX2lub2RlKHN0cnVjdCBzdXBlcl9ibG9jayAq
c2IsDQogCWVpLT5zeXNjdGxfZW50cnkgPSB0YWJsZTsNCiANCiAJaW5vZGUtPmlfbXRpbWUgPSBp
bm9kZS0+aV9hdGltZSA9IGlub2RlLT5pX2N0aW1lID0gQ1VSUkVOVF9USU1FOw0KLQlpbm9kZS0+
aV9mbGFncyB8PSBTX1BSSVZBVEU7IC8qIHRlbGwgc2VsaW51eCB0byBpZ25vcmUgdGhpcyBpbm9k
ZSAqLw0KIAlpbm9kZS0+aV9tb2RlID0gdGFibGUtPm1vZGU7DQogCWlmICghdGFibGUtPmNoaWxk
KSB7DQogCQlpbm9kZS0+aV9tb2RlIHw9IFNfSUZSRUc7DQpkaWZmIC0tZ2l0IGEvc2VjdXJpdHkv
c2VsaW51eC9ob29rcy5jIGIvc2VjdXJpdHkvc2VsaW51eC9ob29rcy5jDQppbmRleCA1MTYxNWY2
Li41ZjU4MDE5IDEwMDY0NA0KLS0tIGEvc2VjdXJpdHkvc2VsaW51eC9ob29rcy5jDQorKysgYi9z
ZWN1cml0eS9zZWxpbnV4L2hvb2tzLmMNCkBAIC0xMTMyLDggKzExMzIsMjMgQEAgc3RhdGljIGlu
dCBzZWxpbnV4X3Byb2NfZ2V0X3NpZChzdHJ1Y3QgZGVudHJ5ICpkZW50cnksDQogCXBhdGggPSBk
ZW50cnlfcGF0aChkZW50cnksIGJ1ZmZlciwgUEFHRV9TSVpFKTsNCiAJaWYgKElTX0VSUihwYXRo
KSkNCiAJCXJjID0gUFRSX0VSUihwYXRoKTsNCi0JZWxzZQ0KKwllbHNlIHsNCisJCS8qIGJlY2F1
c2UgZGVudHJ5IGlzIG5vdCBoYXNoZWQsIGRlbnRyeV9wYXRoKCkgd2lsbA0KKwkJICogYXBwZW5k
ICIvL2RlbGV0ZWQiIHRvIHRoZSBlbmQgb2YgdGhlIHN0cmluZy4gV2UnbGwNCisJCSAqIHJlbW92
ZSB0aGlzIGFzIG5vIC9wcm9jLyBmaWxlIGlzIG5hbWVkIHNvLiAqLw0KKwkJaW50IHBhdGhsZW4g
PSBzdHJsZW4ocGF0aCk7DQorCQlpbnQgZGVsbGVuID0gc3RybGVuKCIvL2RlbGV0ZWQiKTsNCisJ
CWlmICgocGF0aGxlbiA+IGRlbGxlbikgJiYgc3RyY21wKHBhdGggKyBwYXRobGVuIC0gZGVsbGVu
LCAiLy9kZWxldGVkIikgPT0gMCkNCisJCQlwYXRoW3BhdGhsZW4tZGVsbGVuXSA9ICdcMCc7DQor
DQorCQkvKiBlYWNoIHByb2Nlc3MgZ2V0cyBhIC9wcm9jL1BJRC8gZW50cnkuIFN0cmlwIG9mZiB0
aGUNCisJCSAqIFBJRCBwYXJ0IHRvIGdldCBhIHZhbGlkIHNlbGludXggbGFiZWxpbmcuICovDQor
CQl3aGlsZSAocGF0aFsxXSA+PSAnMCcgJiYgcGF0aFsxXSA8PSAnOScpIHsNCisJCQlwYXRoWzFd
ID0gJy8nOw0KKwkJCXBhdGgrKzsNCisJCX0NCiAJCXJjID0gc2VjdXJpdHlfZ2VuZnNfc2lkKCJw
cm9jIiwgcGF0aCwgdGNsYXNzLCBzaWQpOw0KKwl9DQogCWZyZWVfcGFnZSgodW5zaWduZWQgbG9u
ZylidWZmZXIpOw0KIAlyZXR1cm4gcmM7DQogfQ0KQEAgLTE0NjQsOSArMTQ3OSw2IEBAIHN0YXRp
YyBpbnQgaW5vZGVfaGFzX3Blcm0oY29uc3Qgc3RydWN0IGNyZWQgKmNyZWQsDQogDQogCXZhbGlk
YXRlX2NyZWRzKGNyZWQpOw0KIA0KLQlpZiAodW5saWtlbHkoSVNfUFJJVkFURShpbm9kZSkpKQ0K
LQkJcmV0dXJuIDA7DQotDQogCXNpZCA9IGNyZWRfc2lkKGNyZWQpOw0KIAlpc2VjID0gaW5vZGUt
Pmlfc2VjdXJpdHk7DQogDQo=
--0050450143e7016b60049b1bfec7--
