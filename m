Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1L0K3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 05:29:14 -0500
Received: from mail.pre-sense.de ([213.238.39.107]:40018 "EHLO
	mail.pre-sense.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab1L0K3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 05:29:10 -0500
X-Greylist: delayed 437 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Dec 2011 05:29:10 EST
Message-ID: <4EF99C3C.8030602@pre-sense.de>
Date: Tue, 27 Dec 2011 11:21:48 +0100
From: Axel Theilmann <theilmann@pre-sense.de>
Organization: PRESENSE Technologies GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux-scsi@vger.kernel.org, Huajun Li <huajun.li.lee@gmail.com>,
        jbottomley@parallels.com, linux-kernel@vger.kernel.org
Subject: Re: Yet another hot unplug NULL pointer dereference (was Re: status
 of oops in sd_revalidate_disk?)
References: <4EE8E419.8010000@pre-sense.de> <CA+v9cxZFUC45WD0=+8mvH2Tq_xvX3PgaW4ttzPep0jqvqab_6w@mail.gmail.com> <20111225215804.03ef9402@stein>
In-Reply-To: <20111225215804.03ef9402@stein>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/2011 09:58 PM, Stefan Richter wrote:

moin,

> as far as I remember, all Linux releases in 2011 have been broken WRT hot
> removal of block devices; some more severely, some less.  Various patches
> for this went in over the year, but if they fixed anything, they always
> uncovered the next lingering unplug related bug.  The presumed first Linux

so now there are 2 known NULL-pointer problems in the cd-rom code and one in
the scsi-disk code.

Would a complete fix for this issue be a question of locating all the
possible NULL-pointers and fixing them or do you think that the hotplug
problem has to be fixed on a more "fundamental" level?

Even if there is a more fundamental problem below that has to be fixed, it
would still be nice to get in fixes for the dereferences that are currently
known to keep peoples systems from crashing.

We built a kernel with Huajun's patch included and will do some tests to see
if the problem goes away (and no others show up).


> With a little bit of bad luck, udisks-daemon or in older distros hald
> should hit the bug too.  Under kernel 3.1 I typically just got processes
> hanging in unkillable sleep.  With kernel 3.2-rc7 I get an instant kernel
> panic.

Yes, udisks is what probably triggers the bug for us. People removing USB
media before udisks is finished initializing the medium. With kernel 3.1.4
we get instant kernel panics as well.


tty, axel



-- 
Dipl.-Inform. Axel Theilmann             theilmann@pre-sense.de
                               Tel.  (+49) 040  / 244 2407 - 13
                               Fax   (+49) 040  / 244 2407 - 24
                               Mobil (+49) 0151 / 116 18 664
PRESENSE Technologies GmbH         Sachsenstr. 5, 20097 Hamburg
                                         USt-IdNr.: DE263765024
Geschäftsführer/Managing Directors       AG Hamburg, HRB 107844
Till Dörges           Jürgen Sander              Axel Theilmann
