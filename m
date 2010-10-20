Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab0JTT2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 15:28:54 -0400
Received: from canuck.infradead.org ([134.117.69.58]:51918 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab0JTT2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 15:28:53 -0400
Subject: Re: [RFC V1] cpuidle: add idle routine registration and cleanup
 pm_idle pointer
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: svaidy@linux.vnet.ibm.com, Andi Kleen <ak@linux.intel.com>,
        Trinabh Gupta <trinabh@linux.vnet.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4CBF4243.4040104@linux.intel.com>
References: <20101019183522.17992.86937.stgit@tringupt.in.ibm.com>
	 <4CBDE5AB.4040401@linux.intel.com>
	 <AANLkTi=cetw_mdp_3s+T4OxTfcMT2u4cdVPKxOp7jbVU@mail.gmail.com>
	 <4CBDEB14.2030304@linux.vnet.ibm.com> <4CBF06D5.7020508@linux.vnet.ibm.com>
	 <4CBF0854.6080903@linux.intel.com> <4CBF0C04.5070705@linux.intel.com>
	 <4CBF12CB.9050604@linux.intel.com>
	 <20101020191941.GA706@dirshya.in.ibm.com>
	 <4CBF4243.4040104@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Oct 2010 21:28:43 +0200
Message-ID: <1287602923.3673.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 12:25 -0700, Arjan van de Ven wrote:
> (the pm_idle is an x86 only problem. other architectures should be able 
> to keep doing what they are doing) 

sadly no, some architectures copied this brilliant piece of design.

A quick git grep suggests:
arm/blackfin/cris/ia64/m32r/m68knommu/microblaze/mn10300/sh/sparc all
have pm_idle.
