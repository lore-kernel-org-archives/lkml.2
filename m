Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab0HYQMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 12:12:19 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:50154 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab0HYQMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 12:12:17 -0400
Date: Wed, 25 Aug 2010 18:12:14 +0200
From: Andreas Mohr <andi@lisas.de>
To: Sebastien.Hinderer@ens-lyon.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org,
        Samuel Thibault <Samuel.Thibault@ens-lyon.org>
Subject: Re: [PATCH] x86: EuroBraille/Iris power off
Message-ID: <20100825161214.GA15087@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100825094925.GA3632@pema>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

excellent! Now if as the next step before inclusion you also add the usual DMI check
(as done by many drivers such as acerhdf etc.),
someone inexperienced who is dumb enough to enable it for his unrelated machine
will actually survive an otherwise raw I/O port access and poweroff vector change ;))

Unless these non-APM, non-ACPI machines don't have any DMI support
either and thus won't even have dmidecode work.....
(in which case I'd strongly suggest adding a 0x340+x port value read verification
to bail driver install in case the machine doesn't have this hardware).

Andreas Mohr
