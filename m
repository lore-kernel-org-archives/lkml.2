Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab2IFMPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:15:52 -0400
Received: from mail.x86-64.org ([217.9.48.20]:48705 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753575Ab2IFMPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:15:48 -0400
Date: Thu, 6 Sep 2012 14:15:30 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>, andi@firstfloor.org,
        gong.chen@linux.intel.com, ananth@in.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, gregkh@suse.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/mce: Pack boolean MCE flags into a structure
Message-ID: <20120906121530.GB550@aftab.osrc.amd.com>
References: <20120905102049.9423.6413.stgit@localhost.localdomain>
 <20120905102201.9423.46671.stgit@localhost.localdomain>
 <CA+8MBb+T6H1jK624qkPPmK8BJ0T1-FcRM+9JPKubq65wKvfueA@mail.gmail.com>
 <5048473F.9070704@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5048473F.9070704@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 12:18:31PM +0530, Naveen N. Rao wrote:
> >I know I'm contradicting the feedback you got from Borislav here, but
> >is this code churn really worth it to save 40 bytes? I don't think
> >so.

Well, to answer Tony's question, I wanted to have all those config
booleans at the beginning of mce.c packed tightly together as a
single-bit bool values in a config-like struct so that they don't
scatter all over the place and grow out of proportion with more features
being added. So actually I'm willing to swallow the slight increase in
code size for better/more clear code.

> Hmm.. I think I agree. I don't see a good way to get rid of the
> individual getters and setters without adding some more code churn.
> I guess using boolean would be better. Boris?

Yes, it would be worth to try to add a DEVICE_BOOL_ATTR which introduce
a setter/getter flavour for bools and then use that for all.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
