Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab1LOWw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 17:52:56 -0500
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:21903 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932540Ab1LOWwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 17:52:55 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: CDqkOa8VM1nb8gMzZ7nN1W_gVkLO_grV9b7xXsgGnAJmNgS
 rlCHL1iEkKluosZpxfxE.irU2hK_MpBLd100ZU3XsgQoPDL7f9.xA0q2XTvA
 kTMiUAuJgsujbK801Rtt2MCiDQD3sgHrhJB.ls0zN32jPGj2pW5bTwSW.Uca
 aDJtqp3qHLUZp2qBmkvdUJKwhNMSq6V0qoo6LZ3xhixM3cwQzN4lB7tHwKWx
 lSVQj3uen2uJvkyDf6BdSExL9tilHqdVGXaJHj.meundwxmgMJ1m4T8y4aAh
 lwPPVEj03mHFuSZoxV5oy_HqeyfYilgJ9Ao6cYCnDVdVneWzcI5AyQbVuoUV
 1zYYjMI3l6BvF3pvuu3ErTrb60OQFI5JfsaV9rEscXG_tr.t5M_kgPF7OWeb
 NrwXglif55nHQkKpixXQYhw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 15 Dec 2011 16:52:50 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: jbeulich@suse.com, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, dhowells@redhat.com, akpm@linux-foundation.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86: Fix and improve
 percpu_cmpxchg{8,16}b_double()
In-Reply-To: <tip-cebef5beed3de3037de85a521495897256b2c5da@git.kernel.org>
Message-ID: <alpine.DEB.2.00.1112151627060.11871@router.home>
References: <4EE86D6502000078000679FE@nat28.tlf.novell.com> <tip-cebef5beed3de3037de85a521495897256b2c5da@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Dec 2011, tip-bot for Jan Beulich wrote:

> x86: Fix and improve percpu_cmpxchg{8,16}b_double()

Great. Thanks. I wish you would have been there when I had to put this
together. Had a difficult time finding relevant docs etc on how to exactly
do this. And the failure messages from the inline asm parser were not that
helpful.

Acked-by: Christoph Lameter <cl@linux.com>

> The __dummy variable was pointless (and needlessly initialized
> in the 2x32-bit case), given that local copies of the inputs
> already exist.

Hmm... I had some failures if I did not specify that dummy in the
inline asm. Does this work for all gcc versions?

> The 2x64-bit variant forced the address of the first object into
> %rsi, even though this is needed only for the call to the
> emulation function. The real cmpxchg16b can operate on an
> memory.

Yup. Good idea to code the load into the alternative code path to avoid
the cmpxchg of the primary code path to be restricted to %si register.

You dropped the padding with NOPs. Are the instructions on both paths
always the same length?

