Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab1GNClq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 22:41:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38379 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab1GNClo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 22:41:44 -0400
MIME-Version: 1.0
In-Reply-To: <1310604899.27864.4.camel@gandalf.stny.rr.com>
References: <1309563076-5050-1-git-send-email-lacombar@gmail.com>
	<CACqU3MUrCODMx=8Bu+YDxy2BJwjm-77PXFob5OwHn=fr5mTdkg@mail.gmail.com>
	<1310170759.2780.37.camel@fedora>
	<1310604899.27864.4.camel@gandalf.stny.rr.com>
Date: Wed, 13 Jul 2011 22:41:44 -0400
Message-ID: <CACqU3MX4=AQyH4TXi+LaHV6WWRsLZpGf7c=iwQHm6Mqsr6SgYA@mail.gmail.com>
Subject: Re: [RFC 0/4] streamline_config clean-ups
From: Arnaud Lacombe <lacombar@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Rostedt <srostedt@redhat.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Content-Type: multipart/mixed; boundary=bcaec544eeec3a8c5004a7fe7916
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec544eeec3a8c5004a7fe7916
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 13, 2011 at 8:54 PM, Steven Rostedt <rostedt@goodmis.org> wrote=
:
> On Fri, 2011-07-08 at 20:19 -0400, Steven Rostedt wrote:
>> On Fri, 2011-07-08 at 17:47 -0400, Arnaud Lacombe wrote:
>> > Hi,
>> >
>> > On Fri, Jul 1, 2011 at 7:31 PM, Arnaud Lacombe <lacombar@gmail.com> wr=
ote:
>> > > Hi,
>> > >
>> > > The following series attempts to merge some redundants stuff in the =
kconfig
>> > > Makefile, namely how streamline_config learns about its environment,=
 avoids
>> > > multi-line shell command in kconfig's Makefile. Seconds commit also =
removes the
>> > > non-portable usage of sed(1) as -i is not POSIX compliant.
>> > >
>> > > Comments appreciated!
>> > >
>> > > =A0- Arnaud
>> > >
>> > Ping ?
>
> I just tried your patches out. It breaks when we compile for another
> directory. I just tried:
>
> $ make LSMOD=3D/tmp/lsmod O=3D../machine/build/ localmodconfig
>
> and it it did not work.
>
yes... it could not have. I missed a $(srctree), an export, and an
error check. Attached patch should fix it, behavior (see below) with
this patch is consistent between v3.0-rc6 and the tip of the patched
branch.

Btw, as of v3.0-rc6, localmodconfig does not produce a valid .config.
Local kernel is a Fedora 14 kernel, based on
config-2.6.35.13-91.fc14.x86_64. The perl script complete fine, but
the config is then restarted, I'm not sure if it is the intended
behavior.

 - Arnaud

--bcaec544eeec3a8c5004a7fe7916
Content-Type: text/x-patch; charset=US-ASCII; name="0001-fix.patch"
Content-Disposition: attachment; filename="0001-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gq341qi20

RnJvbSBkNmU3Y2FmMTk3YzEwYjQ0OGRhODczYzI3Y2Y1ZWY4OWY5YmNmNGIyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBcm5hdWQgTGFjb21iZSA8bGFjb21iYXJAZ21haWwuY29tPgpE
YXRlOiBXZWQsIDEzIEp1bCAyMDExIDIyOjI5OjI0IC0wNDAwClN1YmplY3Q6IFtQQVRDSF0gZml4
CgotLS0KIHNjcmlwdHMva2NvbmZpZy9NYWtlZmlsZSAgICAgICB8ICAgIDQgKysrLQogc2NyaXB0
cy9rY29uZmlnL2xvY2FsY29uZmlnLnNoIHwgICAgMiArKwogMiBmaWxlcyBjaGFuZ2VkLCA1IGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvc2NyaXB0cy9rY29uZmln
L01ha2VmaWxlIGIvc2NyaXB0cy9rY29uZmlnL01ha2VmaWxlCmluZGV4IGQ0OGRkYzkuLjFiZjQz
NzUgMTAwNjQ0Ci0tLSBhL3NjcmlwdHMva2NvbmZpZy9NYWtlZmlsZQorKysgYi9zY3JpcHRzL2tj
b25maWcvTWFrZWZpbGUKQEAgLTExLDYgKzExLDggQEAgZWxzZQogS2NvbmZpZyA6PSBLY29uZmln
CiBlbmRpZgogCitleHBvcnQgS2NvbmZpZworCiB4Y29uZmlnOiAkKG9iaikvcWNvbmYKIAkkPCAk
KEtjb25maWcpCiAKQEAgLTM0LDcgKzM2LDcgQEAgc2lsZW50b2xkY29uZmlnOiAkKG9iaikvY29u
ZgogCSQ8IC0tJEAgJChLY29uZmlnKQogCiBsb2NhbHllc2NvbmZpZyBsb2NhbG1vZGNvbmZpZzog
JChvYmopL3N0cmVhbWxpbmVfY29uZmlnLnBsICQob2JqKS9jb25mCi0JJChRKSQoc3JjKS9sb2Nh
bGNvbmZpZy5zaAorCSQoUSkkKHNyY3RyZWUpLyQoc3JjKS9sb2NhbGNvbmZpZy5zaAogCiAjIENy
ZWF0ZSBuZXcgbGludXgucG90IGZpbGUKICMgQWRqdXN0IGNoYXJzZXQgdG8gVVRGLTggaW4gLnBv
IGZpbGUgdG8gYWNjZXB0IFVURi04IGluIEtjb25maWcgZmlsZXMKZGlmZiAtLWdpdCBhL3Njcmlw
dHMva2NvbmZpZy9sb2NhbGNvbmZpZy5zaCBiL3NjcmlwdHMva2NvbmZpZy9sb2NhbGNvbmZpZy5z
aAppbmRleCA2NGRkMjk1Li5mODE4NWZiIDEwMDc1NQotLS0gYS9zY3JpcHRzL2tjb25maWcvbG9j
YWxjb25maWcuc2gKKysrIGIvc2NyaXB0cy9rY29uZmlnL2xvY2FsY29uZmlnLnNoCkBAIC0xLDYg
KzEsOCBAQAogIyEvYmluL3NoCiAjCiAKK3NldCAtZQorCiBta2RpciAtcCBpbmNsdWRlL2dlbmVy
YXRlZAogCiBwZXJsICIke3NyY3RyZWV9L3NjcmlwdHMva2NvbmZpZy9zdHJlYW1saW5lX2NvbmZp
Zy5wbCIgJHtzcmN0cmVlfS8gJHtLY29uZmlnfSAkMSA+IC50bXAuY29uZmlnCi0tIAoxLjcuMy40
LjU3NC5nNjA4Yi5kaXJ0eQoK
--bcaec544eeec3a8c5004a7fe7916--
