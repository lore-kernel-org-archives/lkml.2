Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab2G2ALI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 20:11:08 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:51263 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2G2ALF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 20:11:05 -0400
Subject: Re: An Andre To Remember
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        lwn@lwn.net, Wim Coekaerts <wim.coekaerts@oracle.com>,
        "Lawrence E. Rosen" <lrosen@rosenlaw.com>,
        target-devel <target-devel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ralf Bacchle <ralf@linux-mips.org>
In-Reply-To: <20120727175655.GA23784@havoc.gtf.org>
References: <20120727175655.GA23784@havoc.gtf.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Jul 2012 17:11:02 -0700
Message-ID: <1343520662.22538.353.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-27 at 13:56 -0400, Jeff Garzik wrote:
> 	An Andre To Remember
> 	July 2012
> 
> Linux lost a friend and advocate this month.  Though never a household
> name, Andre Hedrick had a positive impact on everyone today running
> Linux, or using a website, with any form of IDE (ATA) or SCSI storage
> -- that means millions upon millions of users today.
> 
> For a time, Andre interacted with practically every relevant IDE
> drive and controller manufacturer, as well as the T13 standards
> committee through which IDE changes were made.  He helped ensure
> Linux had near-universal IDE support in a hardware era when Linux
> support was a second thought if at all.  As the Register article[1]
> noted, with CPRM and other efforts, Andre worked to keep storage a
> more open platform than it might otherwise have been.
> 
> [1] http://www.theregister.co.uk/2012/07/26/andre_hedrick/
> 
> Andre also played a role in IDE technology coalescing around the idea
> of a "taskfile", which is IDE-speak for an RPC command issued to a
> disk drive, and the RPC response returned from the drive.  It was
> very important to Andre that the kernel have a "taskfile ioctl",
> an API enabling full programmable access to the disk drive.  At the
> time, a more limited "cmd ioctl" API was the best option available,
> but Linux's cmd ioctl did not give users full and complete access to
> their own disk drive.
> 
> Andre's taskfile concept was a central component of the current,
> rewritten-from-scratch Linux IDE driver "libata."  libata uses an
> "ata_taskfile" to communicate with all IDE drives, whether from a
> decade ago or built yesterday.  The taskfile concept modernized
> IDE software, by forcing the industry to move away from a slow,
> signals-originated register API to a modern, packetized RPC messaging
> API, similar to where SCSI storage had already been moving.
> 
> I spent many hours on the phone with Andre, circa 2003, learning all
> there was to know about ATA storage, while writing libata.  Andre could
> be considered one of the grandfathers of libata, along with Alan Cox.
> I became friends with Andre during this time, and we talked a lot.
> 
> Andre was unquestionably smart, driven and an advocate for Linux user
> freedom.
> 

Hi Jeff,

Thank you for sharing your thoughts + memories of Andre.

As we grieve this extreme loss, I'd like to try to share some of my own
experiences with Andre that will hopefully help others to begin to
understand the kind + generous type of person that Andre really was, and
just some of his staggering technical feats + accomplishments that can
be talked about publicly today.

Along with Andre being involved in the history of libata and IDE/ATA
development, those of us in the Linux kernel storage development
community also know, he was also instrumental in creation of the
original out-of-tree PyX iSCSI target code that's now in mainline.

In summer 2002, I sitting next to Andre when he coined the term 'IBLOCK'
after drawing a rough sketch on a notebook after an idea in Walnut
Creek, California, and the name ending up sticking..   The interesting
development bits really started to unfold in the spring of 2004 when we
finally managed to get drivers/ide/ export working with iscsi-target on
x86 using 2.4.x code.  

That quickly unfolded into a Sony Playstation-2 (MIPS EE) port using IDE
disk DMA mode + network PIO on 2.2.x era kernel code capable of
streaming multiple DVD quality streams to hungry iSCSI clients..

Left to my own devices for hardware hacking, I managed to turn our first
disassembled PS2 into a broken parts machine (whoops) but Andre was
going to made sure that it was not going to happen again..  I bought
another PS2, and he was the person who soldered wires to the handful of
tiny via pin-outs to access the one-way serial output for EE boot
information last at night, while I worked on the necessary kernel bits
needed for bring-up of the PS2 specific IDE backend target driver.  (The
PS2 IDE driver required contiguous memory for IDE DMA ops to function
via a single struct buffer_head (TCQ=1) on the non-cache coherent MIPS
based platform.)

He carefully made physical space in the machine's cramped chassis, using
sticky pads where necessary to hold the small PCB containing a simple
ASIC doing the conversion of the signal into PC RS-232 serial output.
He made it look completely flush, like exactly how it was supposed to
come from the factory.  Or you know, from the magical place near the old
Bell Labs R&D center where new development kits for cutting edge tech
are born.

CBS Sunday Morning even did a story on Andre and his family in the
summer of 2004 while all of this was going on..  Not for the PS2
iscsi-target or any other code of course, but for the fact that he was
chosen by EBay to represent California small business as part of a group
that lobbied in Washington DC.  The reason that E-bay chose Andre is
because he built PyX using recycled server + storage hardware bought
from E-bay, including the family Mini-van often used to cart gear
between home, and even him driving the PyX team right up to the service
entrance of the Moscone Center show floor in downtown San Francisco.

So we managed to get iscsi_target_mod up + stable with three different
concurrent Linux x86, MSFT x86, and LinuxPPC laptops watching three
different DVD videos just in time LinuxWorld West that August.  All of
the hard work was leading up to a public demonstration in prime
real-estate of the Unbreakable Linux pavilion at the entrance to the
hall for PyX to have a hance to really show it's stuff.  The real-estate
at the expo was also comped by Oracle out of respect for Andre's work on
the Linux kernel.

I did not sleep for one second the night before the show, and was so
excited to be with Andre to show-off this particular demo to all of the
people at the expo.  I was part of a hard-earned demo that was going to
change the world with *the* Linux IDE guy!!

Andre was there that first day wearing a suit jacket + dockers + cowboy
boots (what he usually wore to conferences when doing serious buisness)
and it was one of the times during PyX that he really genuinely seemed
happy.  People where flocking to come and talk to *him*.   All of the
people walking by who stopped and saw the demo that summer who knew
Andre, understood that he pulled off something very special.  It was the
type of technology that even seemingly non-technical people are quickly
attracted to (especially younger people), and like a piece of technology
to those who don't understand it, or have had it explained in an
accessible manner, becomes indistinguishable from magic.  

But for Andre at the show that summer, I noticed it wasn’t so much about
the tech itself (and really did love the tech), or the social events, or
even about trying to work out some business angle for PyX, or anything
like that..

He was on the show-floor doing the thing that he really loved to do, and
people he had never met before where coming up in waves wanting to talk
to *him*.  Andre was always quick to greet new people at a technical
level that they could understand, and would also do his best when a
person came to him asking for help regardless of context.

Even if it was just a young programmer asking too many questions for a
trade-show about how the demo actually worked, while serious looking
business people waited impatiently behind..  Andre always took the time
to try to impart some of his own hard-earned knowledge and wisdom to
others with a hungry mind, also regardless of context.

I'm really going to to miss Andre very much, and my deepest thoughts go
out to his family + friends during this very difficult time.

--nab


