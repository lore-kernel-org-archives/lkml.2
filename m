Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab1BAHdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 02:33:23 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:45891 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1BAHdV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 02:33:21 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, kosaki.motohiro@jp.fujitsu.com,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
References: <20110131225939.GH11974@redhat.com>
	<20110201071933.GA21239@cr0.nay.redhat.com>
Date: Mon, 31 Jan 2011 23:33:15 -0800
In-Reply-To: <20110201071933.GA21239@cr0.nay.redhat.com> (=?utf-8?Q?=22Am?=
 =?utf-8?Q?=C3=A9rico?= Wang"'s
	message of "Tue, 1 Feb 2011 15:19:50 +0800")
Message-ID: <m1hbcous3o.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19Xe3v2YMtr9eT/H6L0DXA9+B/aj1u8RZ0=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?;Am=c3=a9rico Wang <xiyou.wangcong@gmail.com>?=
X-Spam-Relay-Country: 
Subject: Re: Query about kdump_msg hook into crash_kexec()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang <xiyou.wangcong@gmail.com> writes:

> On Mon, Jan 31, 2011 at 05:59:39PM -0500, Vivek Goyal wrote:
>>
>>Anyway, if an image is loaded and we have setup to capture dump also
>>why do we need to save kmsg with the help of an helper. I am assuming
>>this is more of a debugging aid if we have no other way to capture the
>>kernel log buffer. So if somebody has setup kdump to capture the
>>vmcore, why to call another handler which tries to save part of the
>>vmcore (kmsg) separately.
>>
>
> Well, kmsg dumper is not only for panic/oops, it can also save kernel
> messages when the system is reboot/halt.
>
> Yeah, it is true that vmcore contains log_buf, but I think the users
> of ramoops/mtdoops are mainly those who don't have kdump configured
> in their kernels, they are cheaper than kdump, but less powerful

The issue is the inane call inside crash_kexec.

It requires both a kexec kernel to be loaded and it requires you to be
crashing.  Given that when I audited the kmsg_dump handlers they really
weren't safe in a crash dump scenario we should just remove it.

Eric
