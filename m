Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317Ab2IUW4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 18:56:21 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:39710 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758366Ab2IUWzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 18:55:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
Date: Fri, 21 Sep 2012 15:55:28 -0700
In-Reply-To: <1348152065-31353-1-git-send-email-mjg@redhat.com> (Matthew
	Garrett's message of "Thu, 20 Sep 2012 10:40:55 -0400")
Message-ID: <87bogzm1en.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19NkGXCeu0YVKSPhvr1bc6HXWkW9KimbeQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2312]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matthew Garrett <mjg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC] Second attempt at kernel secure boot support
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg@redhat.com> writes:

> This is pretty much identical to the first patchset, but with the capability
> renamed (CAP_COMPROMISE_KERNEL) and the kexec patch dropped. If anyone wants
> to deploy these then they should disable kexec until support for signed
> kexec payloads has been merged.

A couple of thoughts.

1) I don't see anything disabling kdb or kgdb.  If ever there
   was a way to poke into the kernel and change things...

2) You almost certainly want to disable module removal.  It is all to
   easy to have races where that are not properly handled in the module
   removal path.  I know I saw a bundle of those in debugfs the other
   day.

3) And half seriously you probably want to disable mounting of
   filesystems.  I believe I have heard it said the kernel has not been
   vetted against a hostile root user mounting deliberately corrupted
   filesystem images.

As it is designed I don't believe your patchset can successfully achieve
the goal of keeping a determined root user from injecting code into the
kernel without disabling so many kernel features the kernel is
uninteresting for most people to run.

Eric
