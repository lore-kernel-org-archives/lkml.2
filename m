Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589Ab0LTPqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:46:51 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:53993 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab0LTPqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:46:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=O64tchYnNIOBNRcuzBPyAVWWdRYhWRjhFqQFJfBdsgEokEcXWhYl2PX4iovykqxYlm
         NLEJ9fiZT5agR1HgqPMFJ+gnqZMRFQrHkrkjMDfVAtgQEY41bamJ7RqItdELfVaT79rX
         icGYDv+Kfxrb8RuFsl5iSH2pPYNibKSK5Id+g=
MIME-Version: 1.0
In-Reply-To: <1292851159.5021.2.camel@laptop>
References: <1290281700.28711.9.camel@maggy.simson.net>
	<tip-5091faa449ee0b7d73bc296a93bca9540fc51d0a@git.kernel.org>
	<AANLkTimRfVFmuMJzuirgsc37=RhC6zKX0C0YXhXO44O9@mail.gmail.com>
	<1292851159.5021.2.camel@laptop>
Date: Mon, 20 Dec 2010 21:16:47 +0530
Message-ID: <AANLkTi=3-FpuzXZ8xoEWCPhKrwydDOj0m4n-eEh-2BdT@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Add 'autogroup' scheduling feature:
 automated per session task groups
From: Bharata B Rao <bharata.rao@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, torvalds@linux-foundation.org,
        efault@gmx.de, pjt@google.com, markus@trippelsdorf.de,
        tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015174c108c7ef6f70497d96dc4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174c108c7ef6f70497d96dc4
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Dec 20, 2010 at 6:49 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2010-12-20 at 18:38 +0530, Bharata B Rao wrote:
>> The autogroup patchset removes the display of cgroup name from
>> sched_debug output.
>
> Hrmph.. that wasn't supposed to happen, care to send a patch to fix that
> up?

There are two aspects here:

- Printing cgroup name for per-CPU cfs_rqs shouldn't be affected by
  autogroup and the old code should work here.
- Printing cgroup name for tasks depends on task_group(), which has
been changed by autogroup patch. I haven't really looked deep into
autogroup patch, but from whatever I can gather, Mike had a reason
to remove this bit from sched_debug. The task groups created for
autogroups don't have cgroups associated with them and hence no
dentries and hence no pathnames.

I guess we could do fix this as shown in the attached patch.

>
>
>> Also, with tg_shares_up improvements, the leaf cfs_rqs are maintained
>> on rq->leaf_cfs_rq_list only if they carry any load. But the code to
>> display cfs_rq information for sched_debug isn't updated and hence
>> information from a few cfs_rqs are missing from sched_debug.
>
> Well, that's a _good_ thing, right?
>
> I mean, if we know they're empty, and don't contribute to schedule, why
> bother displaying them?

In addition to tasks, we do display other details pertaining to the cfs_rq.
I thought, having a complete view of all the cfs_rqs in the system would
be better and consistent than obtaining different cfs_rqs on different
captures of /proc/sched_debug.

Regards,
Bharata.
-- 
http://bharata.sulekha.com/blog/posts.htm, http://raobharata.wordpress.com/

--0015174c108c7ef6f70497d96dc4
Content-Type: application/octet-stream; name="fix-sched-debug.patch"
Content-Disposition: attachment; filename="fix-sched-debug.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghxjfiop0

