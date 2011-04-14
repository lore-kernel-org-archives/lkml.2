Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab1DNMZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 08:25:00 -0400
Received: from nm4.bullet.mail.bf1.yahoo.com ([98.139.212.163]:30943 "HELO
	nm4.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754292Ab1DNMY6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 08:24:58 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 91442.69174.bm@omp1020.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=xzjz8eC8Ot8sCimPE1SlGM6PmB6hbCdVRkwkawOvO6syzKyh6TQxgYU2BAmZJ0swzi2caxc+qGoctt6HvchYsJCkC4laF15lFIxaolFLZDPjTI5IQJCysv+C3tZw2bLLR7ao122G1h8YSysEbbIKsXJumJaEcTRQYAmP+1lloIc=;
Message-ID: <858878.89812.qm@web162015.mail.bf1.yahoo.com>
X-YMail-OSG: Jj0ZCOoVM1kMF9dhKopX6A6e9hHIKcq7JABptIPpQI2qIzz
 2Y04vhLAnMsvM77boFRQwey8p9Bw9jznoGvUQL1EjPoM4axy553LBH..81wt
 o29.LeSNYkTtNma2DAQ5vIqQvnsHarO6IN4D6N5yWabh941txWd9EAT2KK0u
 sWIFwyGm4mK4OeJ7ahC3ypCuw3dlXGd45mIRf57WbD2v1HdaONe8yXm6NVyi
 xaavMRgD71gFhZdRVHy9GYKnuJebs02fpKTALbNWTVovKl5xwjjChPUFGL6K
 yS2QSk8BQORM0px2bb9EcsroGLb8XS1Zn81MxxccEmvLLFDhf5saMw00c9v4
 7fH4ZExB7zOtvLxD2lgHfSAIpXxCL7fomQdovWQ5gJ1RAaysOt6wbvwZG
X-Mailer: YahooMailClassic/12.0.2 YahooMailWebService/0.8.109.295617
Date: Thu, 14 Apr 2011 05:24:56 -0700 (PDT)
From: Pintu Agarwal <pintu_agarwal@yahoo.com>
Subject: Re: Regarding memory fragmentation using malloc....
To: =?iso-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Michal Nazarewicz <mina86@mina86.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Changli Gao <xiaosuo@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, azurIt <azurit@pobox.sk>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <op.vtxb92f73l0zgt@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mr. Michal,

Thanks for your comments.
Sorry. There was a small typo in my last sentence (mitigating not *migitating* memory fragmentation)
That means how can I measure the memory fragmentation either from user space or from kernel space.
Is there a way to measure the amount of memory fragmentation in linux?
Can you provide me some references for that?


Thanks,
Pintu



--- On Thu, 4/14/11, Michal Nazarewicz <mina86@mina86.com> wrote:

> From: Michal Nazarewicz <mina86@mina86.com>
> Subject: Re: Regarding memory fragmentation using malloc....
> To: "Américo Wang" <xiyou.wangcong@gmail.com>, "Pintu Agarwal" <pintu_agarwal@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Eric Dumazet" <eric.dumazet@gmail.com>, "Changli Gao" <xiaosuo@gmail.com>, "Jiri Slaby" <jslaby@suse.cz>, "azurIt" <azurit@pobox.sk>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>
> Date: Thursday, April 14, 2011, 5:47 AM
> On Thu, 14 Apr 2011 08:44:50 +0200,
> Pintu Agarwal <pintu_agarwal@yahoo.com>
> wrote:
> > As I can understand from your comments that, malloc
> from user space will not have much impact on memory
> fragmentation.
> 
> It has an impact, just like any kind of allocation, it just
> don't care about
> fragmentation of physical memory.  You can have only
> 0-order pages and
> successfully allocate megabytes of memory with malloc().
> 
> > Will the memory fragmentation be visible if I do
> kmalloc from
> > the kernel module????
> 
> It will be more visible in the sense that if you allocate 8
> KiB, kernel will
> have to find 8 KiB contiguous physical memory (ie. 1-order
> page).
> 
> >> No.  When you call malloc() only virtual
> address space is allocated.
> >> The actual allocation of physical space occurs
> when user space accesses
> >> the memory (either reads or writes) and it happens
> page at a time.
> > 
> > Here, if I do memset then I am accessing the
> memory...right? That I am doing already in my sample
> program.
> 
> Yes.  But note that even though it's a single memset()
> call, you are
> accessing page at a time and kernel is allocating page at a
> time.
> 
> On some architectures (not ARM) you could access two pages
> with a single
> instructions but I think that would result in two page
> faults anyway.  I
> might be wrong though, the details are not important
> though.
> 
> >> what really happens is that kernel allocates the
> 0-order
> >> pages and when
> >> it runs out of those, splits a 1-order page into
> two
> >> 0-order pages and
> >> takes one of those.
> > 
> > Actually, if I understand buddy allocator, it
> allocates pages from top to bottom.
> 
> No.  If you want to allocate a single 0-order page,
> buddy looks for a
> a free 0-order page.  If one is not found, it will
> look for 1-order page
> and split it.  This goes up till buddy reaches
> (MAX_ORDER-1)-page.
> 
> > Is the memory fragmentation is always a cause of the
> kernel space program and not user space at all?
> 
> Well, no.  If you allocate memory in user space,
> kernel will have to
> allocate physical memory and *every* allocation may
> contribute to
> fragmentation.  The point is, that all allocations
> from user-space are
> single-page allocations even if you malloc() MiBs of
> memory.
> 
> > Can you provide me with some references for migitating
> memory fragmentation in linux?
> 
> I'm not sure what you mean by that.
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
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm'
> in
> the body to majordomo@kvack.org. 
> For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org">
> email@kvack.org
> </a>
> 
