Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab1GPUL5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 16:11:57 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49978 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059Ab1GPUL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 16:11:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Matthew Garrett <mjg@redhat.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        "tony.luck\@intel.com" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jarod Wilson <jwilson@redhat.com>, "hpa\@zytor.com" <hpa@zytor.com>,
        "dle-develop\@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C17AAE59A@USINDEVS01.corp.hds.com>
	<m14o2mjj5l.fsf@fess.ebiederm.org>
	<20110716162805.GA13127@srcf.ucam.org>
Date: Sat, 16 Jul 2011 13:11:47 -0700
In-Reply-To: <20110716162805.GA13127@srcf.ucam.org> (Matthew Garrett's message
	of "Sat, 16 Jul 2011 17:28:06 +0100")
Message-ID: <m1hb6mgf3w.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19B0IsN8CTPG0sP1UTFUaUBpgX9jJzf078=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matthew Garrett <mjg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH] Replace a function call chain of kmsg_dump(KMSG_DUMP_KEXEC) with static function calls
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg@redhat.com> writes:

2> On Sat, Jul 16, 2011 at 09:16:06AM -0700, Eric W. Biederman wrote:
>
>> What is going on with EFI support?  We are still making efi calls in
>> virtual mode, and we don't have the one unified identity mapped physical
>> page table that hpa and I think others were working a while back.  Even
>> if because of bugs we need to transition EFI to virtual mode we can
>> still set physical to virtual so we don't have to deal with the nonsense.
>
> No, we can't. It doesn't work.
>
>> Can we please make our EFI support ask the minimal from EFI before
>> adding lots more to it?
>
> No.
>
>> Am I wrong in thinking that the core motivation behind this patch is
>> that our EFI support sucks and thus kdump on EFI does not work on some
>> platforms?
>
> Yes, you are.

Will someone please give some explanation?

Without some real understanding of what is going on I'm not inclined
to meet any of this half way and summarily reject every change to
the kexec on panic code path.

Eric
