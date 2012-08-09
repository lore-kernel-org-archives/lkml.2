Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab2HIAt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 20:49:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:31286 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758675Ab2HIAtc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 20:49:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,735,1336374000"; 
   d="scan'208";a="131778917"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>, Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] proc: add /proc/pid/shmaps
Thread-Topic: [PATCH 1/1] proc: add /proc/pid/shmaps
Thread-Index: AQHNdSOFftbSOl+D6U+iHLC+eDM1jZdP5BAAgAC/r4A=
Date: Thu, 9 Aug 2012 00:49:27 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE37A530@SHSMSX102.ccr.corp.intel.com>
References: <1344431059-12514-1-git-send-email-qiaowei.ren@intel.com>
 <alpine.DEB.2.00.1208081409300.7178@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1208081409300.7178@chino.kir.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your reply. There are so many contents in /proc/pid/maps, and usually only a very small minority of those are about shared memory in address space of every process. So I hope that a new file maybe provide some convenience. Could you tell me how to get such information except analyzing 'maps' file?

-----Original Message-----
From: David Rientjes [mailto:rientjes@google.com] 
Sent: Thursday, August 09, 2012 5:10 AM
To: Ren, Qiaowei
Cc: Andrew Morton; Al Viro; Oleg Nesterov; Cyrill Gorcunov; Vasiliy Kulikov; Hugh Dickins; Naoya Horiguchi; Konstantin Khlebnikov; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] proc: add /proc/pid/shmaps

On Wed, 8 Aug 2012, Qiaowei Ren wrote:

> Add a shmaps entry to /proc/pid: show information about shared memory in an address space.
> 
> People that use shared memory and want to perform an analyzing about it. For example, judge whether any memory address is shared. This file just contains 'share' part of /proc/pid/maps now. There are too many contents in maps, and so we have to do a lot of analysis to obtain relative information every time.
> 
> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>

Nack as unnecessary; /proc/pid/maps already explicitly emits 's' for VM_MAYSHARE and 'p' otherwise so this information is already available to userspace.
