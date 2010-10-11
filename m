Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab0JKWKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:10:18 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34911 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab0JKWKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:10:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Alok Kataria <akataria@vmware.com>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        Haren Myneni <hbabu@us.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
        jeremy@xensource.com
References: <1286570087.8769.27.camel@ank32.eng.vmware.com>
	<1286816964.1372.2.camel@ank32.eng.vmware.com>
	<m1lj64ppri.fsf@fess.ebiederm.org>
	<1286826083.1372.15.camel@ank32.eng.vmware.com>
	<20101011213901.GR12743@redhat.com>
Date: Mon, 11 Oct 2010 15:10:11 -0700
In-Reply-To: <20101011213901.GR12743@redhat.com> (Vivek Goyal's message of
	"Mon, 11 Oct 2010 17:39:01 -0400")
Message-ID: <m1hbgs5qkc.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH] Bug during kexec...not all cpus are stopped
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Mon, Oct 11, 2010 at 12:41:23PM -0700, Alok Kataria wrote:

> I don't think that kdump path uses smp_send_stop().

It doesn't.

> IIUC, on x86, we directly send NMI to other cpus.
>
> native_machine_crash_shutdown()
>   kdump_nmi_shootdown_cpus()
>         nmi_shootdown_cpus()
>            smp_send_nmi_allbutself
>                 apic->send_IPI_allbutself(NMI_VECTOR);
>
> So above description should be limited to only panic() path.

Is it actually confusing?  With respect to documenting the line
of thinking it seems reasonable.

> On a side note, I am wondering why panic() and kdump path can't share the
> shutdown routine.

Hysterical raisins.  Andi's change to smp_send_stop says that NMIs not
working on some boxes.  When someone wants to weed through all of the
insanity it would probably be good to get the panic and the kdump paths
sharing code.  For now simply separating panic and reboot should be
enough, and it lets the code evolve where it needs to.

Eric
