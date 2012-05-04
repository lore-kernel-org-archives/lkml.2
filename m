Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab2EDVCC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:02:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:33335 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592Ab2EDVB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 17:01:58 -0400
Message-ID: <1336165294.6509.76.camel@twins>
Subject: Re: [PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets
 handling upon CPU hotplug
From: Peter Zijlstra <peterz@infradead.org>
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mingo@kernel.org,
        pjt@google.com, paul@paulmenage.org, akpm@linux-foundation.org,
        rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, rob@landley.net,
        tj@kernel.org, mschmidt@redhat.com, berrange@redhat.com,
        nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Fri, 04 May 2012 23:01:34 +0200
In-Reply-To: <20120504204908.GC18177@linux.vnet.ibm.com>
References: <20120504191535.4603.83236.stgit@srivatsabhat>
	 <1336159496.6509.51.camel@twins> <4FA434E9.6000305@linux.vnet.ibm.com>
	 <1336162456.6509.63.camel@twins> <1336163281.6509.69.camel@twins>
	 <20120504204908.GC18177@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 13:49 -0700, Nishanth Aravamudan wrote:
> I think it's ok for hotplug to be destructive. But I guess I'm not
> entirely sure why cpusets can't retain user-inputted
> configuration/policy information even while destroying things currently?
> And re-instating that policy if possible in the future? 

Two issues here:
 - if you retain it for cpuset but not others that's confusing (too);
 - we never retain anything, if you unload a module you loose all state
that was associated with it too. What makes this special?


