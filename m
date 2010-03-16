Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937930Ab0CPQQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 12:16:44 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:33283 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464Ab0CPQQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:16:42 -0400
Date: Tue, 16 Mar 2010 11:16:17 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
In-Reply-To: <4B990496.4020002@kernel.org>
Message-ID: <alpine.DEB.2.00.1003161107070.2311@router.home>
References: <4B990496.4020002@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010, Tejun Heo wrote:

> Lee Schermerhorn was trying to use percpu from slab.h and ran into a
> dependency loop.  percpu.h was using slab.h for UP inline

The problem is that percpu.h includes slab.h for the UP case. slab.h does
not use percpu.h. Lee was trying to have topology.h use percpu.h which
fails because percpu.h uses gfp.h which in turn uses topology.h again.

Did something change there or does the description need an update?

