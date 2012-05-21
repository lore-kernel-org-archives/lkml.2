Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275Ab2EUVTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:19:50 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:22874 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759212Ab2EUVTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:19:46 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: qz0F3m8VM1kcMlFSaogyegrX2BpwRnuVJ6ea0P0BRpU8v7N
 DIr7sgoOLCs9wq.oQBFt8ntnrZIhUky.SI0P0TmCRimaoUW0b8Hl2_gnuVJq
 p93kazXInZZRPgm7So60VHf9nv50E33uJUw6beUUWzvqMgZoIzm9f2rJMFtN
 DaCkLRWAaWW3b1n3zQMHQ3_KW0Xc_LNM6SHFxEJyO1sZHsEathusd_soDcMr
 eKdmsBNBh8d_FM434yo9Jc_N9UXUQoQteWrl9ghEsAHbme9SpTaQjyc73.Bd
 UMljxFm7f1tvM1KMDmsbIEaoEz.sHFt6ga1ClDrG0WeI0sxTl8V1_YEx2LXk
 NFPvH.1NrClgfweedL7K4S.9uLGgX3VeJk5eDvnqcuw73Q1v_I4aFWgmQtoF
 e
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 21 May 2012 15:41:30 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Jones <davej@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 3.4-rc7 numa_policy slab poison.
In-Reply-To: <20120521203014.GC12123@redhat.com>
Message-ID: <alpine.DEB.2.00.1205211540010.10940@router.home>
References: <20120517213120.GA12329@redhat.com> <20120518185851.GA5728@redhat.com> <20120521154709.GA8697@redhat.com> <CA+55aFyqMJ1X08kQwJ7snkYo6MxfVKqFJx7LXBkP_ug4LTCZ=Q@mail.gmail.com> <20120521200118.GA12123@redhat.com> <alpine.DEB.2.00.1205211510480.10940@router.home>
 <20120521203014.GC12123@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012, Dave Jones wrote:

> On Mon, May 21, 2012 at 03:18:38PM -0500, Christoph Lameter wrote:
>
>  > Its always an mput on a freed memory policy. Slub recovery keeps my system
>  > up at least. I just get the errors dumped to dmesg.
>  >
>  > Is there any way to get the trinity tool to stop when the kernel writes
>  > errors to dmesg? That way I could see the parameters passed to mbind?
>
> another way might be to remove the -q argument, and use -p which inserts
> a pause() after each syscall.

Without -q it does not trigger anymore. Output is slow so I guess there is
some race condition that does not occur when things occur with less
frequency.

