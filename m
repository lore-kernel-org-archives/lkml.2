Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab1FHQeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 12:34:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50871 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab1FHQeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 12:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=J/qZZ3cpCvah1X8GZEP4Jb5UChcEMFA6uIIeOLGIJ8p9XVt28+oT1Pg9RfCyn/xhSV
         YG1jMyyF9JwC6CFzhk4FN9r5tiCBgVOh9Esh0+/lRR1MV9CmbdagDbuYIXVxGCVaxg0w
         wi/KY1ZQBP45BDR/IefCEr9XhI8dy+JpJkTkQ=
MIME-Version: 1.0
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 8 Jun 2011 18:33:39 +0200
Message-ID: <BANLkTin6CmO+PfyGkUL3fg3REGXU=7DS7g@mail.gmail.com>
Subject: [PATCH] make former thread ID available via PTRACE_GETEVENTMSG after
 PTRACE_EVENT_EXEC stop
To: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e6de04444c181d04a535e747
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6de04444c181d04a535e747
Content-Type: text/plain; charset=ISO-8859-1

Hi Oleg,

As discussed, the attached patch allows tracer to figure out
which of its potentially many tracees performed an execve,
and what was its former tid.

Not sure what kind of locking, if any, I need to put around
current->parent...

The patch is on top of Tejun's patches.

-- 
vda

--0016e6de04444c181d04a535e747
Content-Type: text/x-patch; charset=US-ASCII; 
	name="pass_old_pid_on_PTRACE_EVENT_EXEC.patch"
Content-Disposition: attachment; 
	filename="pass_old_pid_on_PTRACE_EVENT_EXEC.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_goohnxzq0

ZGlmZiAtLWdpdCBhL2ZzL2V4ZWMuYyBiL2ZzL2V4ZWMuYwppbmRleCBhOWYyYjM2Li4wOGIxMTcy
IDEwMDY0NAotLS0gYS9mcy9leGVjLmMKKysrIGIvZnMvZXhlYy5jCkBAIC0xMzgzLDggKzEzODMs
MTAgQEAgaW50IHNlYXJjaF9iaW5hcnlfaGFuZGxlcihzdHJ1Y3QgbGludXhfYmlucHJtICpicHJt
LHN0cnVjdCBwdF9yZWdzICpyZWdzKQogCQkJICovCiAJCQlicHJtLT5yZWN1cnNpb25fZGVwdGgg
PSBkZXB0aDsKIAkJCWlmIChyZXR2YWwgPj0gMCkgewotCQkJCWlmIChkZXB0aCA9PSAwKQotCQkJ
CQl0cmFjZWhvb2tfcmVwb3J0X2V4ZWMoZm10LCBicHJtLCByZWdzKTsKKwkJCQlpZiAoZGVwdGgg
PT0gMCkgeworCQkJCQlwaWRfdCBwaWQgPSB0YXNrX3BpZF9ucl9ucyhjdXJyZW50LCB0YXNrX2Fj
dGl2ZV9waWRfbnMoY3VycmVudC0+cGFyZW50KSk7CisJCQkJCXRyYWNlaG9va19yZXBvcnRfZXhl
YyhmbXQsIGJwcm0sIHJlZ3MsIHBpZCk7CisJCQkJfQogCQkJCXB1dF9iaW5mbXQoZm10KTsKIAkJ
CQlhbGxvd193cml0ZV9hY2Nlc3MoYnBybS0+ZmlsZSk7CiAJCQkJaWYgKGJwcm0tPmZpbGUpCmRp
ZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3RyYWNlaG9vay5oIGIvaW5jbHVkZS9saW51eC90cmFj
ZWhvb2suaAppbmRleCAxNTc0NWNkLi4zZjY1MDA1IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4
L3RyYWNlaG9vay5oCisrKyBiL2luY2x1ZGUvbGludXgvdHJhY2Vob29rLmgKQEAgLTE5OSw5ICsx
OTksMTAgQEAgc3RhdGljIGlubGluZSBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRyYWNlaG9va190cmFj
ZXJfdGFzayhzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRzaykKICAqLwogc3RhdGljIGlubGluZSB2b2lk
IHRyYWNlaG9va19yZXBvcnRfZXhlYyhzdHJ1Y3QgbGludXhfYmluZm10ICpmbXQsCiAJCQkJCSBz
dHJ1Y3QgbGludXhfYmlucHJtICpicHJtLAotCQkJCQkgc3RydWN0IHB0X3JlZ3MgKnJlZ3MpCisJ
CQkJCSBzdHJ1Y3QgcHRfcmVncyAqcmVncywKKwkJCQkJIHBpZF90IHBpZCkKIHsKLQlpZiAoIXB0
cmFjZV9ldmVudChQVF9UUkFDRV9FWEVDLCBQVFJBQ0VfRVZFTlRfRVhFQywgMCkgJiYKKwlpZiAo
IXB0cmFjZV9ldmVudChQVF9UUkFDRV9FWEVDLCBQVFJBQ0VfRVZFTlRfRVhFQywgcGlkKSAmJgog
CSAgICB1bmxpa2VseSh0YXNrX3B0cmFjZShjdXJyZW50KSAmIFBUX1BUUkFDRUQpKQogCQlzZW5k
X3NpZyhTSUdUUkFQLCBjdXJyZW50LCAwKTsKIH0K
--0016e6de04444c181d04a535e747--
