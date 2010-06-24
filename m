Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0FXNd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 09:33:26 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41830 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab0FXNdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 09:33:25 -0400
Date: Thu, 24 Jun 2010 15:33:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org,
       mauro@elte.hu
Subject: Re: [RFC][PATCH] irq_work
Message-ID: <20100624133323.GN578@basil.fritz.box>
References: <1277375409.1875.943.camel@laptop>
 <20100624105254.GB578@basil.fritz.box>
 <1277377121.1875.948.camel@laptop>
 <20100624110830.GC578@basil.fritz.box>
 <1277377852.1875.950.camel@laptop>
 <20100624112340.GA13502@elte.hu>
 <1277379294.1875.959.camel@laptop>
 <20100624123537.GA28884@elte.hu>
 <20100624130234.GM578@basil.fritz.box>
 <20100624132032.GA4474@kryptos.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624132032.GA4474@kryptos.osrc.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If its a critical error you do all the handling in the kernel and you

I assume you mean in MCE.  And the answer is no.

MCE generally can only panic or log, everything else
needs other contexts.

> don't need task context at all, no? 

Process context is needed for various recovery schemes, all
that need to sleep for example.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
