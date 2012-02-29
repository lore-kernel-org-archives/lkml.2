Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab2B2RYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:24:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53805 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758031Ab2B2RYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:24:47 -0500
Message-ID: <1330536271.11248.160.camel@twins>
Subject: Re: [PATCH v2] perf/x86: Fix HO/GO counting with SVM disabled
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, joro@8bytes.org, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Gleb Natapov <gleb@redhat.com>,
        Robert Richter <robert.richter@amd.com>
Date: Wed, 29 Feb 2012 18:24:31 +0100
In-Reply-To: <20120229170536.GE10684@amd.com>
References: <1330444544-15665-1-git-send-email-joerg.roedel@amd.com>
	 <1330523852-19566-1-git-send-email-joerg.roedel@amd.com>
	 <4F4E5999.6080600@redhat.com> <20120229170536.GE10684@amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 18:05 +0100, Joerg Roedel wrote:
> Once northbridge counters are implemented for Fam15h this check can go
> away again. 

Nope, northbridge on fam15 is completely disjoint from the regular pmu
and should thus be a separate driver.

The only reason the old amd driver has them both is because how they
shared the registers so there is a shared resource to manage.
