Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab2FRKOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:14:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52874 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324Ab2FRKOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:14:01 -0400
Date: Mon, 18 Jun 2012 12:13:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: extend the fixed voltage regulator to accept
 voltage
In-Reply-To: <20120618100657.GG3974@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.64.1206181212180.23884@axis700.grange>
References: <Pine.LNX.4.64.1206181017360.23884@axis700.grange>
 <20120618094145.GC3974@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1206181145520.23884@axis700.grange>
 <20120618100657.GG3974@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:ylMnlCjaHyFyvq1FHU1DEiQgzYCYrLGFqf9UeZ1gujV
 Cg/vNMkeNP0QcNs5BIB5pRza3NCdGgtHmzt9harWjj33FvkHvM
 p//ofAYekoclrP+gN/7K9TU087pM3+YNnPqnrMMfLzfuoOEAmX
 8/tOfrgAp+DLvUAwx4u6ij/vf7xRHVRdahb/dCTa5QlTSSJiBO
 SjE8e79zGQtMaoqeu4IZY2b9p5xN7cRoExp9e6U+fpzrH4fUVn
 q1BecQa5OtFfZqllmgHAcgAIoTBUfsFMbffBIBTcH7efQcoR5d
 Fx8yPX16LgiKGpBQcNmZ8qkCnOjleoIbmbl+teZjkGNzw3//AB
 tYmtRk6ISEmBGKeM+N9xCbzm8bu7x7goRwEdVjYjzXc5YrzvJp
 bQRfAjSOhQ8Qw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012, Mark Brown wrote:

> On Mon, Jun 18, 2012 at 11:52:13AM +0200, Guennadi Liakhovetski wrote:
> 
> > Well, I never insist on being the most advanced aesthetics connaisseur, 
> > but I think these two changes are related. The point is, that if we want 
> > to support different voltages, boards will have several of these 
> > regulators, therefore they'll need different names. We could splt this, 
> > but just the first part - changing the name - would look kinda pointless 
> > without the second one, don't you think?
> 
> The major point there is I shouldn't be reading the change and going
> "hang on, this is talking about names not voltages but the changelog
> only mentioned voltages, what's that about then?".  The code looked more
> complex than I'd expect too.

Ok, I can add an explanation, why the name changes are necessary.

> I suspect we should be using kstrdup()...

I wouldn't. It would add one more kmalloc(), which is avoided with my 
approach, then it would make a memcpy(), which we also don't need, because 
we have to print the id into the string.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
