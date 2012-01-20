Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab2ATVwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 16:52:03 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43199 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab2ATVv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 16:51:59 -0500
MIME-Version: 1.0
In-Reply-To: <4F176605.5020101@zytor.com>
References: <20120116183730.GB21112@redhat.com> <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
 <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
 <20120118022217.GS11715@one.firstfloor.org> <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
 <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
 <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
 <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
 <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
 <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com>
 <4F1731C1.4050007@zytor.com> <4F1733DF.7040905@zytor.com> <4F1737C9.3070905@zytor.com>
 <CAB=4xhqW8RK2UpU5PPjSQo3nZYt8oZkaBf1VEhX37tbMVrAigg@mail.gmail.com>
 <4F173F48.2070604@zytor.com> <CA+55aFw3kv_JRsSCQEf6fQd0gX939MuoevDxFtcXkPY+bmyjtA@mail.gmail.com>
 <4F176605.5020101@zytor.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 20 Jan 2012 22:51:36 +0100
Message-ID: <CAK1hOcManWsEvjS2xxtfGTKx=JLPvO2sBkWU-xQP+medV=rbAA@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <mcgrathr@google.com>, Indan Zupancic <indan@nul.nu>,
        Andi Kleen <andi@firstfloor.org>, Jamie Lokier <jamie@shareable.org>,
        Andrew Lutomirski <luto@mit.edu>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Content-Type: multipart/mixed; boundary=f46d0443066483705704b6fcb09c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d0443066483705704b6fcb09c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 19, 2012 at 1:38 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/18/2012 03:28 PM, Linus Torvalds wrote:
>> On Wed, Jan 18, 2012 at 1:53 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>> I think we can obviously agree that regsets is the only way to go for
>>> any kind of new state.
>>
>> So I really don't necessarily agree at all.
>>
>> Exactly because there is a heavy burden to introducing new models.
>> It's not only relatively much more kernel code, it's also relatively
>> much more painful for user code. If we can hide it in existing
>> structures, user code is *much* better off, because any existing code
>> to get the state will just continue to work. Otherwise, you need to
>> have the code to figure out the new structures (how do you compile it
>> without the new kernel headers?), you need to do the extra accesses
>> conditionally etc etc.
>>
>> There's a real cost to introducing new interfaces. There's a *reason*
>> people try to make do with old ones.
>
> Of course. =A0However, the whole point with regsets is that at the very
> least the vast majority of the infrastructure is generic and extends
> without a bunch of new machine. =A0What you are saying is "we might be
> able to get away with existing state", what I'm saying is "if we add
> state it should be a regset".
>
> The question if this should be new state is currently open. =A0I
> personally would still would prefer if this didn't overlay real CPU state=
.

What about extending of one of the GETREGSET layouts?
GETREGSET uses struct iovec. struct iovec has buf_len.
Currently, if buf_len is larger than the register structure
being requested, kernel simply returns less data than
userspace asks for.

In the x86 case, we can add additional field(s) at
the end of NT_PRSTATUS layout.

Old programs which use PTRACE_GETREGS will get
old user_regs_struct layout (without appended fields).
Old programs which use
PTRACE_GETREGSET(NT_PRSTATUS, sizeof(struct user_regs_struct))
will also get the same.
New programs which use
PTRACE_GETREGSET(NT_PRSTATUS, sizeof(struct user_regs_struct) + N *
sizeof(long))
will get new fields too.

It's more intrusive than Linus' solution, but it avoids
the problem of overlaying real register data
with OS-specific special bits. It can also be employed
on other architectures (does not depend on having
a suitable register to abuse).

OTOH it is less intrusive than adding a whole new regset
just in order to add a few bits to an exiting one;
and would allow strace to extract both registers
and this new data with one operation instead of two.

Please see attached patch. NOT TESTED.

I'm new to this machinery, thus I might be missing some
obvious flaw with this idea (such as breaking on-disk
coredump format?)

--=20
vda

