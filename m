Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964973Ab1JFPhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 11:37:42 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58052 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935224Ab1JFPhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 11:37:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAObL_7HL1M00D7XDCtMgO1kDSh64N7LvwB0DVd7c8Afi-Ki-Gw@mail.gmail.com>
References: <20111003090846.GA25136@localhost.pp.htv.fi>
	<CAObL_7GSQFr_PRtKY=H7r=yD7Qk-xvgbg5bV1=nU-qayG-mJdw@mail.gmail.com>
	<20111003173359.GA3072@localhost.pp.htv.fi>
	<CAObL_7Fi3mw5Azyhxx-vsdNuhJm8RewmYS97QvWa0F=cbYvegg@mail.gmail.com>
	<CAFLxGvzpvJ1mgdcbrq+3h5EA+VOhZDR9BY27uWGgsmV4TWYb4A@mail.gmail.com>
	<20111005223055.GG14406@localhost.pp.htv.fi>
	<CAObL_7GJ_WztLEgBhPhJGhDOJmPqiPXcHPqS=1_Fa=S9_PmpNw@mail.gmail.com>
	<CAObL_7Hhdfneba2C_4Bg+M=4LCmebFL0BvZKfw0P6xO=JQukcg@mail.gmail.com>
	<CAObL_7HL1M00D7XDCtMgO1kDSh64N7LvwB0DVd7c8Afi-Ki-Gw@mail.gmail.com>
Date: Thu, 6 Oct 2011 17:37:40 +0200
Message-ID: <CAFLxGvx0Cpu0ePytdCSSzfO2or3ZL3j5QrghOE5eWHZCJt6C6g@mail.gmail.com>
Subject: Re: [3.1 patch] x86: default to vsyscall=native
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=20cf307d0466dcbdcd04aea31a4d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf307d0466dcbdcd04aea31a4d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 6, 2011 at 5:06 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> I'll see how ugly the patch to get this all correct is. =A0It may not be
> all that pretty because we won't be able to use sys_gettimeofday
> anymore.

BTW: The attached program triggers the issue.

on 3.1-rc8+:
# ./sig.dyn
faulting address: 0xdeadbeef
# ./sig.static
[   19.075106] sig.static[863] vsyscall fault (exploit attempt?)
ip:ffffffffff600000 cs:33 sp:7fff9e53d8c8 ax:ffffffffff600000 si:0
di:deadbeef
faulting address: 0x0

I guess UML is not the only user of this feature...

--=20
Thanks,
//richard

--20cf307d0466dcbdcd04aea31a4d
Content-Type: text/x-csrc; charset=US-ASCII; name="sig.c"
Content-Disposition: attachment; filename="sig.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtfwpl3s0

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHNpZ25hbC5o
PgojaW5jbHVkZSA8c3lzL3RpbWUuaD4KCnN0YXRpYyB2b2lkIHNpZ2hhbmRsZXIoaW50IHNpZywg
c2lnaW5mb190ICpzaSwgdm9pZCAqdWMpCnsKCXByaW50ZigiZmF1bHRpbmcgYWRkcmVzczogMHgl
bHhcbiIsICh1bnNpZ25lZCBsb25nKXNpLT5zaV9hZGRyKTsKCglleGl0KDEpOwp9CgppbnQgbWFp
bigpCnsKCXN0cnVjdCBzaWdhY3Rpb24gc2E7CgogIHNhLnNhX3NpZ2FjdGlvbiA9ICh2b2lkICop
c2lnaGFuZGxlcjsKICBzaWdlbXB0eXNldCgmc2Euc2FfbWFzayk7CiAgc2Euc2FfZmxhZ3MgPSBT
QV9TSUdJTkZPfCBTQV9OT0RFRkVSOwogIHNpZ2FjdGlvbihTSUdTRUdWLCAmc2EsIE5VTEwpOwoK
CWdldHRpbWVvZmRheSgodm9pZCAqKTB4ZGVhZGJlZWYsIE5VTEwpOwoKCXJldHVybiAwOwp9Cg==
--20cf307d0466dcbdcd04aea31a4d--
