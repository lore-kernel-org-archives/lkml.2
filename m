Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032Ab1JFSfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 14:35:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64992 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758996Ab1JFSfD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 14:35:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAObL_7FJy=BFmtuTd+CE_uF2+ra6LnQWGUp=g+1py_V9ukYvJg@mail.gmail.com>
References: <20111003090846.GA25136@localhost.pp.htv.fi> <CAObL_7GSQFr_PRtKY=H7r=yD7Qk-xvgbg5bV1=nU-qayG-mJdw@mail.gmail.com>
 <20111003173359.GA3072@localhost.pp.htv.fi> <CAObL_7Fi3mw5Azyhxx-vsdNuhJm8RewmYS97QvWa0F=cbYvegg@mail.gmail.com>
 <CAFLxGvzpvJ1mgdcbrq+3h5EA+VOhZDR9BY27uWGgsmV4TWYb4A@mail.gmail.com>
 <20111005223055.GG14406@localhost.pp.htv.fi> <CAObL_7GJ_WztLEgBhPhJGhDOJmPqiPXcHPqS=1_Fa=S9_PmpNw@mail.gmail.com>
 <CAObL_7Hhdfneba2C_4Bg+M=4LCmebFL0BvZKfw0P6xO=JQukcg@mail.gmail.com>
 <CAObL_7HL1M00D7XDCtMgO1kDSh64N7LvwB0DVd7c8Afi-Ki-Gw@mail.gmail.com>
 <CAFLxGvx0Cpu0ePytdCSSzfO2or3ZL3j5QrghOE5eWHZCJt6C6g@mail.gmail.com> <CAObL_7FJy=BFmtuTd+CE_uF2+ra6LnQWGUp=g+1py_V9ukYvJg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 6 Oct 2011 11:34:41 -0700
X-Google-Sender-Auth: Ouksv4C-M0wCmyAkDgh6Eh-8V80
Message-ID: <CA+55aFyskjs9qPkoFom16veQXy5a-beWF95A7mCFexqanRiiKQ@mail.gmail.com>
Subject: Re: [3.1 patch] x86: default to vsyscall=native
To: Andrew Lutomirski <luto@mit.edu>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 6, 2011 at 11:16 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>
> Fixing it will be annoying because the attached fancier version needs
> to work, too.  I could implement the whole mess in software, but it
> might be nicer to arrange for uaccess errors to stash some information
> somewhere (like in the thread_struct cr2 variable).

That should be easy enough to do. Just add it to the
"fixup_exception()" case in no_context().

                Linus
