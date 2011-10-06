Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab1JFSRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:17:24 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65060 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab1JFSRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:17:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvx0Cpu0ePytdCSSzfO2or3ZL3j5QrghOE5eWHZCJt6C6g@mail.gmail.com>
References: <20111003090846.GA25136@localhost.pp.htv.fi> <CAObL_7GSQFr_PRtKY=H7r=yD7Qk-xvgbg5bV1=nU-qayG-mJdw@mail.gmail.com>
 <20111003173359.GA3072@localhost.pp.htv.fi> <CAObL_7Fi3mw5Azyhxx-vsdNuhJm8RewmYS97QvWa0F=cbYvegg@mail.gmail.com>
 <CAFLxGvzpvJ1mgdcbrq+3h5EA+VOhZDR9BY27uWGgsmV4TWYb4A@mail.gmail.com>
 <20111005223055.GG14406@localhost.pp.htv.fi> <CAObL_7GJ_WztLEgBhPhJGhDOJmPqiPXcHPqS=1_Fa=S9_PmpNw@mail.gmail.com>
 <CAObL_7Hhdfneba2C_4Bg+M=4LCmebFL0BvZKfw0P6xO=JQukcg@mail.gmail.com>
 <CAObL_7HL1M00D7XDCtMgO1kDSh64N7LvwB0DVd7c8Afi-Ki-Gw@mail.gmail.com> <CAFLxGvx0Cpu0ePytdCSSzfO2or3ZL3j5QrghOE5eWHZCJt6C6g@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 6 Oct 2011 11:16:59 -0700
X-Google-Sender-Auth: 6i4wv3CCGHM7ZND_Ur2UnPA7JbQ
Message-ID: <CAObL_7FJy=BFmtuTd+CE_uF2+ra6LnQWGUp=g+1py_V9ukYvJg@mail.gmail.com>
Subject: Re: [3.1 patch] x86: default to vsyscall=native
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=bcaec520f433f165b504aea55513
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec520f433f165b504aea55513
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 6, 2011 at 8:37 AM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Thu, Oct 6, 2011 at 5:06 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>> I'll see how ugly the patch to get this all correct is. =A0It may not be
>> all that pretty because we won't be able to use sys_gettimeofday
>> anymore.
>
> BTW: The attached program triggers the issue.
>
> on 3.1-rc8+:
> # ./sig.dyn
> faulting address: 0xdeadbeef
> # ./sig.static
> [ =A0 19.075106] sig.static[863] vsyscall fault (exploit attempt?)
> ip:ffffffffff600000 cs:33 sp:7fff9e53d8c8 ax:ffffffffff600000 si:0
> di:deadbeef
> faulting address: 0x0
>
> I guess UML is not the only user of this feature...

I assume you wrote this to detect the problem :)

Fixing it will be annoying because the attached fancier version needs
to work, too.  I could implement the whole mess in software, but it
might be nicer to arrange for uaccess errors to stash some information
somewhere (like in the thread_struct cr2 variable).

--Andy

--bcaec520f433f165b504aea55513
Content-Type: text/x-csrc; charset=US-ASCII; name="sig.c"
Content-Disposition: attachment; filename="sig.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtg2iar31

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHNpZ25hbC5o
PgojaW5jbHVkZSA8c3lzL3RpbWUuaD4KI2luY2x1ZGUgPHN5cy9tbWFuLmg+CgpzdGF0aWMgdm9p
ZCBzaWdoYW5kbGVyKGludCBzaWcsIHNpZ2luZm9fdCAqc2ksIHZvaWQgKnVjKQp7CglwcmludGYo
ImZhdWx0aW5nIGFkZHJlc3M6IDB4JWx4XG4iLCAodW5zaWduZWQgbG9uZylzaS0+c2lfYWRkcik7
CgoJZXhpdCgxKTsKfQoKaW50IG1haW4oKQp7CgljaGFyICpwYWdlID0gbW1hcCgwLCA4MTkyLCBQ
Uk9UX05PTkUsIE1BUF9QUklWQVRFIHwgTUFQX0FOT05ZTU9VUywgLTEsIDApOwoJbXByb3RlY3Qo
cGFnZSwgNDA5NiwgUFJPVF9SRUFEIHwgUFJPVF9XUklURSk7CgoJc3RydWN0IHNpZ2FjdGlvbiBz
YTsKCglzYS5zYV9zaWdhY3Rpb24gPSAodm9pZCAqKXNpZ2hhbmRsZXI7CglzaWdlbXB0eXNldCgm
c2Euc2FfbWFzayk7CglzYS5zYV9mbGFncyA9IFNBX1NJR0lORk98IFNBX05PREVGRVI7CglzaWdh
Y3Rpb24oU0lHU0VHViwgJnNhLCBOVUxMKTsKCgl2b2lkICphY2Nlc3NfYWRkciA9IHBhZ2UgKyA0
MDk1OwoKCXByaW50ZigiTWFwcGVkIHBhZ2UgPSAlcDsgd2lsbCBhY2Nlc3MgJXBcbiIsIHBhZ2Us
IGFjY2Vzc19hZGRyKTsKCglnZXR0aW1lb2ZkYXkoYWNjZXNzX2FkZHIsIE5VTEwpOwoKCXJldHVy
biAwOwp9Cg==
--bcaec520f433f165b504aea55513--
