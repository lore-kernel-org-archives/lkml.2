Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab1DMNYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:24:20 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:32900 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab1DMNYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:24:18 -0400
Date: Wed, 13 Apr 2011 15:24:09 +0200
From: Borislav Petkov <bp@amd64.org>
To: Borislav Petkov <bp@alien8.de>, Russ Anderson <rja@sgi.com>,
        Prarit Bhargava <prarit@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>, rja@americas.sgi.com
Subject: Re: [PATCH]: mce: don't print "human readable" message for corrected
 errors
Message-ID: <20110413132409.GB1900@gere.osrc.amd.com>
References: <20110412174405.26867.65604.sendpatchset@prarit.bos.redhat.com>
 <20110412185842.GB9891@liondog.tnic>
 <987664A83D2D224EAE907B061CE93D5301A9629BD5@orsmsx505.amr.corp.intel.com>
 <4DA4B2EA.5050303@redhat.com>
 <20110412202854.GA32200@liondog.tnic>
 <20110413030033.GB31652@sgi.com>
 <20110413071432.GA22773@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413071432.GA22773@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 09:14:33AM +0200, Borislav Petkov wrote:

[..]

> So maybe we could drop the default notifier and do in print_mce():
> 
> 	if (notifier_chain_empty(&x86_mce_decoder_chain))
> 		pr_emerg(HW_ERR "Run the message through 'mcelog --ascii' to decode.\n");
> 
> I think this could work, let me cook up something.

Ok, I'm sending what I scratched up as a reply to this mail. They remove
the default notifier and use an atomic flag to distinguish the cases
between when we have a decoder or not.

This is marginally better in the sense that we don't have to call into
the notifier chain if there are no notifier calls on it so it saves us
a call in the UC case. Also, it drops the tainting for CEs and testing
this by injecting DRAM CECCs leaves /proc/sys/kernel/tainted at 0.

I still have to test the UC case but for that I'll have to dust off my
patchset which implements hw MCE injection first.

To be continued...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
