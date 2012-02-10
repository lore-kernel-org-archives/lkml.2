Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab2BJPDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:03:50 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:33619 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2BJPDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:03:49 -0500
X-IronPort-AV: E=Sophos;i="4.73,396,1325462400"; 
   d="scan'208";a="10624809"
Message-ID: <1328886226.6133.271.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen/cpu: Make VCPU hotplug code online CPUs
 properly.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Date: Fri, 10 Feb 2012 15:03:46 +0000
In-Reply-To: <1328885033-8450-2-git-send-email-konrad.wilk@oracle.com>
References: <1328885033-8450-1-git-send-email-konrad.wilk@oracle.com>
	 <1328885033-8450-2-git-send-email-konrad.wilk@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 14:43 +0000, Konrad Rzeszutek Wilk wrote:
> Offlining CPUs works. Onlining does not work anymore and it looks
> like we were missing a cpu_up() call in the hotplug bring up path.

Wasn't this a deliberate decision as part of the pvops upstreaming to be
consistent with native cpu hotplug? After hotplugging a CPU
administrator action is needed to actually online it.

http://xen.1045712.n5.nabble.com/cpu-down-but-no-cpu-up-in-drivers-xen-cpu-hotplug-c-td2545244.html

The fix is to add a udev rule:
http://wiki.xen.org/wiki/Paravirt_Linux_CPU_Hotplug

Ian.


