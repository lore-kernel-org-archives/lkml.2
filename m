Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab1ISWCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 18:02:18 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:28872 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755133Ab1ISWCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 18:02:17 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: uofysiUVM1mCZ6Bpbtnt.c02_QmCaDTpwcTsaK6OgzkY0GZ
 wtm.uHA58_zXdg5vqT2mxtRMBVwiI2b5KBnSPYtsl6qCvAKsKpnF.Zic_Yq6
 6RbRJHH8EEQ67tuEdvQe4r5IAhxhcbMOBI.gBV4hqf_7MYESEuTjFUUPfEcb
 ivVRawub4xxGhtbRUVqrEvyLjUrjcyJavtNEMlzZnAGtn6T.ibG2VdKJ7DZb
 t2ikAY1nMNrqflk01A49XOT.GWpowuMLCI.VrxVrwo_wY87FEP9i6D..XPK4
 ZivicuK4rYG0HQpiDEyjPBaOF_SdIl9A0OpqeT_X4Jd35YIb7ZZ3_mcwlC3i
 Mv0lXNpCsguoNglKTzm3gOBbruKS08IuDmYaoAnzm.mFrlmw-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 19 Sep 2011 17:02:13 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [RFC][PATCH 2/5] mm: Switch mod_state() to __this_cpu_read()
In-Reply-To: <20110919212640.688732950@goodmis.org>
Message-ID: <alpine.DEB.2.00.1109191657150.19059@router.home>
References: <20110919212040.745370781@goodmis.org> <20110919212640.688732950@goodmis.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011, Steven Rostedt wrote:

> From: Steven Rostedt <srostedt@redhat.com>
>
> The code in mod_state() is already made to handle the raciness of
> this_cpu_read(). Have the code use __this_cpu_read() instead so
> the debug code does not trigger warnings about it.

Why would there be a warning triggered? this_cpu_read should take care of
disabling preemption for the read if needed. In fact the fallback case
does do exactly that.

I think it would make more sence if __this_cpu_read() could be made to
trigger a warning if used in context where preemption could be off.

