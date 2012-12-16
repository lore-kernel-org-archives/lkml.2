Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab2LPMqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 07:46:19 -0500
Received: from mga05.intel.com ([192.55.52.89]:16836 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752890Ab2LPMqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 07:46:16 -0500
Message-ID: <1355661970.2903.28.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [GIT PULL] x86/uapi for 3.8
From: Matt Fleming <matt.fleming@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <jbeulich@suse.com>,
        David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 16 Dec 2012 12:46:10 +0000
In-Reply-To: <CA+55aFwxtt2Rs7dJt_icCsH5QUzrV_UaATQ3aJQY2KGH+anc3A@mail.gmail.com>
References: <23916.1355356085@warthog.procyon.org.uk>
	 <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
	 <21507.1355528749@warthog.procyon.org.uk>
	 <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
	 <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
	 <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com>
	 <20121215163323.GA229@x4>
	 <CA+55aFz3iLPT3wzbU_Nhh4ft1eNQcd4WdQXsgXnKBs6vG9a_Uw@mail.gmail.com>
	 <50CCD24F.9090603@zytor.com>
	 <CA+55aFxi5SnacGoHzHuth4PvTRQQWA5kWM+D2Mn+FgV4VGYADQ@mail.gmail.com>
	 <20121215210411.GA228@x4>
	 <CA+55aFznbC_FHyfGWaD6e6wNE88CiAYaPwjerBh1HfBpfPfNsg@mail.gmail.com>
	 <CAE9FiQX=5=5-U3ix=LGJUOxFrbmYRG3h_qbe11t2Q-zE4pEV3A@mail.gmail.com>
	 <CA+55aFwxtt2Rs7dJt_icCsH5QUzrV_UaATQ3aJQY2KGH+anc3A@mail.gmail.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-15 at 15:37 -0800, Linus Torvalds wrote:
> And why do we have to call the get-time calls so early? Couldn't we
> move them later and avoid all the crazy "let's create silly magical
> page tables just for the idiotic EFI problems".

Unfortunately not, because this patch series fixes the case where some
ASUS EFI machines ignore parts of the memory map that we invalidate with
SetVirtualAddressMap() - so the firmware is accessing mappings for
devices after we explicitly tell it they're no longer valid.

It's possible to trigger this broken behaviour at whatever point we
interact with the firmware.

