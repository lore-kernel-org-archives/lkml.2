Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab2L0HyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 02:54:15 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:46760 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2L0HyM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 02:54:12 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <50DBC856.6030208@zytor.com>
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com> <50DBC856.6030208@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 26 Dec 2012 23:53:49 -0800
To: "H. Peter Anvin" <hpa@zytor.com>, Daniel Kiper <daniel.kiper@oracle.com>
CC: andrew.cooper3@citrix.com, jbeulich@suse.com, konrad.wilk@oracle.com,
        maxim.uvarov@oracle.com, mingo@redhat.com, tglx@linutronix.de,
        vgoyal@redhat.com, x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
Message-ID: <791b4922-078f-4adc-b3f3-0651f2266147@email.android.com>
X-XM-AID: U2FsdGVkX199+ev+/tViEeWqlkGu3MFRoDsmM2/fLpA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0942]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>,Daniel Kiper
	<daniel.kiper@oracle.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 00/11] xen: Initial kexec/kdump implementation
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The syscall ABI still has the wrong semantics.

Aka totally unmaintainable and umergeable.

The concept of domU support is also strange.  What does domU support even mean, when the dom0 support is loading a kernel to pick up Xen when Xen falls over.

I expect a lot of decisions about what code can be shared and what code can't is going to be driven by the simple question what does the syscall mean.

Sharing machine_kexec.c and relocate_kernel.S does not make much sense to me when what you are doing is effectively passing your arguments through to the Xen version of kexec.

Either Xen has it's own version of those routines or I expect the Xen version of kexec is buggy.   I can't imagine what sharing that code would mean.  By the same token I can't any need to duplicate the code either.

Furthermore since this is just passing data from one version of the syscall to another I expect you can share the majority of the code across all architectures that implement Xen.  The only part I can see being arch specific is the Xen syscall stub.

With respect to the proposed semantics of silently giving the kexec system call different meaning when running under Xen,
/sbin/kexec has to act somewhat differently when loading code into the Xen hypervisor so there is no point not making that explicit in the ABI.

Eric

