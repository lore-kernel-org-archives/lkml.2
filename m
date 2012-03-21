Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389Ab2CUR4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 13:56:55 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:33205 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758914Ab2CUR4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 13:56:53 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 8o2l2ikVM1kAbZ0OLyC3g9PW47_aMfw1Z4lB0miq6g30CjS
 RltXeSM0iG4u3xJ6zj6_F9Wp66FudAPSUCgpZ_.546eIt1PnpC2XOfTcq5Hl
 M42Fw654th9doNYL52EYBj4tWmcOZU5Y6OXdW8DP1U5kUirwmGmN3siF3BAn
 k0nYlp2SFPZ1fDT1rE6fIzG4vGAygm.gfdc7.NJOfVBd.LVCnVsygB_5axm5
 0muY_exS8ELHPfT6AM.PQk8uL44a7gLfVreIBoGgayrVHjT3jBgh_cLkBa95
 bHR5jOuC4f0_xAF9uQBPuHDWzxJiUx2Y87FHlAbIvymb4a2dkFOZI_ooGu7O
 x9azEYzIRMwGY.hS0uAfghX0cObfRRyXmn1e1MIiya8eTLW9DckP0POmeQbZ
 G
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 21 Mar 2012 12:56:50 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: Patch workqueue: create new slab cache instead of hacking
In-Reply-To: <20120321160910.GB4246@google.com>
Message-ID: <alpine.DEB.2.00.1203211255290.21932@router.home>
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com> <1332238884-6237-7-git-send-email-laijs@cn.fujitsu.com> <20120320154619.GA5684@google.com> <4F6944D9.5090002@cn.fujitsu.com> <CAOS58YPydFUap4HjuRATxza6VZgyrXmQHVxR83G7GRJL50ZTRQ@mail.gmail.com>
 <alpine.DEB.2.00.1203210910450.20482@router.home> <20120321160910.GB4246@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012, Tejun Heo wrote:

> I don't know.  At this point, this is only for singlethread and
> unbound workqueues and we don't have too many of them left at this
> point.  I'd like to avoid creating a slab cache for this.  How about
> just leaving it be?  If we develop other use cases for larger
> alignments, let's worry about implementing something common then.

We could write a function that identifies a compatible kmalloc cache
or creates a new one if necessary. That would cut down overhead similar to
what slub merge is doing but allows more control by the developer.

