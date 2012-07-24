Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab2GXV0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 17:26:24 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33745 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab2GXV0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 17:26:22 -0400
Date: Tue, 24 Jul 2012 22:26:16 +0100
From: Matthew Garrett <mjg@redhat.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
Subject: Re: [RFC][PATCH v2 2/3] Hold multiple logs
Message-ID: <20120724212616.GA29546@srcf.ucam.org>
References: <20120720030328.GC5637@redhat.com>
 <20120723141632.GB23047@srcf.ucam.org>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB33479@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F19370A1B@ORSMSX104.amr.corp.intel.com>
 <20120724181820.GA23820@srcf.ucam.org>
 <3908561D78D1C84285E8C5FCA982C28F19370CA2@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB346A4@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F19370D21@ORSMSX104.amr.corp.intel.com>
 <20120724210725.GA29109@srcf.ucam.org>
 <3908561D78D1C84285E8C5FCA982C28F19370D52@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19370D52@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 09:12:25PM +0000, Luck, Tony wrote:
> > I think we inevitably lose in that scenario. I'd need to verify, but my 
> > recollection is that overwriting existing variables may be equivalent to 
> > a delete/create cycle.
> 
> This would mean that EFI really wants the OS to treat EFI variables as pretty much
> exclusively read-only.  Any activity which periodically updates a variable would
> eventually run into problems in an EFI implementation that loses the old space
> until a reset.

Sure. I'll test with a few implementations and see what I can figure 
out. We may just want to reserve some space for pstore, then have delete 
in pstore simply map to hiding the entries rather than deleting them.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
