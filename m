Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab1DNGox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 02:44:53 -0400
Received: from nm9.bullet.mail.bf1.yahoo.com ([98.139.212.168]:43783 "HELO
	nm9.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754573Ab1DNGov convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 02:44:51 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 588312.91182.bm@omp1004.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=PwmVhuMWfEtHoHaW71lIHfn2P5yuV7cTp8ZtHDyv5E3VOUWaTWMeS6FmhqTDfGKAhLEsyLHFLkzIB8XKwX6kGc1HX30ITVe5C3hli2xbKCQwYjnF/ZQswVZ+k428A+kv7iet2OohJH9/SgxZwnBCa3o3geXoRApSdHp/oC/XSN0=;
Message-ID: <475805.23113.qm@web162014.mail.bf1.yahoo.com>
X-YMail-OSG: Hd_CzI8VM1n0YduNh5ca..bfxFI6tW0CNRrfPxi7chSPeQV
 EsFW5YRqZ7GLf29HUth.6NIrHFoxOjh8kYt_fZEvaPYipSEVPLN6lRFaxULm
 sc9xRgyAor.5wNB8_g7e4JiGc_pYKH_F_xIRNLMNjTwofxBxG_jhQTSJduht
 ALPRXqJQnlctxcMc2a9UF9Yj70XQmz5T7x.mPjnbfAH8dOqMdUIfORwDq648
 AGOxUBlGl32kstLfQEuVPA6HJDF3MYy7Dh48r5AaCviiA2BAiJ7he2AgVFAc
 IZsvMa0CR9IOeZ_21WArqyvJwrm_WNdomDVBS1W_c3ykmCuhZLK37tOK6pTN
 V5Og8Or7Kw0QlQGl1blKdRfHYISQB_cJUUNu92Qj9vdvmuJh0CqTUVmM-
X-Mailer: YahooMailClassic/12.0.2 YahooMailWebService/0.8.109.295617
Date: Wed, 13 Apr 2011 23:44:50 -0700 (PDT)
From: Pintu Agarwal <pintu_agarwal@yahoo.com>
Subject: Re: Regarding memory fragmentation using malloc....
To: =?iso-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Michal Nazarewicz <mina86@mina86.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Changli Gao <xiaosuo@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, azurIt <azurit@pobox.sk>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <op.vtvuf5sk3l0zgt@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Mr. Michal for all your comments :)

As I can understand from your comments that, malloc from user space will not have much impact on memory fragmentation. 
Will the memory fragmentation be visible if I do kmalloc from the kernel module????

> No.  When you call malloc() only virtual address space
> is allocated.  The
> actual allocation of physical space occurs when user space
> accesses the
> memory (either reads or writes) and it happens page at a
> time.

Here, if I do memset then I am accessing the memory...right? That I am doing already in my sample program.

> what really happens is that kernel allocates the 0-order
> pages and when
> it runs out of those, splits a 1-order page into two
> 0-order pages and
> takes one of those.

Actually, if I understand buddy allocator, it allocates pages from top to bottom. That means it checks for the highest order block that can be allocated, if possible it allocates pages from that block otherwise split the next highest block into two.
What will happen if the next higher blocks are all empty???


Is the memory fragmentation is always a cause of the kernel space program and not user space at all??


Can you provide me with some references for migitating memory fragmentation in linux?



Thanks,
Pintu


--- On Wed, 4/13/11, Michal Nazarewicz <mina86@mina86.com> wrote:

> From: Michal Nazarewicz <mina86@mina86.com>
> Subject: Re: Regarding memory fragmentation using malloc....
> To: "Américo Wang" <xiyou.wangcong@gmail.com>, "Pintu Agarwal" <pintu_agarwal@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Eric Dumazet" <eric.dumazet@gmail.com>, "Changli Gao" <xiaosuo@gmail.com>, "Jiri Slaby" <jslaby@suse.cz>, "azurIt" <azurit@pobox.sk>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>
> Date: Wednesday, April 13, 2011, 10:25 AM
> On Wed, 13 Apr 2011 15:56:00 +0200,
> Pintu Agarwal <pintu_agarwal@yahoo.com>
> wrote:
> > My requirement is, I wanted to measure memory
> fragmentation level in linux kernel2.6.29 (ARM cortex A8
> without swap).
> > How can I measure fragmentation level(percentage) from
> /proc/buddyinfo ?
> 
> [...]
> 
> > In my linux2.6.29 ARM machine, the initial
> /proc/buddyinfo shows the following:
> > Node 0, zone      DMA 
>    17     22   
>   1      1      0 
>     1      1     
> 0      0      0   
>   0      0
> > Node 1, zone      DMA 
>    15    320    423 
>   225     97 
>    26      1   
>   0      0      0 
>     0      0
> > 
> > After running my sample program (with 16 iterations)
> the buddyinfo output is as follows:
> > Requesting <16> blocks of memory of block size
> <262144>........
> > Node 0, zone      DMA 
>    17     22   
>   1      1      0 
>     1      1     
> 0      0      0   
>   0      0
> > Node 1, zone      DMA 
>    15    301    419 
>   224     96 
>    27      1   
>   0      0      0 
>     0      0
> >     nr_free_pages 169
> >     nr_free_pages 6545
> > *****************************************
> > 
> > 
> > Node 0, zone      DMA 
>    17     22   
>   1      1      0 
>     1      1     
> 0      0      0   
>   0      0
> > Node 1, zone      DMA 
>    18      2   
> 305    226     96 
>    27      1   
>   0      0      0 
>     0      0
> >     nr_free_pages 169
> >     nr_free_pages 5514
> > -----------------------------------------
> > 
> > The requested block size is 64 pages (2^6) for each
> block.
> > But if we see the output after 16 iterations the
> buddyinfo allocates pages only from Node 1 , (2^0, 2^1, 2^2,
> 2^3).
> > But the actual allocation should happen from (2^6)
> block in buddyinfo.
> 
> No.  When you call malloc() only virtual address space
> is allocated.  The
> actual allocation of physical space occurs when user space
> accesses the
> memory (either reads or writes) and it happens page at a
> time.
> 
> As a matter of fact, if you have limited number of 0-order
> pages and
> allocates in user space block of 64 pages later accessing
> the memory,
> what really happens is that kernel allocates the 0-order
> pages and when
> it runs out of those, splits a 1-order page into two
> 0-order pages and
> takes one of those.
> 
> Because of MMU, fragmentation of physical memory is not an
> issue for
> normal user space programs.
> 
> It becomes an issue once you deal with hardware that does
> not have MMU
> nor support for scatter-getter DMA or with some big kernel
> structures.
> 
> /proc/buddyinfo tells you how many free pages of given
> order there are
> in the system.  You may interpret it in such a way
> that the bigger number
> of the low order pages the bigger fragmentation of physical
> memory.  If
> there was no fragmentation (for some definition of the
> term) you'd get only
> the highest order pages and at most one page for each lower
> order.
> 
> Again though, this fragmentation is not an issue for user
> space programs.
> 
> --Best regards,           
>                
>              _ 
>    _
> .o. | Liege of Serenely Enlightened Majesty of   
>   o' \,=./ `o
> ..o | Computer Science,  Michal "mina86"
> Nazarewicz    (o o)
> ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
> 
