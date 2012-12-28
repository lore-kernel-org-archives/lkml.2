Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab2L1ATX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 19:19:23 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48537 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2L1ATV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 19:19:21 -0500
MIME-Version: 1.0
Message-ID: <2f3acfe3-c608-43d8-b76a-6ba69a872692@default>
Date: Thu, 27 Dec 2012 16:18:56 -0800 (PST)
From: Daniel Kiper <daniel.kiper@oracle.com>
To: <ebiederm@xmission.com>
Cc: <kexec@lists.infradead.org>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>, <tglx@linutronix.de>,
        <maxim.uvarov@oracle.com>, <andrew.cooper3@citrix.com>,
        <hpa@zytor.com>, <jbeulich@suse.com>, <mingo@redhat.com>,
        <x86@kernel.org>, <virtualization@lists.linux-foundation.org>,
        <vgoyal@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/11] kexec: introduce kexec firmware support
X-Mailer: Zimbra on Oracle Beehive
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Daniel Kiper <daniel.kiper@oracle.com> writes:
>
> > Some kexec/kdump implementations (e.g. Xen PVOPS) could not use default
> > Linux infrastructure and require some support from firmware and/or hypervisor.
> > To cope with that problem kexec firmware infrastructure was introduced.
> > It allows a developer to use all kexec/kdump features of given firmware
> > or hypervisor.
>
> As this stands this patch is wrong.
>
> You need to pass an additional flag from userspace through /sbin/kexec
> that says load the kexec image in the firmware.  A global variable here
> is not ok.
>
> As I understand it you are loading a kexec on xen panic image.  Which
> is semantically different from a kexec on linux panic image.  It is not
> ok to do have a silly global variable kexec_use_firmware.

Earlier we agreed that /sbin/kexec should call kexec syscall with
special flag. However, during work on Xen kexec/kdump v3 patch
I stated that this is insufficient because e.g. crash_kexec()
should execute different code in case of use of firmware support too.
Sadly syscall does not save this flag anywhere. Additionally, I stated
that kernel itself has the best knowledge which code path should be
used (firmware or plain Linux). If this decision will be left to userspace
then simple kexec syscall could crash system at worst case (e.g. when
plain Linux kexec will be used in case when firmware kaxec should be used).
However, if you wish I could add this flag to syscall. Additionally, I could
add function which enables firmware support and then kexec_use_firmware
variable will be global only in kexec.c module.

> Furthermore it is not ok to have a conditional
> code outside of header files.

I agree but how to dispatch execution e.g. in crash_kexec()
if we would like (I suppose) compile kexec firmware
support conditionally?

Daniel
