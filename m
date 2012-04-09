Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2DICuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:50:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab2DICu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:50:27 -0400
Date: Sun, 8 Apr 2012 19:50:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, werner <w.landgraf@ru.ru>,
        linux-kernel@vger.kernel.org
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1
 sticks-and-crashs)
Message-Id: <20120408195044.13ea6c8e.akpm@linux-foundation.org>
In-Reply-To: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com>
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Apr 2012 19:42:31 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Guys, there's something wrong in the VM. Most likely suspects added to
> the participants list.
> 
> Apparently things go south and the oom killer is invoked. X.org seems
> to get killed.
> 
> Any hints? Werner traditionally finds problems by enabling every
> single config option there is, I assume this is another of those
> kernes..
> 
>
> ...
>
> > Apr __8 20:29:11 werner kernel: Normal free:44004kB min:44012kB low:55012kB
> > high:66016kB active_anon:0kB inactive_anon:0kB active_file:132kB
> > inactive_file:140kB unevictable:0kB isolated(anon):0kB isolated(file):0kB
> > present:885944kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
> > slab_reclaimable:13068kB slab_unreclaimable:147784kB kernel_stack:628952kB
> > pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1376
> > all_unreclaimable? yes

That's claiming that 600MB of ZONE_NORMAL is being used for kernel stacks.

