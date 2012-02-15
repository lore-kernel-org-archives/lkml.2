Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251Ab2BOLUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 06:20:20 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:31582 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756085Ab2BOLUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 06:20:18 -0500
X-SpamScore: -22
X-BigFish: VPS-22(zz936eK1432N98dKzz1202hzz15d4R8275bh8275dhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZFM5O-01-0CY-02
X-M-MSG: 
Date: Wed, 15 Feb 2012 12:20:09 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        maximilian attems <max@stro.at>, <debian-kernel@lists.debian.org>,
        <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH v2] kbuild: Fix link to headers in 'make deb-pkg'
Message-ID: <20120215112009.GD2238@amd.com>
References: <1329144538-21444-1-git-send-email-joerg.roedel@amd.com>
 <1329187753.3048.44.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1329187753.3048.44.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 02:49:13AM +0000, Ben Hutchings wrote:
> On Mon, 2012-02-13 at 15:48 +0100, Joerg Roedel wrote:
> > The Link to the kernel header files in the debian packages
> > point to the original build directory. This is a bad choice
> > if the packages were installed on a different machine. Fix
> > this in by manually re-creating the link in the builddeb
> > script.
> > 
> > Cc: Michal Marek <mmarek@suse.cz>
> > Cc: maximilian attems <max@stro.at>
> > Cc: Ben Hutchings <ben@decadent.org.uk>
> > Cc: debian-kernel@lists.debian.org
> > Cc: linux-kbuild@vger.kernel.org
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> This looks good for !UML.
> 
> I wonder about the UML case though.  Did you test it?  In 3.3-rc3,
> 'make headers_install' is broken.  But if I suppress the header check,
> the resulting packages have links in the right places.

I havn't tested UML, I am not really familiar with using it. You are
probably right that for UML only the linux-image package is needed. I
can remove the UML check from this patch and post another one which
changes the script to only build linux-image for UML, how does that
sound?


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

