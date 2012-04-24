Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab2DXKmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 06:42:23 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49892 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab2DXKmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 06:42:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <andi@firstfloor.org>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com
References: <20120416021951.9303.58568.stgit@localhost6.localdomain6>
	<20120416022139.9303.56284.stgit@localhost6.localdomain6>
	<m2ipgqoh90.fsf@firstfloor.org>
	<20120424.110518.434300178.d.hatayama@jp.fujitsu.com>
	<20120424080420.GA27374@one.firstfloor.org>
Date: Tue, 24 Apr 2012 03:46:24 -0700
In-Reply-To: <20120424080420.GA27374@one.firstfloor.org> (Andi Kleen's message
	of "Tue, 24 Apr 2012 10:04:20 +0200")
Message-ID: <m1ipgpo1a7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19cDCLDM6POiAvunKITVAFZMGw9OMkGG4I=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andi Kleen <andi@firstfloor.org>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 2/2] Enter 2nd kernel with BSP
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

>> native_cpu_up avoids to wake up cpu with boot_cpu_physical_apicid, but
>
> Ok so that check needs to go then. I wonder why it is there.

As I remember we had a check to avoid waking up the current cpu
we are running on, and there was something about the value for
the current cpu coming from BIOS tables etc.  Because of all of the
silliness in how we get the apicid for the current cpu I seem to
remember the case where we start all of our secondary processors
to periodically regress.

>> the boot_cpu_physical_apicid would be just a boot cpu now, which could
>> be non-BSP on the 2nd kernel; equal to crashing cpu on the 1st
>> kernel. It would need to check explicitly whether a given cpu is BSP
>> or not and this would be better fix here. This is suggested by Eric.

Yes.  My two reasons for designing the crash path the way I did was
that we might have offlined/hot-unplugged the boot cpu, or the bootcpu
might have gotten itself into a terrible state.  Since we want as much
reliability in kexec on panic we don't bother trying to restore it.

The normal reboot path, and a normal kexec tries to reboot on the boot
cpu primarily because there are a lot of BIOS's out there that if you
talk to them on anything other than the boot cpu they get confused.

Eric
