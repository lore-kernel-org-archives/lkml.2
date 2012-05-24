Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab2EXF7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 01:59:47 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:33315 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab2EXF7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 01:59:46 -0400
Date: Thu, 24 May 2012 08:00:16 +0200
From: Borislav Petkov <bp@amd64.org>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "bp@amd64.org" <bp@amd64.org>, "x86@kernel.org" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86: auto poll/interrupt mode switch for CMC to stop CMC
 storm
Message-ID: <20120524060016.GB25344@aftab.osrc.amd.com>
References: <1337740341-26711-1-git-send-email-gong.chen@linux.intel.com>
 <alpine.LFD.2.02.1205230859190.3231@ionos>
 <3908561D78D1C84285E8C5FCA982C28F192F2DD6@ORSMSX104.amr.corp.intel.com>
 <alpine.LFD.2.02.1205232044150.3231@ionos>
 <3908561D78D1C84285E8C5FCA982C28F192F30C0@ORSMSX104.amr.corp.intel.com>
 <4FBD9BAA.7070902@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBD9BAA.7070902@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 10:23:38AM +0800, Chen Gong wrote:
> Hi, Boris, when I write these codes I don't care if it is specific for
> Intel or AMD.

Well, but I do care so that when you leave and start doing something
else, people after you can still read and maintain that code.

> I just noticed it should be general for x86 platform and all related
> codes are general too, which in mce.c, so I think it should be fine to
> place the codes in mce.c.

Are you kidding me? Only Intel has CMCI.

Now, if some other vendor needs correctable errors interrupt rate
throttling, they can carve it out, make it generic, and move it to mce.c.

Otherwise, it belongs in mce_intel.c. For the same reason AMD error
thresholding code belongs to mce_amd.c.

Jeez.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
