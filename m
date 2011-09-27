Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab1I0SIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:08:15 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:46575 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751883Ab1I0SIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:08:13 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: XO_13JEVM1n3o2nj36J1z0wD70B7DwL7nKtQkIvpxr1h3d9
 XME.v3WeLf06s59cpR3T2VfI2cH0q9GRne3fws2y0Qk_Cix_f1MgWwZcqbFm
 fN8Sln5x6YQtnsNjgYjkAgN4XFEpz2XYd_hb7.KOOj0rX7TvdC8oQrf2SKY1
 Z4EJvxkGxDkr36Zjh.brVqkmsdRg3UG.7Ymq6p4ce3UxjLqj5iHZGHfgbQ3Z
 gVI7BoJ4J_qJaaMMXUkQN6uCdviVI2fcfQfdG20VuIONx9w7NjNrRLHqjPel
 lgF._oYM4lIMBeaqBC7e6j4v7FubwDafMAqP1LsHIv4vjeMnPHWjeFohM_vP
 LCixV_t_ckujLKuCW9HscgLnXzd_LAFI8YFxvZkDAmXGgKw_Kfv1DD02jAQm
 2dtyyzOdlqzYbgaL21k63RA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 27 Sep 2011 13:08:09 -0500 (CDT)
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
In-Reply-To: <20110927175453.GA3393@albatros>
Message-ID: <alpine.DEB.2.00.1109271304470.11361@router.home>
References: <20110927175453.GA3393@albatros>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This also needs to other /proc files I believe,


Acked-by: Christoph Lameter <cl@linux.com>


Possible candidates:

christoph@oldy:~/n/linux-2.6$ grep proc_create mm/*
mm/swapfile.c:	proc_create("swaps", 0, NULL, &proc_swaps_operations);
mm/vmstat.c:	proc_create("buddyinfo", S_IRUGO, NULL, &fragmentation_file_operations);
mm/vmstat.c:	proc_create("pagetypeinfo", S_IRUGO, NULL, &pagetypeinfo_file_ops);
mm/vmstat.c:	proc_create("vmstat", S_IRUGO, NULL, &proc_vmstat_file_operations);
mm/vmstat.c:	proc_create("zoneinfo", S_IRUGO, NULL, &proc_zoneinfo_file_operations);

vmstat and zoneinfo in particular give similar information to what is
revealed through the slab proc files.

