Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab2GCJEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:04:08 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:53019 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab2GCJEH convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 3 Jul 2012 05:04:07 -0400
Message-Id: <4FF2D1DA020000780008D433@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 03 Jul 2012 10:04:58 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <gcosta@redhat.com>,
        <hpa@zytor.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, <linux-kernel@vger.kernel.org>
Subject: __force_order usage on x86's CRn accesses
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pretty soon after the introduction of this via "x86: unify paravirt
parts of system.h" Jeremy had posted a patch to correct the
(reversed in direction of access) constraints using that auxiliary
variable. What happened to that change? Was it dropped for a
reason?

Furthermore, the addition of these constraints happened
without any real explanation - the code comment that was added
doesn't really help understand why "volatile" isn't sufficient here.

Next, I also saw it being suggested somewhere to replace the
static definition of the variable (causing an instance to appear
everywhere any of the referencing inline function being used)
by an extern one. That also never got carried out, causing
about two dozen pointless instances of this variable to be
scattered around, likely consuming cache bandwidth here and
there.

Now, rather than exporting an auxiliary variable like this, how
about using an existing, rarely referenced (at least in affected
contexts) but already exported one instead?
empty_zero_page, __supported_pte_mask, x86_platform, or
high_memory might be candidates.

Finally (and this is because I lack the explanation why the
artificial constraint is needed in the first place), why is it that
clts() doesn't need one too?

Thanks, Jan

