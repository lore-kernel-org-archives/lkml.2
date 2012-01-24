Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2AXWx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:53:28 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60127 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752392Ab2AXWxZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:53:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAOtrxKOjNwwAbuhrqTUdiV5M=790FwUetDTkMbRdbkR7bXNH4A@mail.gmail.com>
References: <CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
 <20120108221342.GA7058@ime.usp.br> <CA+55aFxmj_+0eLYqKZb6qWb_Zc4E4R8WrmbsVgv5BbNwvnqouQ@mail.gmail.com>
 <20120109112207.7f993845@jbarnes-desktop> <CA+55aFzmL0FTp_w7RWA0+mqS7YBL5HoNS1WY=2zxURgnvkOcjw@mail.gmail.com>
 <CAE9FiQVwbkxXbi4yFR4CCdpNr-bm2Bn13Jxap7mX6OrYbM+_kg@mail.gmail.com>
 <CAOtrxKMH2iyWOOtYTYCsK5eH_ZZm9zrJyh30H_7HG-36+8k_iA@mail.gmail.com>
 <CAE9FiQWg8k-_eHH-Erwn+iZgs-rDfPcSc7uPcF_h+1+mXVEVXQ@mail.gmail.com>
 <CAOtrxKOZ1yuWaAYxjPLE2obwTkCfRytRFyQc3VuK9JmJLYVrqw@mail.gmail.com>
 <CAE9FiQXCJobMuFWbyoWQpVup_pvKMuGpu7eotF0EJAx2_Ee7OQ@mail.gmail.com>
 <20120113115946.GA10615@ime.usp.br> <CAE9FiQX_koTHsjP8w=FyiSaBgY6QnzyWD43AVUW1d4MzViJXCg@mail.gmail.com>
 <CAOtrxKN4FQSPUJpP47=4+XzjTpcOQj=Dy+MUWBVYu7mQHNaSXA@mail.gmail.com>
 <CAOtrxKM_ijORTP_5C4z0R79jy5O=_eX5iNJ_GmAqXf6d8OGe9g@mail.gmail.com>
 <CAE9FiQWbtByxJopU_SHLpiAJt_91qTs_=9dBFTYDHFh5OQQydg@mail.gmail.com>
 <CAOtrxKOy1msY_49GiVaaZ3GnORx8ifJYkiTjzDOe-Rk7LLD8rA@mail.gmail.com>
 <CAE9FiQV++kCaA-2Y0-zuR0NMzwcvd4LJ+5fdTECBPkZkhWD50Q@mail.gmail.com>
 <CAOtrxKNDTQVcg6wRJGxt_inva1YSDXG5YiO1EhH1Fs5ZDy+q3Q@mail.gmail.com>
 <CAE9FiQVPLQp+GzGsgON-nW6JKPE2_P6Aua8wHcgkOiLnhuJh4A@mail.gmail.com>
 <CAOtrxKNrMXkztu4Gtv_GFD_163fr18Au7DqyXEK-nacpu=-_eQ@mail.gmail.com>
 <CAOtrxKP6OQyf8TX8BYk+wTFNSZmLOZjHq-NBJqfnyh=PdAKSow@mail.gmail.com>
 <CAE9FiQWi5pMaKtyf_kwszO_m7fb15=d_2GpupNnSvbN61=X6bQ@mail.gmail.com> <CAOtrxKOjNwwAbuhrqTUdiV5M=790FwUetDTkMbRdbkR7bXNH4A@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 24 Jan 2012 15:53:03 -0700
Message-ID: <CAErSpo7imA4X+5F3_QKO7Nhm2cZAXC2ben+VmM7FhHzz9WrXjg@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?M=E1rcia_Coutinho_de_Brito?= <mcbrito@gmail.com>,
        Ram Pai <linuxram@us.ibm.com>, rui.zhang@intel.com
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 3:18 PM, Rogério Brito <rbrito@ime.usp.br> wrote:
> The only change is the `nopat` option, as suggested by Yinghai.

I like this idea.  Last August, when we first looked at the hang when
enabling ACPI, Len Brown suggested that the outb() that does the
transition triggers SMM, and the hang is likely in SMM (which is
basically invisible and undebuggable from Linux).  And he said "we've
had problems in the past with SMM relying on something that Windows
just happened to do -- such as different MTRRs."

I couldn't see any MTRR info in your video (probably goes by too fast
as it's very early).  You might be able to get that info by adding
another call to print_mtrr_state() later in boot.  Then it would be
interesting to try to get the corresponding info from Windows.

>    ACPI Exception: AE_BAD_PARAMETER, Thread 9340 could not acquire
> Mutex [0x1] (20120111/utmutex-276)
>
> which seems strange, particularly as I passed the option `acpi=off` to
> my kernel.

Definitely odd.  I don't think that should happen.  I see a couple
places where we might be able to get there even with ACPI disabled,
e.g., eeepc_wmi_check_atkd() -> acpi_get_devices() ->
acpi_ut_acquire_mutex().  You could find out by adding a dump_stack()
where that error is printed.  It'd be nice to fix it, but I don't
think it's related to the real problems on your box.

Bjorn
