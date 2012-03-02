Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab2CBJ4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 04:56:10 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:48610 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946Ab2CBJ4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 04:56:07 -0500
Date: Fri, 2 Mar 2012 10:55:49 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] x86, RAS: Add a decoded msg buffer
Message-ID: <20120302095548.GB7907@aftab>
References: <1330445487-15020-1-git-send-email-bp@amd64.org>
 <1330445487-15020-3-git-send-email-bp@amd64.org>
 <3908561D78D1C84285E8C5FCA982C28F03FD68@ORSMSX104.amr.corp.intel.com>
 <20120229101146.GB21224@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120229101146.GB21224@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 11:11:46AM +0100, Borislav Petkov wrote:
> > Is there some upper bound for how long this string can get? Why not
> > just allocate a generous amount at boot time?
> 
> Yep, this sounds like the easiest thing to do, let me play with MCE
> injection a bit.

So I left it inject all kinds of errors overnight and the buffer got
enlarged to 400 bytes:

[ 1115.162484] Buffer enlarged to 250
[ 1115.166059] Buffer enlarged to 300
[ 1115.169604] Buffer enlarged to 350
[ 3855.129854] Buffer enlarged to 400

So I'm guessing something like 500 bytes would be a safe bet in the
current situation.

Now whether 500 bytes is a lot or not, dunno, we'll see how it plays
out in testing. Also, the question is what would happen if we need to
enlarge it later for some more info, hm. Maybe I should go over the
decoded strings and try slimming them up a bit...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
