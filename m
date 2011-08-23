Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab1HWTwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:52:33 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:23784 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755704Ab1HWTw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:52:29 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: LVjYqz8VM1kYmGfMO55lBePNiO_MTUshAtW7nrACfMY9NJP
 DknHSuwVVfSX8AFG7U330gvahcMz4GTmsBukziyotpx6xSN9OcRzZ8VVaZOW
 tt_CgtZWwuuqCvTrt2ePbHmMZ7Evq8gMsP3O1zikifLP8MQTdrnQCFgoQKdU
 SEtFNdXdIJx5MbjgAq10jhIuNSpHo_kQ_OM0qsM60fnNJPe_2B5Ghp8if4lC
 YgA3yUhlAFAjOBjqT_QJ5q_mx7dNJcOv18bV9ksQti8rys._0_XPrcnkRJzU
 BKA3ahu07X47Qr1Ts5vzaHnKSczk_AexezoVdyh8tcQNV4zasaA3WPniF9Ed
 FaPrBB80_iuehATHDgGltm7T72.1L1h7PfDARBhEkK6t4LA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 23 Aug 2011 14:52:25 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 13/15] x86: add cmpxchg_flag() variant
In-Reply-To: <4E53FDDA.4020304@zytor.com>
Message-ID: <alpine.DEB.2.00.1108231450130.28350@router.home>
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com> <738d736ecffa3bd32df76ae41188aa39c2ace941.1314054734.git.jeremy.fitzhardinge@citrix.com> <alpine.DEB.2.00.1108231355380.26421@router.home> <4E53FDDA.4020304@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011, H. Peter Anvin wrote:

> I keep meaning to write up a proposal for the gcc people to output
> arithmetic flag status.

Should be relatively straightforward if you make the processor flag a
builtin variable.

i.e. __processor_flag_zero, __processor_flag__gt etc.

Then the inline cmpxchg functions could simply do a

	return __processor_flag_zero;

The code generator then needs to realize from the expression that we are
referring to the zero flag and insert the correct jxx instruction.
