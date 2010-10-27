Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab0J0UIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 16:08:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43198 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab0J0UIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 16:08:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject;
        b=CAlngXBHrbCfqQ6JS7snEPUKwOUcFodIbhsEAYDhEMRrfm/lKrQBoXLf3/F1hAsDWv
         fCGHFDH/73+CHkGk8EXtY7rhNFdB5BhDba+7KUs5l5MacReqSqQ1TC8MJjy5qlj0S3r4
         xWmyxiB2cUXI2u8vt33jd29naMmP0M+nrwolg=
Message-Id: <20101027195352.996250316@openvz.org>
User-Agent: quilt/0.47-1
Date: Wed, 27 Oct 2010 23:53:53 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [rfc -tip 0/2] Implementing self IPI with NMI destination
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Here is self-IPI with NMI destination implemented. Don was testing
perf NMI's and we found that we don't have a simple call for self-nmi IPI.

 So there is two way of implementing such facility:

1) Make .send_IPI_self to check for NMI_VECTOR in arguments
   and convert this call internally to NMI IPI with self in
   destination.

2) Make a separate .send_IPI_self_nmi function and call it only
   if needed.

 The series implements 1st choise but I tend to think that 2nd might
be more preferred since it would not bring overhead into .send_IPI_self
and would make code a bit less messed.

 Anyway, this series is not for merging yet but rather to collect
complains about this approach. And to be fair we seem don't have
x2apic machine at moment so x2apic mode is not tested at all.

 In short -- please check and review this two patches. Anything
is welcome ;)

 Cyrill
