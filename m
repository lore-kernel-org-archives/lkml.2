Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab1LEKou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 05:44:50 -0500
Received: from mx0.aculab.com ([213.249.233.131]:40884 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756030Ab1LEKoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 05:44:44 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
Date: Mon, 5 Dec 2011 10:44:33 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6D8AEFD@saturn3.aculab.com>
In-Reply-To: <20111203122900.GA1617@x4.trippels.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
Thread-Index: Acyxty66y9fbiDeCS8CsQJVF1Mw86QBgwpYg
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Markus Trippelsdorf" <markus@trippelsdorf.de>,
        "Dave Airlie" <airlied@gmail.com>
Cc: "Jerome Glisse" <j.glisse@gmail.com>, "Christoph Lameter" <cl@linux.com>,
        "Alex, Shi" <alex.shi@intel.com>,
        "Eric Dumazet" <eric.dumazet@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "Pekka Enberg" <penberg@kernel.org>, <linux-mm@kvack.org>,
        "Matt Mackall" <mpm@selenic.com>, <tj@kernel.org>,
        "Alex Deucher" <alexander.deucher@amd.com>
X-OriginalArrivalTime: 05 Dec 2011 10:44:33.0707 (UTC) FILETIME=[E0279FB0:01CCB33A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > If I had to guess it looks like 0 is getting written back to some
> > random page by the GPU maybe, it could be that the GPU is in some
half
> > setup state at boot or on a reboot does it happen from a cold boot
or
> > just warm boot or kexec?
> 
> Only happened with kexec thus far. Cold boot seems to be fine.

Sounds like the GPU is writing to physical memory from the
old mappings.
This can happen to other devices if they aren't completely
disabled - which may not happen since the kexec case probably
avoids some of the hardware resets that occurr diring a normal
reboot.

I remember an ethernet chip writing into its rx ring/buffer
area following a reboot (and reinstall!) when connected
to a quiet lan.

	David


