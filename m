Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968Ab0HYAiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:38:09 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52098 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab0HYAiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:38:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Anton Blanchard <anton@samba.org>
Cc: benh@kernel.crashing.org, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
References: <20100825002258.GD28360@kryten>
Date: Tue, 24 Aug 2010 17:37:57 -0700
In-Reply-To: <20100825002258.GD28360@kryten> (Anton Blanchard's message of
	"Wed, 25 Aug 2010 10:22:58 +1000")
Message-ID: <m139u37cii.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Anton Blanchard <anton@samba.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/2] kdump: Allow shrinking of kdump region to be overridden
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Blanchard <anton@samba.org> writes:

> On ppc64 the crashkernel region almost always overlaps an area of firmware.
> This works fine except when using the sysfs interface to reduce the kdump
> region. If we free the firmware area we are guaranteed to crash.

That is ppc64 bug.  firmware should not be in the reserved region.  Any
random kernel like thing can be put in to that region at any valid
address and the fact that shrinking the region frees your firmware means
that using that region could also stomp your firmware (which I assume
would be a bad thing).

So please fix the ppc64 reservation.

Eric
