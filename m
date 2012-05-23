Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965106Ab2EWPRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:17:08 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:42810 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933677Ab2EWPRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:17:06 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: GY3TyjgVM1k1zuuyH662I9sJjMhdA9ZXZts3ttZCrC3bksc
 75egryCs9GO9VeGKqyYxR0al65KeDyHMQvoQWQ0iFRapyfrK6vHc7ygFi2Y.
 d2MlUerhUp1sJ9q5S5LsohYU2NNK84TJqoUqRdx6ULFliFGs9EUT0IiRk8YJ
 I2YGD93UrDlq.yw4H_NKOrv3GICX4ubQl1zklTahaOigm4pBWuOOC9GYANuk
 lGNpWdnSRw7LtfzalMpVP4fQBgTk2MftqyAd6R0r6irPYNNdTqhDI0h19Tck
 W0WUOt9RTexZd1xmv2WHG2mUsrjKwXpw7LLq3FWgeB6EDcJMwAmy6KMC0oW8
 CceANfiLtMoB_6Tcwlt8G1zTAvVpnBMWaA_vsm.6nOQCMSNcUD2OboMKGw79
 v
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 23 May 2012 10:17:02 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab+slob: dup name string
In-Reply-To: <4FBCFBE0.2080803@parallels.com>
Message-ID: <alpine.DEB.2.00.1205231012330.30940@router.home>
References: <1337613539-29108-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com> <alpine.DEB.2.00.1205220855470.17600@router.home> <4FBBAE95.6080608@parallels.com> <alpine.DEB.2.00.1205221216050.17721@router.home>
 <alpine.DEB.2.00.1205221529340.18325@chino.kir.corp.google.com> <1337773595.3013.15.camel@dabdike.int.hansenpartnership.com> <4FBCD328.6060406@parallels.com> <1337775878.3013.16.camel@dabdike.int.hansenpartnership.com> <alpine.DEB.2.00.1205230947490.30940@router.home>
 <4FBCFBE0.2080803@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Glauber Costa wrote:

> So if I understand it correctly, this is mostly because the name string
> outlives the cache in the slub case, because of merging ?

Well this means we really only need the copying in slub which we already
have.

The problem is that you want to make this behavior uniform over all
allocators so that you do not have to allocate the string on your own.

Could you wait (and not rely on copying) until I am through with the
extraction project for common code for the allocators? At that point we
can resolve this issue consistently for all allocators.



