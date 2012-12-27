Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab2L0Eqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 23:46:45 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:52622 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab2L0Eqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 23:46:43 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: andrew.cooper3@citrix.com, hpa@zytor.com, jbeulich@suse.com,
        konrad.wilk@oracle.com, maxim.uvarov@oracle.com, mingo@redhat.com,
        tglx@linutronix.de, vgoyal@redhat.com, x86@kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
	<1356574740-6806-2-git-send-email-daniel.kiper@oracle.com>
Date: Wed, 26 Dec 2012 20:46:27 -0800
In-Reply-To: <1356574740-6806-2-git-send-email-daniel.kiper@oracle.com>
	(Daniel Kiper's message of "Thu, 27 Dec 2012 03:18:50 +0100")
Message-ID: <878v8k14rg.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18rsRec3wATcqzfXwQLf4ni+qRkbNyrxEQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Daniel Kiper <daniel.kiper@oracle.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 01/11] kexec: introduce kexec firmware support
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kiper <daniel.kiper@oracle.com> writes:

> Some kexec/kdump implementations (e.g. Xen PVOPS) could not use default
> Linux infrastructure and require some support from firmware and/or hypervisor.
> To cope with that problem kexec firmware infrastructure was introduced.
> It allows a developer to use all kexec/kdump features of given firmware
> or hypervisor.

As this stands this patch is wrong.

You need to pass an additional flag from userspace through /sbin/kexec
that says load the kexec image in the firmware.  A global variable here
is not ok.

As I understand it you are loading a kexec on xen panic image.  Which
is semantically different from a kexec on linux panic image.  It is not
ok to do have a silly global variable kexec_use_firmware.

Furthermore it is not ok to have a conditional code outside of header
files.

Eric
