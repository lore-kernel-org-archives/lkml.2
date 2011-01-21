Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab1AURYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:24:52 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:45936 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751773Ab1AURYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:24:51 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 0yWJ2DwVM1k7MQI0sydduBtAngXBzU.t6TLd5CKStNgS0Ww
 _Ek_0LdgaRPKQx5HK9zDfl71F13CfZBeAwI6szWM8F3Vwj1WzftazkLZY9Zq
 r1I6AuvZk.hdFmWxMOMPtp38bWYd21LX2v8XnSU1y9Co06OgQRV.xfBHdxT.
 AtC_uHoNp6.xBdugufjn8mGRizTm.zZFWd3cVl8mza.YQ7282_1xpasqkc_Q
 Z
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 21 Jan 2011 11:24:47 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Tejun Heo <tj@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
In-Reply-To: <1da7491b-6e7d-4453-9c6f-0e7767421ec4@email.android.com>
Message-ID: <alpine.DEB.2.00.1101211121350.15692@router.home>
References: <4D263C91.30709@zytor.com> <alpine.DEB.2.00.1101070907060.3014@router.home> <20110107180419.GB23082@Krystal> <alpine.DEB.2.00.1101071227450.3014@router.home> <20110108172453.GF13269@mtj.dyndns.org> <4D393636.4040607@cs.helsinki.fi>
 <20110121092649.GA2832@htj.dyndns.org> <4D39A6EB.70705@zytor.com> <20110121154831.GE2832@htj.dyndns.org> <20110121165425.GB11687@Krystal> <20110121170847.GH2832@htj.dyndns.org> <1da7491b-6e7d-4453-9c6f-0e7767421ec4@email.android.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, H. Peter Anvin wrote:

> We could do cmpxchg with a structure... the problem with a lon int type is that Cristoph ran into bugs with __int128 on 64 bits.

We also would need to be pass the structure by value (well its really a
variable but its like passing by value) in order to be similar to the
other this_cpu_ops

You'd want either

DEFINE_PERCPU(struct mycustomdoublestruct, percpu_dd)

this_cpu_cmpxchg_double(percpu_dd, oldword1, oldword2, newword1, newword2)

with the problem of type checking

or

this_cpu_cmpxchg_double(percpu_dd, old_dd, new_dd)

with the problem of 128 bit constants/structs passed by value.




