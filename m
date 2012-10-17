Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab2JQSJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 14:09:16 -0400
Received: from mail.x86-64.org ([217.9.48.20]:52213 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab2JQSJM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 14:09:12 -0400
Date: Wed, 17 Oct 2012 20:09:09 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lcm@us.ibm.com" <lcm@us.ibm.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Subject: Re: [PATCH v3] x86/mce: Honour bios-set CMCI threshold
Message-ID: <20121017180909.GB31503@aftab.osrc.amd.com>
References: <CA+8MBbKVa0=qUpG-rjV5ieKkponZo77mzk_y_dF4qA2gVG++6A@mail.gmail.com>
 <20120912122516.3825.87838.stgit@localhost.localdomain>
 <505C51D8.6070402@linux.vnet.ibm.com>
 <20121017105940.GA14590@x1.osrc.amd.com>
 <507E9622.6090606@linux.vnet.ibm.com>
 <20121017130934.GB14590@x1.osrc.amd.com>
 <507ED31B.7010402@linux.vnet.ibm.com>
 <20121017164006.GA14596@x1.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F19D517FF@ORSMSX108.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D517FF@ORSMSX108.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 05:28:11PM +0000, Luck, Tony wrote:
> > What's wrong with userspace tools parsing /proc/cmdline and seeing that
> > mce_bios_cmci_threshold has been set since this is the only way to set
> > it anyway?
> 
> The argument might be on the command line, but may have been rejected
> because the BIOS didn't set the thresholds? So then you'd have to look at
> the command line, *and* check /var/log/messages to make sure we hadn't
> printed the message saying the BIOS was unsupportive.

Right, but the sysfs read-only thing doesn't solve that either - it only
dumps the mce_bios_cmci_threshold value so it doesn't help.

The stuff you're talking about is not reflected in that variable but
saved in some other like bios_wrong_thresh and bios_zero_thresh.

> BUT ... I don't think that knowing this is sufficient. A userspace
> tool would want to know what value had been set for each bank. So if
> it really wants to do something interesting, just knowing that "bios
> set some thresholds" doesn't sound like enough information.

Yes. And I still haven't gotten a real use case of what userspace tool
will do with this information.

> BUT (squared) do you even really need to know that thresholds were
> set? You could look at bits {52:38} in the MCi_STATUS information for
> the bank to see how many corrected errors had been logged.

Right, a real use case which shows why we need that information should
be good.

Thanks.

> -Tony
> �{.n�+�������+%��lzwm��b�맲��r��zX���iȧ���ܨ}���Ơz�&j:+v�������zZ+��+zf���h���~����i���z��w���?����&�)ߢf

What happened here? It seems your mail client wanted to say something
too but it has been censored.

:-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
