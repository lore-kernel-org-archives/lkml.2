Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab1AZQCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 11:02:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab1AZQCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 11:02:34 -0500
Date: Wed, 26 Jan 2011 17:02:31 +0100
From: Matthias Hopf <mhopf@suse.de>
To: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Matthieu CASTET <castet.matthieu@free.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Milton Miller <miltonm@bga.com>,
        linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>
Subject: [REGRESSION] S3 suspend on SandyBridge freezes due to
 on_each_cpu() change (bd924e8)
Message-ID: <20110126160231.GA29021@suse.de>
Mail-Followup-To: Tejun Heo <tj@kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Matthieu CASTET <castet.matthieu@free.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
	Oliver Neukum <oneukum@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH, =?iso-8859-1?Q?G?=
	=?iso-8859-1?Q?F=3A_Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

While bisecting a dri S3 issue I stumbled in 2.6.38-rc1 over a
regression because of NX protection (5bd5a4, currently being discussed),
and with a patch fixing this issue I stumbled again in 2.6.38-rc2
because of commit bd924e8:

    smp: Allow on_each_cpu() to be called while early_boot_irqs_disabled status to init/main.c

Reverting this commit makes suspend work on SandyBridge again. I haven't
tested reverting this commit on v2.6.38-rc2 yet, though.

I'm compiling for i586, not x86_64.

lspci -vvv output is attached.


(for internal reference: machine NUE874)

Matthias

-- 
Matthias Hopf <mhopf@suse.de>      __        __   __
Maxfeldstr. 5 / 90409 Nuernberg   (_   | |  (_   |__          mat@mshopf.de
Phone +49-911-74053-715           __)  |_|  __)  |__  R & D   www.mshopf.de

--SUOF0GtieIMvvwua
Content-Type: application/x-gzip
Content-Disposition: attachment; filename="lspci.txt.gz"
Content-Transfer-Encoding: base64

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

--SUOF0GtieIMvvwua--
