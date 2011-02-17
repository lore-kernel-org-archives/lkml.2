Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab1BQJJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 04:09:15 -0500
Received: from cantor.suse.de ([195.135.220.2]:36420 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab1BQJJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 04:09:12 -0500
Date: Thu, 17 Feb 2011 10:09:10 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in
 2.6.38-rc4
Message-ID: <20110217090910.GA3781@tiehlicka.suse.cz>
References: <20110216185234.GA11636@tiehlicka.suse.cz>
 <20110216193700.GA6377@elte.hu>
 <AANLkTinDxxbVjrUViCs=UaMD9Wg9PR7b0ShNud5zKE3w@mail.gmail.com>
 <AANLkTi=xnbcs5BKj3cNE_aLtBO7W5m+2uaUacu7M8g_S@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=xnbcs5BKj3cNE_aLtBO7W5m+2uaUacu7M8g_S@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 16-02-11 12:09:35, Linus Torvalds wrote:
> On Wed, Feb 16, 2011 at 11:50 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Yup, goodie. It does look like it might be exactly the same thing,
> > except now the offset seems to be 0x1e68 instead of 0x1768.
> 
> It was 0x1748 in Eric's case. Background for Michal:
> 
>   http://lkml.org/lkml/2011/2/14/223

I have seen that thread but I didn't think it is related. I thought
this is an another anon_vma issue. But you seem to be right that the
offset pattern can be related.

> 
> Michal - if you can re-create this, it would be wonderful if you can
> enable CONFIG_DEBUG_PAGEALLOC. I didn't find any obvious candidates
> yet.

OK. I have just booted with the same kernel and the config turned on.
Let's see if I am able to reproduce.

Btw.
$ objdump -d ./vmlinux-2.6.38-rc4-00001-g07409af-vmscan-test | grep 0x1e68

didn't print out anything. Do you have any other way to find out the
structure?
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
