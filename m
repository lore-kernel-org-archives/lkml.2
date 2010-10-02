Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab0JBDEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 23:04:14 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:45142 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab0JBDEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 23:04:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Robin Holt <holt@sgi.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org
References: <20101001200143.GR14064@sgi.com>
	<alpine.DEB.2.00.1010011335400.2305@ubuntu>
Date: Fri, 01 Oct 2010 20:04:06 -0700
In-Reply-To: <alpine.DEB.2.00.1010011335400.2305@ubuntu> (Davide Libenzi's
	message of "Fri, 1 Oct 2010 13:37:08 -0700 (PDT)")
Message-ID: <m1vd5ll2hl.fsf@fess.ebiederm.org>
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
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Davide Libenzi <davidel@xmailserver.org>
X-Spam-Relay-Country: 
Subject: Re: max_user_watches overflows on 16TB system.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi <davidel@xmailserver.org> writes:

> On Fri, 1 Oct 2010, Robin Holt wrote:
>
>> 
>> Following a boot of a 16TB system, we noticed that the max_user_watches
>> sysctl was negative.  Is there any downside to converting that to a
>> static long and handling the fallout from the change?  I believe that
>> fallout includes changing the definition of epoll_watches over to an
>> atomic_long_t as well.
>> 
>> Alternatively should we just limit max_user_watches to INT_MAX?
>
> 2B watches looks an acceptable limit to me, at least for now.
> Nobody complained about not having enough of them so far.

Which suggests that we need to force the boot time calculation to not
exceed 2B.

>From the sysctl interface perspective now that all of it is exported as
ascii strings I don't see a problem there.

Eric
