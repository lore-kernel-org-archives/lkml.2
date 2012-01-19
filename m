Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab2ASDuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 22:50:23 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:65322 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757299Ab2ASDuW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 22:50:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWbtByxJopU_SHLpiAJt_91qTs_=9dBFTYDHFh5OQQydg@mail.gmail.com>
References: <CA+55aFxP-Xhz2Yb+g6VsTAPs704oC_DhbuxSqbCGmmr_CCHoPg@mail.gmail.com>
	<20120108221342.GA7058@ime.usp.br>
	<CA+55aFxmj_+0eLYqKZb6qWb_Zc4E4R8WrmbsVgv5BbNwvnqouQ@mail.gmail.com>
	<20120109112207.7f993845@jbarnes-desktop>
	<CA+55aFzmL0FTp_w7RWA0+mqS7YBL5HoNS1WY=2zxURgnvkOcjw@mail.gmail.com>
	<CAE9FiQVwbkxXbi4yFR4CCdpNr-bm2Bn13Jxap7mX6OrYbM+_kg@mail.gmail.com>
	<CAOtrxKMH2iyWOOtYTYCsK5eH_ZZm9zrJyh30H_7HG-36+8k_iA@mail.gmail.com>
	<CAE9FiQWg8k-_eHH-Erwn+iZgs-rDfPcSc7uPcF_h+1+mXVEVXQ@mail.gmail.com>
	<CAOtrxKOZ1yuWaAYxjPLE2obwTkCfRytRFyQc3VuK9JmJLYVrqw@mail.gmail.com>
	<CAE9FiQXCJobMuFWbyoWQpVup_pvKMuGpu7eotF0EJAx2_Ee7OQ@mail.gmail.com>
	<20120113115946.GA10615@ime.usp.br>
	<CAE9FiQX_koTHsjP8w=FyiSaBgY6QnzyWD43AVUW1d4MzViJXCg@mail.gmail.com>
	<CAOtrxKN4FQSPUJpP47=4+XzjTpcOQj=Dy+MUWBVYu7mQHNaSXA@mail.gmail.com>
	<CAOtrxKM_ijORTP_5C4z0R79jy5O=_eX5iNJ_GmAqXf6d8OGe9g@mail.gmail.com>
	<CAE9FiQWbtByxJopU_SHLpiAJt_91qTs_=9dBFTYDHFh5OQQydg@mail.gmail.com>
Date: Thu, 19 Jan 2012 01:50:19 -0200
X-Google-Sender-Auth: zVAdZzNyX5RIicV_kXlnX0Zo0z8
Message-ID: <CAOtrxKOy1msY_49GiVaaZ3GnORx8ifJYkiTjzDOe-Rk7LLD8rA@mail.gmail.com>
Subject: Re: [Bug 41722] Clevo M5X0JE hangs in ACPI init
From: =?UTF-8?Q?Rog=C3=A9rio_Brito?= <rbrito@ime.usp.br>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Edward Donovan <edward.donovan@numble.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?M=C3=A1rcia_Coutinho_de_Brito?= <mcbrito@gmail.com>,
        Ram Pai <linuxram@us.ibm.com>, rui.zhang@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, people.

Sorry about the delay, but I have gathered a bunch of information
about the machine.

For the record, I tried to put some order on the subdirectory at:

    http://www.ime.usp.br/~rbrito/linux/clevo/

On Sat, Jan 14, 2012 at 19:05, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Jan 13, 2012 at 11:09 PM, Rogério Brito <rbrito@ime.usp.br> wrote:
>> A warning, though is that there were some options regarding PCI buses
>> which I did not know exactly how to answer. I can post my config here
>> if you are interested in that. Well, actually, I can give you ssh
>> access to this notebook if you want to hack on it. Just let me know
>> what times you (or anyone else) are online and I will try to arrange
>> everything.

Regarding these options, Yinghai, the options which I enabled once I
typed "make oldconfig" were:

CONFIG_PCI_PRI
CONFIG_PCI_PASID

> Please enable CONFIG_BOOT_PRINTK_DELAY in your .config
>
> and boot with "boot_delay=1000" or even "boot_delay=5000"
>
> then video capture could help.

I did just that and uploaded a video from Linus's git tree with the
options above to:

    http://youtu.be/_dYhkWHfep0

It took a long time to boot (about 7 minutes), but all details are
there, I hope.  I can repeat the same steps for your for-pci2 branch,
if you want me to.

Bjorn wrote:
> 1) Your M5X0JE is horribly broken, but I couldn't find any similar
> reports on the web, so I wonder if there's a BIOS setting or something
> that's unique to your system.

After searching, and searching, and searching, I could find this
thread (in Portuguese) of some people with this computer, all of them
having problems with multiple distributions (which is not a surprise,
as the kernel has problems with these machines):

    http://www.forumdebian.com.br/topico-notebook-amazon-pc-amz-a-101-resolvido

Just for the record, this Clevo was rebranded by a company called
Amazon PC (the model is A101). Amazon PC has disappeared from Earth.

> Can you (a) capture the current BIOS
> settings (photos of SETUP screens or something) and (b) reset to
> factory defaults and see if anything changes?  If things work better
> with the defaults, knowing what the difference is might help us fix
> Linux.

I took pictures of the few setup screens, and I reset everything to
factory defaults, but still no luck. You can see the photos at:

    http://www.ime.usp.br/~rbrito/linux/clevo/photos/

> 2) Can you use a Windows tool like AIDA64 (free trial version at
> http://www.aida64.com/downloads) to collect information about how
> Windows configures the box?

Sure, I downloaded it an generated some reports. Two of them with this
tool that you mentioned and one with lshw. They are at:

    http://www.ime.usp.br/~rbrito/linux/clevo/hardware-description/

--- Comment #16 from Zhang Rui <rui.zhang@intel.com>  2012-01-18 05:39:52 ---
hmm, what's the status of this bug?
does the problem still exist in the latest upstream kernel?

Yes, Zhang. Both bugs:

    https://bugzilla.kernel.org/show_bug.cgi?id=41622
    https://bugzilla.kernel.org/show_bug.cgi?id=41722

are still reproducible with the latest kernels. Please, don't close them.

OK. I'm going to bed right now, but I will be happy to provide any
further information or test any patches/trees.


Thanks for all the help,

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
