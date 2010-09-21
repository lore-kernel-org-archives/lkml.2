Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab0IUQYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:24:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab0IUQYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:24:39 -0400
Date: Tue, 21 Sep 2010 18:24:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Heinz Diehl <htd@fritha.org>
Cc: Heinz Diehl <htd@fancy-poultry.org>, Alan Ott <alan@signal11.us>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [BUG] object: is not initialized, yet kobject_put() is being
 called
In-Reply-To: <20100921152728.GA13464@fritha.org>
Message-ID: <alpine.LNX.2.00.1009211821560.26813@pobox.suse.cz>
References: <20100812115657.GA1611@arch.tripp.de> <alpine.LNX.2.00.1008121401580.2702@pobox.suse.cz> <alpine.LNX.2.00.1008121457060.2702@pobox.suse.cz> <20100812130411.GA1626@arch.tripp.de> <4C63F285.8070801@signal11.us> <20100812164035.GB6761@fritha.org>
 <20100920181100.GA12295@fancy-poultry.org> <alpine.LNX.2.00.1009211653510.26813@pobox.suse.cz> <20100921150900.GA6801@fritha.org> <alpine.LNX.2.00.1009211714400.26813@pobox.suse.cz> <20100921152728.GA13464@fritha.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010, Heinz Diehl wrote:

> > strace -f would likely be more helpful.
> 
> Oops, yes, of course. Output is attached.

OK, so the problem is

21206 open("/dev/hiddev0", O_RDWR|O_NOCTTY) = -1 ENODEV (No such device)
21206 open("/dev/hiddev1", O_RDWR|O_NOCTTY) = -1 ENODEV (No such device)
21206 open("/dev/hiddev2", O_RDWR|O_NOCTTY) = -1 ENODEV (No such device)

Do you have 8fe294caf8c868edd9046251824a0af91991bf43 commit applied? (it 
is included in -rc5).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
