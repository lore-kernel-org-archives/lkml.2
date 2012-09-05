Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab2IES4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 14:56:54 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57541 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab2IES4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 14:56:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120905102201.9423.46671.stgit@localhost.localdomain>
References: <20120905102049.9423.6413.stgit@localhost.localdomain>
	<20120905102201.9423.46671.stgit@localhost.localdomain>
Date: Wed, 5 Sep 2012 11:56:51 -0700
X-Google-Sender-Auth: 3PSGzB-FKdCc1ENm067HtkbXSic
Message-ID: <CA+8MBb+T6H1jK624qkPPmK8BJ0T1-FcRM+9JPKubq65wKvfueA@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86/mce: Pack boolean MCE flags into a structure
From: Tony Luck <tony.luck@intel.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: andi@firstfloor.org, bp@amd64.org, gong.chen@linux.intel.com,
        ananth@in.ibm.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, gregkh@suse.de,
        linux-edac@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 3:22 AM, Naveen N. Rao
<naveen.n.rao@linux.vnet.ibm.com> wrote:
> Many MCE flags are boolean in nature, but are declared as integers
> currently. We can pack these into a bitfield to save some space.

Before this patch:
size arch/x86/kernel/cpu/mcheck/mce.o
   text	   data	    bss	    dec	    hex	filename
  18946	   4930	    776	  24652	   604c	arch/x86/kernel/cpu/mcheck/mce.o

After:
size arch/x86/kernel/cpu/mcheck/mce.o
   text	   data	    bss	    dec	    hex	filename
  19335	   4890	    776	  25001	   61a9	arch/x86/kernel/cpu/mcheck/mce.o

So we do indeed see "data" reduced by 40 bytes. But
"text" is up by 389.  This seems to be because you have
another change, not described in the commit log, buried
in part 2 to add get_dont_log_ce(), set_dont_log_ce() etc.

Compiler version: gcc version 4.4.6 20120305 (Red Hat 4.4.6-4) (GCC)

I know I'm contradicting the feedback you got from Borislav here, but
is this code churn really worth it to save 40 bytes? I don't think so.

-Tony