--f46d0443066483705704b6fcb09c
Content-Type: text/x-patch; charset=US-ASCII; name="add_one_word_to_regset0.diff"
Content-Disposition: attachment; filename="add_one_word_to_regset0.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gxnqnyfb0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9wdHJhY2UuYyBiL2FyY2gveDg2L2tlcm5lbC9w
dHJhY2UuYwppbmRleCA1MDI2NzM4Li4xNjQ1NWMwIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJu
ZWwvcHRyYWNlLmMKKysrIGIvYXJjaC94ODYva2VybmVsL3B0cmFjZS5jCkBAIC00MTksNiArNDE5
LDEwIEBAIHN0YXRpYyBpbnQgcHV0cmVnKHN0cnVjdCB0YXNrX3N0cnVjdCAqY2hpbGQsCiAJCWlm
IChjaGlsZC0+dGhyZWFkLmdzICE9IHZhbHVlKQogCQkJcmV0dXJuIGRvX2FyY2hfcHJjdGwoY2hp
bGQsIEFSQ0hfU0VUX0dTLCB2YWx1ZSk7CiAJCXJldHVybiAwOworCisJY2FzZSBzaXplb2Yoc3Ry
dWN0IHVzZXJfcmVnc19zdHJ1Y3QpICsgMCAqIHNpemVvZihsb25nKToKKwkJLyogTW9kaWZ5aW5n
IG9mIHRocmVhZF9pbmZvLT5zdGF0dXMgaXMgbm90IGFsbG93ZWQgKi8KKwkJcmV0dXJuIDA7CiAj
ZW5kaWYKIAl9CiAKQEAgLTQ2OSw2ICs0NzMsMTAgQEAgc3RhdGljIHVuc2lnbmVkIGxvbmcgZ2V0
cmVnKHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzaywgdW5zaWduZWQgbG9uZyBvZmZzZXQpCiAJCQly
ZXR1cm4gMDsKIAkJcmV0dXJuIGdldF9kZXNjX2Jhc2UoJnRhc2stPnRocmVhZC50bHNfYXJyYXlb
R1NfVExTXSk7CiAJfQorCisJY2FzZSBzaXplb2Yoc3RydWN0IHVzZXJfcmVnc19zdHJ1Y3QpICsg
MCAqIHNpemVvZihsb25nKToKKwkJLyogT25lIGRheSB3ZSBtaWdodCB3YW50IHRvIGV4cG9zZSBv
dGhlciBiaXRzIHRvbyAqLworCQlyZXR1cm4gKHRhc2tfdGhyZWFkX2luZm8odGFzayktPnN0YXR1
cyAmIFRTX0NPTVBBVCk7CiAjZW5kaWYKIAl9CiAKQEAgLTEyMDMsNyArMTIxMSw3IEBAIGxvbmcg
Y29tcGF0X2FyY2hfcHRyYWNlKHN0cnVjdCB0YXNrX3N0cnVjdCAqY2hpbGQsIGNvbXBhdF9sb25n
X3QgcmVxdWVzdCwKIHN0YXRpYyBzdHJ1Y3QgdXNlcl9yZWdzZXQgeDg2XzY0X3JlZ3NldHNbXSBf
X3JlYWRfbW9zdGx5ID0gewogCVtSRUdTRVRfR0VORVJBTF0gPSB7CiAJCS5jb3JlX25vdGVfdHlw
ZSA9IE5UX1BSU1RBVFVTLAotCQkubiA9IHNpemVvZihzdHJ1Y3QgdXNlcl9yZWdzX3N0cnVjdCkg
LyBzaXplb2YobG9uZyksCisJCS5uID0gKHNpemVvZihzdHJ1Y3QgdXNlcl9yZWdzX3N0cnVjdCkg
KyAxICogc2l6ZW9mKGxvbmcpKSAvIHNpemVvZihsb25nKSwKIAkJLnNpemUgPSBzaXplb2YobG9u
ZyksIC5hbGlnbiA9IHNpemVvZihsb25nKSwKIAkJLmdldCA9IGdlbnJlZ3NfZ2V0LCAuc2V0ID0g
Z2VucmVnc19zZXQKIAl9LAo=
--f46d0443066483705704b6fcb09c--
