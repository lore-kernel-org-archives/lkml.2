Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab1HZSJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:09:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46846 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1HZSJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:09:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=O5KLREt6a3OZikaraD22wfmkZ+I2IwuSnZ1mbNBZmDO317pTY/mtkbMstGKTJJo23
	M3DTkLSPEFK9AGulG/iJw==
Date: Fri, 26 Aug 2011 11:09:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
cc: Michal Hocko <mhocko@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] oom: skip frozen tasks
In-Reply-To: <4E576E6F.1030909@openvz.org>
Message-ID: <alpine.DEB.2.00.1108261106570.13943@chino.kir.corp.google.com>
References: <20110823073101.6426.77745.stgit@zurg> <alpine.DEB.2.00.1108231313520.21637@chino.kir.corp.google.com> <20110824101927.GB3505@tiehlicka.suse.cz> <alpine.DEB.2.00.1108241226550.31357@chino.kir.corp.google.com> <20110825091920.GA22564@tiehlicka.suse.cz>
 <20110825151818.GA4003@redhat.com> <20110825164758.GB22564@tiehlicka.suse.cz> <alpine.DEB.2.00.1108251404130.18747@chino.kir.corp.google.com> <4E574CA5.4010701@openvz.org> <alpine.DEB.2.00.1108260209050.14732@chino.kir.corp.google.com>
 <4E576E6F.1030909@openvz.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011, Konstantin Khlebnikov wrote:

> Maybe just fix this "panic" logic? OOM killer should panic only on global
> memory shortage.
> 

NO, it shouldn't, we actually rely quite extensively on cpusets filled 
with OOM_DISABLE threads to panic because the job scheduler would be 
unresponsive in such a condition and it'd much better to panic and reboot 
than to brick the machine.  I'm not sure where you're getting all your 
information from, but please don't pass it off as principles.

You can set the panic logic to be whatever you want with 
/proc/sys/vm/panic_on_oom.  See Documentation/filesystems/proc.txt for 
more information.
