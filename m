Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab2CVVEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:04:38 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:49419 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab2CVVEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:04:35 -0400
Date: Thu, 22 Mar 2012 22:04:31 +0100
From: Borislav Petkov <bp@amd64.org>
To: Christoph Lameter <cl@linux.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 2/2] tools: Add a toplevel Makefile
Message-ID: <20120322210431.GA1462@aftab>
References: <1332435713-32143-1-git-send-email-bp@amd64.org>
 <1332435713-32143-3-git-send-email-bp@amd64.org>
 <alpine.DEB.2.00.1203221332390.25011@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1203221332390.25011@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 01:33:18PM -0500, Christoph Lameter wrote:
> On Thu, 22 Mar 2012, Borislav Petkov wrote:
> 
> > index 000000000000..97631367e0db
> > --- /dev/null
> > +++ b/tools/Makefile
> > @@ -0,0 +1,24 @@
> > +include scripts/Makefile.lib
> > +
> > +perf firewire lguest slub usb virtio: FORCE
> > +	$(QUIET_SUBDIR0)$@/ $(QUIET_SUBDIR1)
> > +
> > +cpupower: FORCE
> > +	$(QUIET_SUBDIR0)power/$@/ $(QUIET_SUBDIR1)
> > +
> > +turbostat x86_energy_perf_policy: FORCE
> > +	$(QUIET_SUBDIR0)power/x86/$@/ $(QUIET_SUBDIR1)
> > +
> > +firewire_clean lguest_clean perf_clean slub_clean usb_clean virtio_clean:

						^^^----------------------------------------------
											    	|
> > +	$(QUIET_SUBDIR0)$(@:_clean=)/ $(QUIET_SUBDIR1) clean				    	|
> >												|
> > +												|
> > +cp_clean:											|
> > +	$(QUIET_SUBDIR0)power/cpupower/ $(QUIET_SUBDIR1) clean					|
> > +												|
> > +turbostat_clean x86_energy_perf_policy_clean:						|
> > +	$(QUIET_SUBDIR0)power/x86/$(@:_clean=)/ $(QUIET_SUBDIR1) clean				|
> > +												|
> > +clean: cp_clean firewire_clean lguest_clean perf_clean slub_clean turbostat_clean \	|
> 												|
> slub_clean? Where is that target defined?							|
												|
Here---------------------------------------------------------------------------------------------

:-).

It basically does:

$ make -C slub/ clean

which runs the target of the same name in the Makefile in slub/.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
