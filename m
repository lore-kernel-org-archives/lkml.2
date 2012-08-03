Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab2HCMpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 08:45:52 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57334 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab2HCMpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 08:45:51 -0400
References: <1343991184-3619-1-git-send-email-berrange@redhat.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <1343991184-3619-1-git-send-email-berrange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Fri, 03 Aug 2012 05:45:40 -0700
To: "Daniel P. Berrange" <berrange@redhat.com>, linux-kernel@vger.kernel.org
CC: containers@lists.linux-foundation.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Message-ID: <cfa2e2c9-db52-40cd-979b-7a6084427190@email.android.com>
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19/YpsuFb4R46d4nzYc+mOUIRMaxsevWjY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3629]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Daniel P. Berrange" <berrange@redhat.com>,
	linux-kernel@vger.kernel.org
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Forbid invocation of kexec_load() outside initial PID namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The solution is to use user namespaces and to only test ns_capable on the magic reboot path.

For the 3.7 timeframe that should be a realistic solution.

Eric
