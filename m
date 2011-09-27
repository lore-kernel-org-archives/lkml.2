Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1I0Tfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 15:35:30 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:48082 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753271Ab1I0Tf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 15:35:29 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: MzDTf00VM1nDNbewPvoTMREq3mPApygX.MO7anAUoeCv8jD
 ty02blUZTatBFYNFNmbUr6SQlRI3tzS.wrMj.lJebKrslrCrxqItsQbWvCq9
 FQaeXyhwwmTtNY9CIMzU0vPURk0SzVWleU.4elLmCoxapOi7D6vXeFtr7KgH
 bYQ07kIRH4tE8P_rTQoQKOMSKk5rdvTwYglXo8dYffYQAbtaD4Wq.sMr3gty
 RbOa6b38fLqyXj0PrYnkXkwvMhKg0ZVnJZFQqc90QeAFaYfGVNpnmIUFsbpi
 1YhcYhl64givNNQTKGI1VpIbHG2dChU9bVWOaU2dE6EUQOIcEwQQw_Vkv8Nu
 ZysLbJaLo_3J8jCXi_9l4oC3HkxoimcEMiYfC.pQBl9kg9r4pfouJsqtMm7I
 LGMWhYaHt_avBXBiDfhgAjNk-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 27 Sep 2011 14:35:25 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Vasiliy Kulikov <segoon@openwall.com>
cc: kernel-hardening@lists.openwall.com, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        Kees Cook <kees@ubuntu.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: restrict access to slab files under procfs and
 sysfs
In-Reply-To: <20110927191658.GB4820@albatros>
Message-ID: <alpine.DEB.2.00.1109271431250.13797@router.home>
References: <20110927175453.GA3393@albatros> <alpine.DEB.2.00.1109271304470.11361@router.home> <20110927191658.GB4820@albatros>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011, Vasiliy Kulikov wrote:

> On Tue, Sep 27, 2011 at 13:08 -0500, Christoph Lameter wrote:
> > Possible candidates:
> >
> > christoph@oldy:~/n/linux-2.6$ grep proc_create mm/*
> > mm/swapfile.c:	proc_create("swaps", 0, NULL, &proc_swaps_operations);
> > mm/vmstat.c:	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
> > mm/vmstat.c:	proc_create("pagetypeinfo", S_IRUGO, NULL, &pagetypeinfo_file_ops);
> > mm/vmstat.c:	proc_create("vmstat", S_IRUGO, NULL, &proc_vmstat_file_operations);
> > mm/vmstat.c:	proc_create("zoneinfo", S_IRUGO, NULL, &proc_zoneinfo_file_operations);
> >
> > vmstat and zoneinfo in particular give similar information to what is
> > revealed through the slab proc files.
>
> Do you know whether these files are actively used?  I don't want to
> break tools like "free" or "top".  In this case we'll have to discover
> another way to limit this information.

top uses per process information. Tried an strace and I see no access to
vmstat or zoneinfo.

free uses /proc/meminfo not vmstat or zoneinfo. Since you already have a
patch that limits /proc/meminfo access there is already an issue there.

