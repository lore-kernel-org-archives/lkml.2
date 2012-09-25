Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab2IYHF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 03:05:26 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57288 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2IYHFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 03:05:24 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <50615268.1040805@canonical.com>
References: <50609C43.1070702@canonical.com> <87txumrct6.fsf@xmission.com> <50615268.1040805@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue, 25 Sep 2012 00:05:12 -0700
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: al viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <8db34325-e8e4-4e24-85dd-c8951769e2b6@email.android.com>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+j3AmOXTO/BU+4w3EPzzE5D2Hkn8bOhAU=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1041]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Maarten Lankhorst <maarten.lankhorst@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Revert "__d_unalias() should refuse to move mountpoints"
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:

>Hey,
>
>Op 25-09-12 05:39, Eric W. Biederman schreef:
>> Maarten Lankhorst <maarten.lankhorst@canonical.com> writes:
>>
>>> This reverts commit ee3efa91e240f513898050ef305a49a653c8ed90.
>>>
>>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>>>
>>> My thread about the regression seemed to have been ignored, so I can
>only
>>> conclude nobody objects against a full revert of this patch.
>>>
>>> My testcase is simply booting through netboot with / and ~/nfs as
>separate
>>> nfs filesystems, then doing 'ls ~/nfs' followed by 'ls ~' in a
>gnome-terminal
>>> window, then I get:
>> Do I read your description correctly:  Without using a bind mount you
>> have the same nfs filesystem mounted on / and on ~/nfs?
>>
>> Something is definitely off with your configuration but if to work
>you
>> need to move mount points around then that something seems much
>deeper
>> than the __d_unalias change.
>>
>> What filesystems do you have mounted where?
>>
>/ is a nfs filesystem, ~/nfs is a different nfs filesystem.

Are both filesystems on the same server?

Are the two filesystems distinct filesystem on the server?

Unless there is duplication of something somewhere the d_unalias code should not trigger.

> Just doing
>ls / is enough
>to make all filesystems mounted on / return -EBUSY and disappear.
>
>I also have a subdir of ~/nfs/ bind mounted to /lib/modules/$(uname
>-r)/kernel
>for easy debugging so just doing 'make' in the kernel tree is enough to
>get the
>new modules + bzImage, but I don't know if it is a factor in
>reproducing this bug
>or not.

Unlikely.  But interesting.  It at least fits the criteria of showing up to different places.  It should not be enough for d_materialise uniqe.

Eric