UmUtaW5zdGF0ZSBjZ3JvdXAgbmFtZXMgaW4gL3Byb2Mvc2NoZWRfZGVidWcuCgpBdXRvZ3JvdXAg
cGF0Y2ggcmVtb3ZlZCBkaXNwbGF5aW5nIHRoZSBjZ3JvdXAgcGF0aG5hbWVzCmZvciBwZXItQ1BV
IGNmc19ycXMgYW5kIHRhc2tzIGluIC9wcm9jL3NjaGVkX2RlYnVnLgpSZS1pbnN0YXRlIHRoaXMu
CgpTaWduZWQtb2ZmLWJ5OiBCaGFyYXRhIEIgUmFvIDxiaGFyYXRhLnJhb0BnbWFpbC5jb20+CgpJ
bmRleDogbGludXgtMi42LXRpcC9rZXJuZWwvc2NoZWRfZGVidWcuYwo9PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBs
aW51eC0yLjYtdGlwLm9yaWcva2VybmVsL3NjaGVkX2RlYnVnLmMJMjAxMC0xMi0xMSAwMToyNTo1
OC4wMDAwMDAwMDAgKzA1MzAKKysrIGxpbnV4LTIuNi10aXAva2VybmVsL3NjaGVkX2RlYnVnLmMJ
MjAxMC0xMi0yMSAwMjoyMzowNS4wMDAwMDAwMDAgKzA1MzAKQEAgLTg2LDYgKzg2LDI1IEBACiB9
CiAjZW5kaWYKIAorI2lmIGRlZmluZWQoQ09ORklHX0NHUk9VUF9TQ0hFRCkgJiYgXAorCShkZWZp
bmVkKENPTkZJR19GQUlSX0dST1VQX1NDSEVEKSB8fCBkZWZpbmVkKENPTkZJR19SVF9HUk9VUF9T
Q0hFRCkpCisvKgorICogVGhpcyBpcyBlc3NlbnRpYWxseSBzYW1lIGFzIHNjaGVkLmM6dGFza19n
cm91cCBleGNlcHQKKyAqIHRoYXQgaXQgZG9lc24ndCBib3RoZXIgYWJvdXQgYXV0b2dyb3Vwcy4g
RXNzZW50aWFsbHkKKyAqIHRoaXMgaXMgaG93IHRhc2tfZ3JvdXAoKSBsb29rZWQgbGlrZSBiZWZv
cmUgYXV0b2dyb3VwCisgKiBjaGFuZ2VzLgorICogTmFtZWQgdGFza19zY2hlZF9ncm91cCgpIGZv
ciB3YW50IG9mIGEgYmV0dGVyIG5hbWUuCisgKi8KK3N0YXRpYyBzdHJ1Y3QgdGFza19ncm91cCAq
dGFza19zY2hlZF9ncm91cChzdHJ1Y3QgdGFza19zdHJ1Y3QgKnApCit7CisJc3RydWN0IGNncm91
cF9zdWJzeXNfc3RhdGUgKmNzczsKKworCWNzcyA9IHRhc2tfc3Vic3lzX3N0YXRlX2NoZWNrKHAs
IGNwdV9jZ3JvdXBfc3Vic3lzX2lkLAorCQkJbG9ja2RlcF9pc19oZWxkKCZ0YXNrX3JxKHApLT5s
b2NrKSk7CisJcmV0dXJuIGNvbnRhaW5lcl9vZihjc3MsIHN0cnVjdCB0YXNrX2dyb3VwLCBjc3Mp
OworfQorI2VuZGlmCisKIHN0YXRpYyB2b2lkCiBwcmludF90YXNrKHN0cnVjdCBzZXFfZmlsZSAq
bSwgc3RydWN0IHJxICpycSwgc3RydWN0IHRhc2tfc3RydWN0ICpwKQogewpAQCAtMTA4LDYgKzEy
NywxNiBAQAogCVNFUV9wcmludGYobSwgIiUxNUxkICUxNUxkICUxNUxkLiUwNmxkICUxNUxkLiUw
NmxkICUxNUxkLiUwNmxkIiwKIAkJMExMLCAwTEwsIDBMTCwgMEwsIDBMTCwgMEwsIDBMTCwgMEwp
OwogI2VuZGlmCisjaWZkZWYgQ09ORklHX0NHUk9VUF9TQ0hFRAorCXsKKwkJY2hhciBwYXRoWzY0
XTsKKworCQlyY3VfcmVhZF9sb2NrKCk7CisJCWNncm91cF9wYXRoKHRhc2tfc2NoZWRfZ3JvdXAo
cCktPmNzcy5jZ3JvdXAsIHBhdGgsIHNpemVvZihwYXRoKSk7CisJCXJjdV9yZWFkX3VubG9jaygp
OworCQlTRVFfcHJpbnRmKG0sICIgJXMiLCBwYXRoKTsKKwl9CisjZW5kaWYKIAogCVNFUV9wcmlu
dGYobSwgIlxuIik7CiB9CkBAIC0xMzYsNiArMTY1LDE5IEBACiAJcmVhZF91bmxvY2tfaXJxcmVz
dG9yZSgmdGFza2xpc3RfbG9jaywgZmxhZ3MpOwogfQogCisjaWYgZGVmaW5lZChDT05GSUdfQ0dS
T1VQX1NDSEVEKSAmJiBcCisJKGRlZmluZWQoQ09ORklHX0ZBSVJfR1JPVVBfU0NIRUQpIHx8IGRl
ZmluZWQoQ09ORklHX1JUX0dST1VQX1NDSEVEKSkKK3N0YXRpYyB2b2lkIHRhc2tfZ3JvdXBfcGF0
aChzdHJ1Y3QgdGFza19ncm91cCAqdGcsIGNoYXIgKmJ1ZiwgaW50IGJ1ZmxlbikKK3sKKwkvKiBt
YXkgYmUgTlVMTCBpZiB0aGUgdW5kZXJseWluZyBjZ3JvdXAgaXNuJ3QgZnVsbHktY3JlYXRlZCB5
ZXQgKi8KKwlpZiAoIXRnLT5jc3MuY2dyb3VwKSB7CisJCWJ1ZlswXSA9ICdcMCc7CisJCXJldHVy
bjsKKwl9CisJY2dyb3VwX3BhdGgodGctPmNzcy5jZ3JvdXAsIGJ1ZiwgYnVmbGVuKTsKK30KKyNl
bmRpZgorCiB2b2lkIHByaW50X2Nmc19ycShzdHJ1Y3Qgc2VxX2ZpbGUgKm0sIGludCBjcHUsIHN0
cnVjdCBjZnNfcnEgKmNmc19ycSkKIHsKIAlzNjQgTUlOX3ZydW50aW1lID0gLTEsIG1pbl92cnVu
dGltZSwgbWF4X3ZydW50aW1lID0gLTEsCkBAIC0xNDQsNyArMTg2LDE2IEBACiAJc3RydWN0IHNj
aGVkX2VudGl0eSAqbGFzdDsKIAl1bnNpZ25lZCBsb25nIGZsYWdzOwogCisjaWYgZGVmaW5lZChD
T05GSUdfQ0dST1VQX1NDSEVEKSAmJiBkZWZpbmVkKENPTkZJR19GQUlSX0dST1VQX1NDSEVEKQor
CWNoYXIgcGF0aFsxMjhdOworCXN0cnVjdCB0YXNrX2dyb3VwICp0ZyA9IGNmc19ycS0+dGc7CisK
Kwl0YXNrX2dyb3VwX3BhdGgodGcsIHBhdGgsIHNpemVvZihwYXRoKSk7CisKKwlTRVFfcHJpbnRm
KG0sICJcbmNmc19ycVslZF06JXNcbiIsIGNwdSwgcGF0aCk7CisjZWxzZQogCVNFUV9wcmludGYo
bSwgIlxuY2ZzX3JxWyVkXTpcbiIsIGNwdSk7CisjZW5kaWYKIAlTRVFfcHJpbnRmKG0sICIgIC4l
LTMwczogJUxkLiUwNmxkXG4iLCAiZXhlY19jbG9jayIsCiAJCQlTUExJVF9OUyhjZnNfcnEtPmV4
ZWNfY2xvY2spKTsKIAo=
--0015174c108c7ef6f70497d96dc4--
