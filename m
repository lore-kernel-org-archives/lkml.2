Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab0JTUEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 16:04:05 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:58672 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab0JTUED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 16:04:03 -0400
Date: Thu, 21 Oct 2010 01:33:21 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Trinabh Gupta <trinabh@linux.vnet.ibm.com>, peterz@infradead.org,
        lenb@kernel.org, suresh.b.siddha@intel.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC V1] cpuidle: add idle routine registration and cleanup
 pm_idle pointer
Message-ID: <20101020200321.GC706@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <4CBDEB14.2030304@linux.vnet.ibm.com>
 <4CBF06D5.7020508@linux.vnet.ibm.com>
 <4CBF0854.6080903@linux.intel.com>
 <4CBF0C04.5070705@linux.intel.com>
 <4CBF12CB.9050604@linux.intel.com>
 <20101020191941.GA706@dirshya.in.ibm.com>
 <4CBF4243.4040104@linux.intel.com>
 <20101020194045.GB706@dirshya.in.ibm.com>
 <4CBF4693.1070802@linux.intel.com>
 <AANLkTimNWYuP0e03xTq4Yg7Sb1RPHsQjC2X4wpf1CcPB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimNWYuP0e03xTq4Yg7Sb1RPHsQjC2X4wpf1CcPB@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Venkatesh Pallipadi <venki@google.com> [2010-10-20 12:47:22]:

> >> Ok, you are suggesting that for x86 lets move cpuidle in kernel
> >> always, while it can be an optional module for other archs as it
> >> stands today.  We can slim down the cpuidle from current 7K or atleast
> >> split some parts like governors as modules if needed.
> >
> > governors as modules is a total pain. modules don't solve the problem.
> > really. it's still code you need.
> > we have two governors today, menu and ladder
> > menu is best on anything that is tickless
> > ladder is useless on any tickless kernel, and likely not better than menu on
> > non-tickless.
> > that's it.
> > It will be good to have other archs also follow the same cpuidle
> 
> I don't think they have to be modules. There can be a CPUIDLE_LITE
> which deCONFIG entire governor.c and individual governors (and
> probably sysfs stuff as well) for archs that can only use one state at
> any time, but still want to do config or runtime detection of one
> state and register that state.

hmm, CPUIDLE_LITE should resemble this patch, where there is only
simple single idle routine registration.  If the full CPUIDLE is
picked at compile time (default for x86), we could have all the
features.

Sounds like a good option to try.

--Vaidy

