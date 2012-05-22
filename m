Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab2EVVGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 17:06:04 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:47941 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab2EVVGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 17:06:01 -0400
Message-ID: <4FBBFFB5.3010605@de.ibm.com>
Date: Tue, 22 May 2012 23:05:57 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>
Subject: qemu core dump and filtering guest pages
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12052221-2966-0000-0000-0000042972F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

today we discussed the situation of a qemu crash (with coredump) and big guests.
Quite often the guest pages are not needed but make the core file pretty big.

The most appealing proposal that we had was to adopt the core file code in the 
kernel to have an option for discarding guest pages (e.g. /proc/sys/core_guest).
do_corefile would have a callback into the kvm module that could use its memory 
slot infrastructure to decide if this page should be saved or not.

Would you consider such a change be ok? Any better idea?
Thanks

Christian


