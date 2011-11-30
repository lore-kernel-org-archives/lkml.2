Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab1K3Ew5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 23:52:57 -0500
Received: from gate.crashing.org ([63.228.1.57]:35618 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab1K3Ewx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 23:52:53 -0500
Message-ID: <1322628761.21641.40.camel@pasglop>
Subject: Re: [linux-pm] [RFC PATCH v2 4/4] cpuidle: (POWER) Handle
 power_save=off
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Date: Wed, 30 Nov 2011 15:52:41 +1100
In-Reply-To: <4ED58614.9090204@linux.vnet.ibm.com>
References: <20111117112815.9191.2322.stgit@localhost6.localdomain6>
	 <20111117112906.9191.54050.stgit@localhost6.localdomain6>
	 <1322435233.23348.19.camel@pasglop>	<4ED36A7D.9070308@linux.vnet.ibm.com>
	 <1322512771.23348.45.camel@pasglop> <4ED47F48.2070107@linux.vnet.ibm.com>
	 <4ED58614.9090204@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 06:55 +0530, Deepthi Dharwar wrote:
> I was trying to add a return value for power_save for all arch/powepc
> idle functions but a few of them directly call *.S  routines, as they
> are asm.
> 
> What would be a good way to change the return value  for asm
> routines ?
> Do we make a change in asm only, put the return value in r3 or write a
> wrapper function which would call these asm routines and return an
> int ?

No, add li r3,0 at the end, but beware that their return point might not
be ovbvious since we often return from an interrupt which modifies the
return address ... Let me know if there's some you can't figure out and
I'll help you.

Cheers,
Ben.


