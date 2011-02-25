Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab1BYKtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 05:49:42 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:60794 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932432Ab1BYKti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 05:49:38 -0500
Date: Fri, 25 Feb 2011 11:48:23 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Avi Kivity <avi@redhat.com>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>, zamsden@redhat.com
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
	boot
Message-ID: <20110225104823.GD29840@pcnci.linuxbox.cz>
References: <20110223234258.GA29548@nik-comp.lan> <4D663044.3080000@redhat.com> <20110224104800.GA29840@pcnci.linuxbox.cz> <4D663886.6080803@redhat.com> <20110224112742.GB29840@pcnci.linuxbox.cz> <4D664E85.8070808@redhat.com> <20110224124151.GK25673@pcnci.linuxbox.cz> <4D665449.4050908@redhat.com> <20110224125702.GC29840@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224125702.GC29840@pcnci.linuxbox.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4639850 records (last update: 20110225)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC: Zachary)

Hello,
Zachary, in case You haven't noticed the thread, we're trying
to find out the reason why 32bit SMP guests stopped working
in 2.6.37. 
bisect shows this as the culprit:

e48672fa25e879f7ae21785c7efd187738139593 is first bad commit
commit e48672fa25e879f7ae21785c7efd187738139593
Author: Zachary Amsden <zamsden@redhat.com>
Date:   Thu Aug 19 22:07:23 2010 -1000

    KVM: x86: Unify TSC logic
    
    Move the TSC control logic from the vendor backends into x86.c
    by adding adjust_tsc_offset to x86 ops.  Now all TSC decisions
    can be done in one place.
    
    Signed-off-by: Zachary Amsden <zamsden@redhat.com>
    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Unfortunately I couldn't try 2.6.37 with just this one reverted, certainly
other patches rely on it, but hopefully I've not screwed something while bisecting...

so what now?
n.

-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
