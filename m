Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab3AJRDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:03:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab3AJRDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:03:01 -0500
Date: Thu, 10 Jan 2013 12:01:47 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Renninger <trenn@suse.de>,
        MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com,
        tglx@linutronix.de, khalid@gonehiking.org, horms@verge.net.au
Subject: Re: [PATCH] Only reset e820 once, even with multiple memmap=exactmap
 params
Message-ID: <20130110170147.GC32223@redhat.com>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local>
 <201301081747.17853.trenn@suse.de>
 <CAE9FiQW=gT86Eo0gwPHi5iFi4sg=1SHkBohBAo2KXdoB_Ouqvw@mail.gmail.com>
 <1586060.uJlkOEQfVW@hammer82.arch.suse.de>
 <20130110142643.GB32223@redhat.com>
 <CAE9FiQUGHKqbGk_GNfDuinwd0AMDGKeno44KWCLw7hGZs5OaKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUGHKqbGk_GNfDuinwd0AMDGKeno44KWCLw7hGZs5OaKQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 08:53:18AM -0800, Yinghai Lu wrote:
> On Thu, Jan 10, 2013 at 6:26 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > This happens only in case of kdump and not kexec. In case of kdump
> > we want second kernel to use only selected memory areas.
> >
> > In fact this is one improvement area. Instead of using memmap= entries
> > in kdump case, we should probably modify the e820 map passed in
> > zero page and get rid of memmap= entries.
> 
> then how the kdump kernel get saved_max_pfn?
> 

Oh, I forgot about that. May be we can pass saved_max_pfn on command line
instead of passing all memmap= entries.

Thanks
Vivek
